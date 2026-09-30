import { createClient } from "@/lib/supabase/server";
import type { Unit } from "@/lib/types";
import { getTenantContext } from "@/lib/data/tenant";

export async function getUnits(): Promise<Unit[]> {
  const [db, tenant]=await Promise.all([createClient(), getTenantContext()]);
  const {data,error}=await db.from("units").select("*").eq("organization_id",tenant.organizationId).order("status").order("tower").order("floor").order("selling_price");
  if(error) throw new Error(error.message);
  return data as Unit[];
}
export async function getUnit(id:string): Promise<Unit> {
  const [db, tenant]=await Promise.all([createClient(), getTenantContext()]); const {data,error}=await db.from("units").select("*").eq("id",id).eq("organization_id",tenant.organizationId).single();
  if(error) throw new Error(error.message); return data as Unit;
}
