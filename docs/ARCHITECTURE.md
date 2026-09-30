# Architecture

**Stack:** Next.js 14 (App Router) + Supabase (Postgres + RLS) + Vercel

**Now:** Unit inventory (Tower A/B), booking creation with duplicate prevention, weekly summary, dashboard. **Later:** Auth + per-user RLS, sales dept authorization gate, document upload, AI-drafted summaries.

**Key action flow:** Agent opens Units → Tower A → picks available unit → fills booking form (purchaser, IC, form signed, deposit) → unit becomes "reserved" → duplicate booking blocked → Weekly Summary page shows new booking + deposit collected.

**Nav shell:** Left sidebar — Dashboard, Units, Bookings, Weekly Summary (desktop); hamburger on mobile. Active section highlighted.

**Layer plan:** DB schema + RLS → unit/booking CRUD → rule-based summary computation → (later) AI summary drafting.

**Core without AI:** price_per_sqft = selling_price ÷ size_sqft; size_sqm = size_sqft × 0.0929; booking completeness = field presence checks — pure logic.

**Repo structure:** feature folders (`app/(pages)/*`), `lib/data/` (all DB access), `lib/actions/` (server logic), `lib/ai/` (summary drafting, later), `components/`, `tests/` beside code.

**Module map:**
1. `units` — inventory + tower views (units table) — **first**
2. `bookings` — create/track, prevent duplicates (bookings table) — **second**
3. `summaries` — weekly booking summary (weekly_summaries table) — **third**
4. `dashboard` — overview aggregation (reads all) — **fourth**
5. `auth` — login + RLS lockdown — **last**