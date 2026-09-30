# Test Plan

## Success Scenario (v1)
1. Open app (no login) → Units page loads with Tower A tab active
2. Switch to Tower B → see 4 units with prices and sizes
3. Click "Book Unit" on an available unit (e.g. B-10-01)
4. Fill: purchaser "Siti Aminah", IC "901225-08-9012", phone "011-2223333", deposit RM 5,000, agent "Jason Tan"
5. Submit → success message, unit status changes to "booked"
6. Open Bookings page → see the new booking with "pending" status
7. Open booking detail → toggle "Booking form signed" and "Earnest deposit paid"
8. Click "Confirm Booking" → status moves to "confirmed"
9. Go back to Units → B-10-01 shows "booked" badge
10. Try to book B-10-01 again → error: "This unit is already booked"
11. Open Weekly Summary → see this week's booking listed with correct purchaser, price, deposit, agent

## Empty / Error Cases
- **No available units in tower**: Switch to a tower where all are booked → "No available units" message
- **No bookings this week**: Open Weekly Summary on a week with no bookings → "No new bookings this week"
- **Duplicate booking**: Submit booking on already-booked unit → error toast "This unit is already booked"
- **Missing required fields**: Submit form without purchaser name → validation error, no submit
- **Network error**: Supabase unreachable → error state on Units page with retry button
- **Cancel booking**: Cancel a pending booking → unit returns to "available" in inventory