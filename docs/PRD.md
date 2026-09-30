# Sales Kit — Product Requirements

## Problem
Real estate agents selling units across two towers need a single source of truth for availability, pricing, and booking status. Without it, two agents can book the same unit, deposits go untracked, and weekly activity is invisible to management.

## Target User
- **Sales Agent**: views available units, creates bookings, tracks deposit payment
- **Sales Dept Staff**: reviews bookings, confirms acceptance, reads weekly summaries

## Core Objects
- **Unit**: tower (A/B), unit number, floor, size (sqft + sqm), selling price, price per sqft, status
- **Booking**: purchaser info, booking form signed, earnest deposit (amount + paid), agent, status, confirmation
- **Audit Log**: every booking action recorded

## MVP (v1) Checklist
- [ ] Unit inventory split by Tower A / Tower B with selling price, PSF, sqft, sqm
- [ ] Create a booking on an available unit
- [ ] Prevent duplicate booking on the same unit (database-enforced)
- [ ] Track booking form signed + earnest deposit paid
- [ ] Booking confirmation (pending → confirmed)
- [ ] Weekly summary: new bookings this week with deposit totals
- [ ] All screens viewable without login (seeded demo data)

## Non-Goals (v1)
- Document upload / attachment storage
- Mandatory completeness validation (all fields required before booking)
- Sales Department approval gate for booking acceptance
- Reservation without booking (hold without purchaser)
- Agent login and per-user data isolation
- Email delivery of weekly summary

## Success Criteria
An agent opens the unit inventory, sees Tower A and B separately, books an available unit with purchaser name and deposit amount, and the unit becomes unavailable to others. At week's end, the weekly summary page shows that booking with the correct purchaser, price, deposit status, and agent name.