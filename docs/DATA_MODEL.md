# Data Model

## units
- id (uuid PK) · user_id (uuid, nullable) · created_at
- tower (text: 'A'/'B') · unit_number (text, unique) · floor (int)
- size_sqft (numeric) · size_sqm (numeric)
- selling_price (numeric RM) · price_per_sqft (numeric)
- status (text: available / booked / sold)

Unique index on `unit_number`. RLS enabled (permissive v1).

## bookings
- id (uuid PK) · user_id (uuid, nullable) · created_at
- unit_id (uuid FK→units, NOT NULL)
- purchaser_name (text, req) · purchaser_ic (text) · purchaser_email · purchaser_phone
- booking_form_signed (bool, default false)
- earnest_deposit_amount (numeric, default 0) · earnest_deposit_paid (bool, default false) · deposit_paid_at (timestamptz)
- agent_name (text, req) · status (text: pending / confirmed / cancelled)
- sales_dept_approved_by (text) · approved_at (timestamptz) · booking_date (date)

**Partial unique index** on `(unit_id) WHERE status IN ('pending','confirmed')` — DB-level duplicate-booking prevention.

One unit → at most one active booking.

## audit_logs
- id (uuid PK) · user_id (uuid, nullable) · created_at
- action (text: booking_created / deposit_confirmed / booking_confirmed / booking_cancelled)
- entity_type (text) · entity_id (uuid) · details (jsonb)

## AI Fields (future, not v1)
When AI-drafted weekly summaries are added: store `summary_text` (value) + `source` (text) + `confidence` (numeric) + `review_status` (text, default 'unreviewed').

## RLS
v1: permissive (select + write for all, no login). Lock-down sprint: agents see own bookings only; sales dept sees all; units readable by all authenticated users.