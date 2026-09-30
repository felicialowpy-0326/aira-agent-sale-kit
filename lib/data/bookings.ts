import { createClient } from "@/lib/supabase/server";
import type { Booking } from "@/lib/types";

const selection="*, units(*)";
export async function getBookings():Promise<Booking[]> { const db=await createClient(); const {data,error}=await db.from("bookings").select(selection).order("booking_date",{ascending:false}); if(error) throw new Error(error.message); return data as unknown as Booking[]; }
export async function getBooking(id:string):Promise<Booking> { const db=await createClient(); const {data,error}=await db.from("bookings").select(selection).eq("id",id).single(); if(error) throw new Error(error.message); return data as unknown as Booking; }
export async function getWeeklyBookings(start:string,end:string):Promise<Booking[]> { const db=await createClient(); const {data,error}=await db.from("bookings").select(selection).gte("booking_date",start).lte("booking_date",end).neq("status","cancelled").order("booking_date",{ascending:false}); if(error) throw new Error(error.message); return data as unknown as Booking[]; }
