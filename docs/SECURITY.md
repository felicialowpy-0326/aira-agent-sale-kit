# Security

## Secret Handling
- Supabase URL + anon key: public, safe for frontend
- Supabase service role key: server-side only, never exposed to client
- No other secrets in v1 (no email provider, no payment gateway)

## Permission Model
**v1 (demo-first)**: No login required. All tables have permissive RLS — anyone can read and write. Intentional for demo and testing.

**Lock-down sprint**:
- **Agent**: can create bookings, see only own bookings (filter by user_id), read all units
- **Sales Dept**: read all bookings, confirm/cancel any booking, read weekly summary, read all units
- Enforced via RLS: `auth.uid() = user_id` for agent-scoped tables; role check for sales dept

## Approved-Tools Rule
Only named server actions callable from UI: `create_booking`, `confirm_booking`, `cancel_booking`, `generate_weekly_summary`. No generic `execute_sql` or raw query passthrough.

## Audit Principle
Every booking state change writes an audit_log row with action, entity, and details. Audit logs are append-only — no update or delete path in the data-access layer. Weekly summary reads audit logs to reconstruct activity timelines.

## Data Access Boundary
All database reads and writes go through `lib/data/` — no inline queries in UI components. Server actions validate inputs before calling the data layer.