# Test Plan

### Success scenario (end-to-end)
1. Open app — no login required
2. Click "Units" in sidebar → Tower A tab active
3. Verify 3 units shown: unit number, sqft, sqm, price, price/sqft
4. Switch to Tower B → verify 3 different units
5. Click available unit A-12-02 → "Create Booking" opens
6. Enter purchaser "Test Buyer", IC "900101-08-1234"
7. Check "Booking form signed", enter deposit 5000, date today
8. Submit → Bookings list shows new "pending" booking
9. Return to Units → A-12-02 shows "reserved"
10. Try booking A-12-02 again → "already booked" error
11. Open Weekly Summary → 1 new booking, deposit RM 5,000

### Empty states
- Tower with no available units → "No available units in this tower"
- Bookings empty → "No bookings yet — create one from Units"
- Weekly Summary empty → "No bookings this week yet"

### Error cases
- Submit without purchaser name → "Purchaser name required"
- Book reserved/booked unit → "This unit is already reserved"
- Network failure on submit → "Could not save booking — try again"

### Loading states
- Units page → skeleton cards before data
- Summary page → spinner before counts