"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { getTenantContext } from "@/lib/data/tenant";

const paths=()=>{ revalidatePath("/units"); revalidatePath("/bookings"); revalidatePath("/weekly-summary"); };
export async function createBooking(_state:{error?:string},form:FormData){
  const unitId=String(form.get("unit_id")||""); const purchaser=String(form.get("purchaser_name")||"").trim(); const agent=String(form.get("agent_name")||"").trim(); const amount=Number(form.get("earnest_deposit_amount")||0);
  if(!unitId||!purchaser||!agent) return {error:"Purchaser name and agent name are required."}; if(amount<0) return {error:"Deposit cannot be negative."};
  const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data:unit}=await db.from("units").select("unit_number,status").eq("id",unitId).eq("organization_id",tenant.organizationId).single(); if(!unit||unit.status!=="available") return {error:"This unit is already booked"};
  const {data,error}=await db.from("bookings").insert({organization_id:tenant.organizationId,unit_id:unitId,purchaser_name:purchaser,purchaser_ic:String(form.get("purchaser_ic")||"")||null,purchaser_email:String(form.get("purchaser_email")||"")||null,purchaser_phone:String(form.get("purchaser_phone")||"")||null,earnest_deposit_amount:amount,agent_name:agent}).select("id").single();
  if(error) return {error:error.code==="23505"?"This unit is already booked":error.message};
  const {error:unitError}=await db.from("units").update({status:"booked"}).eq("id",unitId).eq("organization_id",tenant.organizationId).eq("status","available"); if(unitError){ await db.from("bookings").delete().eq("id",data.id).eq("organization_id",tenant.organizationId); return {error:unitError.message}; }
  await db.from("audit_logs").insert({organization_id:tenant.organizationId,action:"booking_created",entity_type:"booking",entity_id:data.id,details:{unit_number:unit.unit_number,purchaser,agent,amount}});
  paths(); redirect(`/bookings/${data.id}?created=1`);
}
export async function updateChecks(id:string,form:FormData){ const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const previous=await db.from("bookings").select("earnest_deposit_paid,units(unit_number)").eq("id",id).eq("organization_id",tenant.organizationId).single(); const paid=form.get("earnest_deposit_paid")==="on"; const signed=form.get("booking_form_signed")==="on"; const updates:any={earnest_deposit_paid:paid,booking_form_signed:signed,deposit_paid_at:paid?new Date().toISOString():null}; const {error}=await db.from("bookings").update(updates).eq("id",id).eq("organization_id",tenant.organizationId); if(error) throw new Error(error.message); if(paid&&!previous.data?.earnest_deposit_paid) await db.from("audit_logs").insert({organization_id:tenant.organizationId,action:"deposit_confirmed",entity_type:"booking",entity_id:id,details:{unit_number:(previous.data?.units as any)?.unit_number}}); paths(); revalidatePath(`/bookings/${id}`); }
export async function confirmBooking(id:string,form:FormData){ const approver=String(form.get("approved_by")||"Sales Department").trim(); const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data,error}=await db.from("bookings").update({status:"confirmed",sales_dept_approved_by:approver,approved_at:new Date().toISOString()}).eq("id",id).eq("organization_id",tenant.organizationId).eq("status","pending").select("units(unit_number)").single(); if(error) throw new Error(error.message); await db.from("audit_logs").insert({organization_id:tenant.organizationId,action:"booking_confirmed",entity_type:"booking",entity_id:id,details:{unit_number:(data.units as any)?.unit_number,approved_by:approver}}); paths(); revalidatePath(`/bookings/${id}`); }
export async function cancelBooking(id:string){ const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data,error}=await db.from("bookings").update({status:"cancelled"}).eq("id",id).eq("organization_id",tenant.organizationId).eq("status","pending").select("unit_id,units(unit_number)").single(); if(error) throw new Error(error.message); await db.from("units").update({status:"available"}).eq("id",data.unit_id).eq("organization_id",tenant.organizationId); await db.from("audit_logs").insert({organization_id:tenant.organizationId,action:"booking_cancelled",entity_type:"booking",entity_id:id,details:{unit_number:(data.units as any)?.unit_number}}); paths(); redirect("/bookings"); }

export async function selectWorkspace(form:FormData){
  const organizationId=String(form.get("organization_id")||"");
  const db=await createClient();
  const {data:{user}}=await db.auth.getUser();
  if(!user) return;
  const {data}=await db.from("organization_members").select("organization_id").eq("organization_id",organizationId).eq("user_id",user.id).maybeSingle();
  if(!data) throw new Error("You do not belong to that workspace.");
  (await cookies()).set("aira_workspace",organizationId,{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV==="production"});
  revalidatePath("/", "layout");
  redirect("/units");
}
