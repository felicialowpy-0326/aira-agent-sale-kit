# Sales Kit for Real Estate Agents

**Problem:** Agents sell units across two residential towers with no central view of availability, pricing, or booking status. Duplicate bookings happen. No weekly summary of sales activity exists.

**Target users:** Appointed real estate agents (field) and sales department staff (office).

**Core objects:**
- **Unit** — unit_number, tower (A/B), size_sqft, size_sqm, selling_price, price_per_sqft, status (available/reserved/booked/sold)
- **Booking** — unit, purchaser_name, purchaser_ic, booking_form_signed, earnest_deposit_paid, deposit_amount, deposit_date, booking_status (pending/confirmed/rejected), sales_agent_name, authorized_representative, authorized_at
- **Weekly Summary** — week_start, week_end, new_bookings_count, confirmed_bookings_count, total_deposit_collected, summary_text

**MVP (v1) checklist:**
- [ ] View units separated by Tower A and Tower B
- [ ] Show selling price, price per sq ft, unit number, size (sq ft + sq m)
- [ ] Filter available units
- [ ] Create a booking for a unit (block duplicates — reserved/booked units can't be re-booked)
- [ ] Track booking form signed + earnest deposit paid
- [ ] Generate weekly booking summary (new bookings, confirmed, deposits collected)
- [ ] Dashboard overview with unit availability counts
- [ ] All screens viewable without login (seed demo data)

**Non-goals (v1):**
- No reservation enforcement without complete booking info + documents + deposit
- No sales dept authorization gate on booking acceptance
- No document upload, no payment integration, no login/auth

**Success criteria:** Agent opens app, views Tower A available units with full pricing, books unit A-12-02 for a purchaser (form signed, deposit entered), unit becomes "reserved" preventing duplicate booking, and the weekly summary page shows this as a new booking with deposit collected.