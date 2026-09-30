# Agentic Layer

## Risk Levels

### Low — Auto
- Calculate booking completeness score on save
- Aggregate weekly bookings into summary
- Tag bookings by tower and status

### Medium — Draftable (light approval)
- Draft weekly summary notification text for Sales Dept review
- Suggest available units matching a purchaser's budget range

### High — Always approval
- **Confirm a booking** (pending → confirmed): requires Sales Dept staff action
- **Send weekly summary** to distribution list: requires approval before send
- Update unit status to "sold" (final sale)

### Critical — Human-only
- Cancel a confirmed booking and release the unit
- Delete a booking record
- Modify deposit amount after confirmation

## Named Tools
- `create_booking` — inserts booking, returns success or duplicate error
- `confirm_booking` — flips status, records sales_dept_approved_by
- `cancel_booking` — sets status cancelled, releases unit
- `generate_weekly_summary` — aggregates bookings for date range
- `draft_summary_notification` — produces text draft for review (later)

No raw `run_any` / `send_any` — only these named tools.

## Audit Log Fields
Every action logs: action name, entity_type, entity_id, timestamp, user_id (when auth added), details (jsonb with unit_number, purchaser, agent, amount).

## v1 vs Later
- **v1**: create_booking, confirm_booking, cancel_booking, generate_weekly_summary (all human-triggered)
- **Later**: draft_summary_notification with approval gate, auto-send on schedule