import { createClient } from "@/lib/supabase/server";
import type { Booking } from "@/lib/types";
import { getTenantContext } from "@/lib/data/tenant";

const selection="*, units(*)";
export async function getBookings():Promise<Booking[]> { const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data,error}=await db.from("bookings").select(selection).eq("organization_id",tenant.organizationId).order("booking_date",{ascending:false}); if(error) throw new Error(error.message); return data as unknown as Booking[]; }
export async function getBooking(id:string):Promise<Booking> { const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data,error}=await db.from("bookings").select(selection).eq("id",id).eq("organization_id",tenant.organizationId).single(); if(error) throw new Error(error.message); return data as unknown as Booking; }
export async function getWeeklyBookings(start:string,end:string):Promise<Booking[]> { const [db,tenant]=await Promise.all([createClient(),getTenantContext()]); const {data,error}=await db.from("bookings").select(selection).eq("organization_id",tenant.organizationId).gte("booking_date",start).lte("booking_date",end).neq("status","cancelled").order("booking_date",{ascending:false}); if(error) throw new Error(error.message); return data as unknown as Booking[]; }
