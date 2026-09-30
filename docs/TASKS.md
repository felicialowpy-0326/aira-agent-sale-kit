# Sprints

### Sprint 1: Unit Inventory Foundation
**Goal:** Show available units separated by Tower A and Tower B with full pricing.
- [ ] Create DB schema: units, bookings, weekly_summaries tables with RLS
- [ ] Seed 6 demo units across Tower A (3) and Tower B (3)
- [ ] Build left sidebar nav shell (desktop sidebar, mobile hamburger)
- [ ] Build Units page with Tower A / Tower B tab toggle
- [ ] Display: unit number, size sqft, size sqm, selling price, price per sqft
- [ ] Status filter (available/reserved/booked/sold)
- [ ] Empty state: "No units in this tower" + loading skeleton

**DoD:** Anonymous visitor opens app, sees Tower A with 3 units showing real prices/sizes, switches to Tower B, sees 3 units — no login required.

### Sprint 2: Booking Engine
**Goal:** Agents can create bookings; duplicates are blocked.
- [ ] Build booking form (purchaser name, IC, form signed, deposit amount, deposit date)
- [ ] On submit: insert booking, update unit status → "reserved"
- [ ] Block booking if unit status is reserved/booked (server-side check)
- [ ] Booking list page with status badges
- [ ] Edit booking: toggle deposit paid, form signed
- [ ] Error state: "This unit is already booked" on duplicate attempt
- [ ] Empty state: "No bookings yet" + loading skeleton
- [ ] Seed 3 demo bookings

**DoD:** Agent books A-12-02, unit becomes "reserved". Second attempt to book A-12-02 shows error.

### Sprint 3: Weekly Summary + Dashboard → v1 FUNCTIONAL
**Goal:** Weekly booking summary works end-to-end.
- [ ] Build Dashboard: total units, available count, reserved count, recent bookings
- [ ] Compute weekly summary: new bookings, confirmed, sum deposits
- [ ] Weekly Summary page with week range selector
- [ ] Draft summary text (rule-based: "N new, M confirmed, RM X collected")
- [ ] Store summary with source/confidence/review_status
- [ ] Dashboard shows latest week summary
- [ ] Loading and empty states

**DoD:** Agent creates a booking, opens Weekly Summary, sees accurate counts + deposit total for current week.

### Sprint 4: Lock It Down (Auth + RLS)
**Goal:** Auth + per-user data isolation.
- [ ] Add Supabase Auth (login/signup pages)
- [ ] Owner-scoped RLS: agents see own bookings only
- [ ] Sales dept role: sees all bookings + units
- [ ] Set user_id from auth context on new records
- [ ] Audit log table for booking status changes
- [ ] Block anonymous access; migrate seed data

**DoD:** Logged-in agent sees only own bookings; sales dept sees all; anonymous blocked; status changes audited.

---

**v1 functional milestone:** End of Sprint 3.

**Gantt:**
```
Sprint 1  ████  Units DB + Tower A/B views
Sprint 2  ████  Booking engine + duplicate prevention
Sprint 3  ████  Weekly summary + dashboard (v1 functional)
Sprint 4  ████  Lock it down (auth + RLS)
```