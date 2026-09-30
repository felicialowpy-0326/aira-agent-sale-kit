# Tasks

## Sprint 1 — DB + Unit Inventory
- Create units/bookings/audit_logs tables + indexes, seed 8 units + 2 bookings + 4 logs
- Units list: Tower A/B tab filter, card shows unit no, floor, sqft, sqm, price, PSF, status
- Empty + loading states
**DoD**: Open app without login → see Tower A and B units with prices and availability.

## Sprint 2 — Booking Engine ← core action
- "Book Unit" on available units → form (purchaser name, IC, contact, deposit, agent)
- DB unique index rejects duplicate booking on same unit
- Success: unit → booked + audit log; error UI for duplicates
- Booking list + detail: toggle form-signed/deposit-paid, confirm/cancel with audit log
**DoD**: Book a unit; second booking on same unit rejected. Cancel → unit back to available.

## Sprint 3 — Weekly Summary ← v1 FUNCTIONAL
- Weekly summary: current week Mon–Sun, total bookings, deposit collected, by tower
- Booking rows: unit, purchaser, price, deposit status, agent, date → link to detail
- Empty + print-friendly states
**DoD**: Create a booking this week → summary shows it with correct details. End-to-end usable.

## Sprint 4 — Lock It Down
- Supabase auth (agent + sales dept roles)
- RLS: agents see own bookings, sales dept sees all, units visible to all authenticated
- Redirect unauthenticated to login
**DoD**: Agent sees only own bookings; sales dept sees all.

## Gantt
```
S1  ████░░░░░░  DB + Unit Inventory
S2  ░░░░████░░  Booking Engine
S3  ░░░░░░░░██  Weekly Summary [v1]
S4  ░░░░░░░░░░  Lock It Down
```