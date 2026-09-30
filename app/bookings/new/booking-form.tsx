"use client";
import { useActionState } from "react";
import { createBooking } from "@/app/actions";

export function BookingForm({unitId}:{unitId:string}){
  const [state,action,pending]=useActionState(createBooking,{error:undefined} as {error?:string});
  return <form className="form card" action={action}>
    <input type="hidden" name="unit_id" value={unitId}/>
    {state.error&&<p className="error wide">{state.error}</p>}
    <label>Purchaser name<input name="purchaser_name" required placeholder="Siti Aminah"/></label>
    <label>IC / Passport<input name="purchaser_ic" placeholder="901225-08-9012"/></label>
    <label>Phone<input name="purchaser_phone" placeholder="011-2223333"/></label>
    <label>Email<input type="email" name="purchaser_email" placeholder="siti@example.com"/></label>
    <label>Earnest deposit (RM)<input type="number" min="0" step="0.01" name="earnest_deposit_amount" defaultValue="5000"/></label>
    <label>Agent name<input name="agent_name" required placeholder="Jason Tan"/></label>
    <div className="wide"><button className="button" disabled={pending}>{pending?"Creating booking…":"Create booking"}</button></div>
  </form>
}
