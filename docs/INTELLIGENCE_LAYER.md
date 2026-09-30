# Intelligence Layer

**Messy inputs:**
- Agent enters selling_price manually; price_per_sqft may be wrong
- Purchaser name spelling variations
- Deposit amount entered as text or missing

**Auto-structure (computed on save):**
```json
{
  "unit_pricing": {
    "price_per_sqft": "selling_price / size_sqft",
    "size_sqm": "size_sqft * 0.0929"
  },
  "booking_completeness": {
    "score": "form_signed(40) + deposit_paid(40) + ic_provided(20)",
    "missing_fields": ["deposit_amount", "purchaser_ic"]
  }
}
```

**Events tracked:**
- `booking_created` — new booking logged
- `deposit_paid` — earnest deposit marked paid
- `booking_confirmed` — status → confirmed
- `weekly_summary_generated` — summary created

**Scoring rules (v1, rule-based):**
- Booking completeness: form signed (40) + deposit paid (40) + IC provided (20) = 0–100
- Unit ranking: sort by price_per_sqft ascending

**What gets ranked:** Units by price per sq ft; bookings by completeness (flag incomplete for follow-up).

**v1:** Rule-based only — price/sqft, sqm conversion, completeness score, weekly counts. **Later:** AI-drafted summary text, purchaser-unit matching, price anomaly detection.