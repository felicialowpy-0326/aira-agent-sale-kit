# Data Model

### units
| Field | Type |
|---|---|
| id | uuid PK |
| user_id | uuid (nullable, for RLS later) |
| unit_number | text, unique |
| tower | text (A/B), check constraint |
| size_sqft | numeric |
| size_sqm | numeric |
| selling_price | numeric |
| price_per_sqft | numeric |
| status | text (available/reserved/booked/sold) |
| created_at | timestamptz |

### bookings
| Field | Type |
|---|---|
| id | uuid PK |
| user_id | uuid (nullable) |
| unit_id | uuid FK → units |
| purchaser_name | text |
| purchaser_ic | text |
| booking_form_signed | boolean |
| earnest_deposit_paid | boolean |
| deposit_amount | numeric |
| deposit_date | date |
| booking_status | text (pending/confirmed/rejected/cancelled) |
| sales_agent_name | text |
| authorized_representative | text |
| authorized_at | timestamptz |
| created_at | timestamptz |

### weekly_summaries
| Field | Type |
|---|---|
| id | uuid PK |
| user_id | uuid (nullable) |
| week_start / week_end | date |
| new_bookings_count | integer |
| confirmed_bookings_count | integer |
| total_deposit_collected | numeric |
| summary_text | text (AI-drafted value) |
| source | text | 
| confidence | numeric |
| review_status | text (unreviewed/reviewed) |
| created_at | timestamptz |

**Relationships:** bookings.unit_id → units.id (1 active booking per reserved/booked unit). weekly_summaries aggregates bookings by week.

**RLS:** v1 permissive (all open for demo). Lock-down: agents see own bookings (auth.uid() = user_id), sales dept sees all.

**AI fields:** weekly_summaries.summary_text stores drafted text with source + confidence + review_status.