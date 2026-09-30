import { createClient } from "@/lib/supabase/server";
import type { Unit } from "@/lib/types";

export async function getUnits(): Promise<Unit[]> {
  const db=await createClient();
  const {data,error}=await db.from("units").select("*").order("status").order("tower").order("floor").order("selling_price");
  if(error) throw new Error(error.message);
  return data as Unit[];
}
export async function getUnit(id:string): Promise<Unit> {
  const db=await createClient(); const {data,error}=await db.from("units").select("*").eq("id",id).single();
  if(error) throw new Error(error.message); return data as Unit;
}
