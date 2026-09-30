# Security

**Secret handling:** Supabase service role key server-side only (never in `NEXT_PUBLIC_*`). Frontend uses anon key with RLS. No secrets in client bundles.

**Permission model:**
- **v1 (demo):** Permissive RLS — all tables readable/writable without login. Seed data visible to anonymous visitors.
- **Lock-down:** Owner-scoped RLS — agents see/edit only own bookings (auth.uid() = user_id). Sales dept staff see all bookings and units (role-based). Weekly summaries visible to all authenticated staff.
- Agent inherits their own permissions — cannot access other agents' bookings.

**Approved tools rule:** Only named server actions (`compute_unit_pricing`, `create_booking`, `generate_weekly_summary`) may write to the database. No raw SQL from client. No `run_any`/`send_any` patterns.

**Audit principle:** Every booking status change, every authorization, and every weekly summary generation is logged with actor, action, target, timestamp, before/after values. No silent mutations.

**Data integrity:** Unique constraint on unit_number prevents duplicate units. Booking creation checks unit status server-side — only "available" units can be booked. Check constraints enforce valid status enums.