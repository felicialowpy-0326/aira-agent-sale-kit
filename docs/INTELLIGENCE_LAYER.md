# Intelligence Layer

## Messy Inputs
- Agent enters purchaser name, IC, contact details manually
- Deposit amount may be entered before or after payment confirmation
- Booking may be created with incomplete fields (v1 allows this)

## Auto-Structure Schema
```json
{
  "purchaser_name": "Tan Wei Ming",
  "purchaser_ic": "800101-14-5566",
  "unit_id": "uuid",
  "earnest_deposit_amount": 5000,
  "booking_form_signed": true,
  "earnest_deposit_paid": true,
  "completeness_score": 85,
  "missing_fields": ["purchaser_email"]
}
```

## Events to Track
- `booking_created` — new booking logged
- `deposit_confirmed` — deposit marked paid
- `booking_confirmed` — status moved to confirmed
- `booking_cancelled` — booking voided, unit released

## Scoring Rules (rule-based, v1)
- **Booking completeness** (0–100): start at 100, subtract per missing field — email −10, phone −10, IC −20, form not signed −20, deposit not paid −20
- **Weekly activity score**: count of new bookings + (sum of confirmed deposits ÷ 1000)

## What Gets Ranked
- Weekly summary: bookings ordered by booking_date descending
- Unit inventory: available units first, then by tower → floor → price

## v1 vs Later
- **v1**: rule-based completeness score, weekly aggregation (count + deposit totals)
- **Later**: AI-drafted weekly summary narrative, unit recommendation by purchaser budget, duplicate purchaser IC detection across bookings