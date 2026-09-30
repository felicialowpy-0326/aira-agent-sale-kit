# Agentic Layer

**Draftable (low risk — auto):**
- Compute price_per_sqft and size_sqm on unit save
- Calculate booking completeness score
- Draft weekly summary text ("3 new bookings, 1 confirmed, RM 18,900 collected")
- Tag incomplete bookings for follow-up

**Executable after approval (medium risk):**
- Mark earnest deposit as paid (agent confirms)
- Update booking status pending → confirmed (requires sales dept rep name)

**Human-only (critical):**
- Authorize/confirm a booking (sales dept representative)
- Reject or cancel a booking
- Delete any record
- Send weekly summary notification to external recipients

**Named tools:**
- `compute_unit_pricing` (low)
- `compute_booking_completeness` (low)
- `draft_weekly_summary` (low)
- `update_booking_status` (medium)
- `send_weekly_notification` (high)
- `authorize_booking` (human-only)

**Audit log fields:** action, actor_name, actor_role, target_type, target_id, old_value, new_value, timestamp, metadata

**v1:** Auto-compute pricing + completeness, draft summary (rule-based). **Later:** Approval workflow for booking confirmation, automated notification sending, full audit trail with auth.