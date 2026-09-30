# Architecture

## Stack
Next.js 15 (App Router) · Supabase (Postgres) · Vercel

## Build Sequence
**Now**: Unit inventory → booking engine → weekly summary
**Next**: Booking confirmation workflow · document fields
**Later**: Auth + RLS · email notifications · AI summary drafting

## Key User Action Flow (book a unit)
1. Agent opens Units page, filters to Tower A
2. Selects an available unit → clicks "Book Unit"
3. Fills purchaser name, IC, phone, deposit amount → submits
4. DB inserts booking; unique index rejects if unit already booked
5. Unit status flips to "booked"; audit log written
6. Agent marks form signed + deposit paid on booking detail
7. Booking confirmed; unit shows as booked in inventory

## Navigation Shell
Persistent left sidebar on desktop: **Units · Bookings · Weekly Summary**. Collapses to hamburger on mobile. Current section highlighted.

## Layer Plan
1. **Data layer** (`lib/data/`): all DB reads/writes — units, bookings, audit_logs
2. **App logic** (server actions): booking creation, status transitions, weekly aggregation
3. **AI module** (`lib/ai/`, later): draft weekly summary text from booking data

Core runs without AI: booking creation, duplicate prevention, deposit tracking, and weekly summary aggregation are pure SQL + server logic.

## Repo Structure
```
app/
  units/          # inventory list + detail
  bookings/       # list, create, detail
  weekly-summary/ # summary page
  layout.tsx      # sidebar shell
components/
  units/  bookings/  weekly-summary/  shared/
lib/
  data/    # units.ts, bookings.ts, audit-logs.ts, weekly-summary.ts
  ai/      # summary.ts (later)
  types.ts
tests/
```

## Module Map
| Module | Responsibility | Owns | Build Order |
|--------|---------------|------|------------|
| `units` | Tower A/B inventory + availability status | units table | 1st |
| `bookings` | Booking creation, duplicate prevention, deposit tracking, confirmation | bookings + audit_logs | 2nd |
| `weekly-summary` | Aggregate bookings by week, totals by tower/agent | reads from bookings | 3rd |
| `auth` | Login, roles, owner-scoped data isolation | replaces RLS policies | 4th |