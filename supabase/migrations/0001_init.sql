create table if not exists units (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  unit_number text not null,
  tower text not null check (tower in ('A', 'B')),
  size_sqft numeric not null,
  size_sqm numeric not null,
  selling_price numeric not null,
  price_per_sqft numeric not null,
  status text not null default 'available' check (status in ('available', 'reserved', 'booked', 'sold')),
  created_at timestamptz not null default now()
);
create unique index if not exists units_unit_number_key on units(unit_number);
alter table units enable row level security;
drop policy if exists "units_v1_read" on units;
create policy "units_v1_read" on units for select using (true);
drop policy if exists "units_v1_write" on units;
create policy "units_v1_write" on units for all using (true) with check (true);

create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  unit_id uuid not null references units(id),
  purchaser_name text not null,
  purchaser_ic text,
  booking_form_signed boolean not null default false,
  earnest_deposit_paid boolean not null default false,
  deposit_amount numeric,
  deposit_date date,
  booking_status text not null default 'pending' check (booking_status in ('pending', 'confirmed', 'rejected', 'cancelled')),
  sales_agent_name text,
  authorized_representative text,
  authorized_at timestamptz,
  rejection_reason text,
  created_at timestamptz not null default now()
);
alter table bookings enable row level security;
drop policy if exists "bookings_v1_read" on bookings;
create policy "bookings_v1_read" on bookings for select using (true);
drop policy if exists "bookings_v1_write" on bookings;
create policy "bookings_v1_write" on bookings for all using (true) with check (true);

create table if not exists weekly_summaries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  week_start date not null,
  week_end date not null,
  new_bookings_count integer not null default 0,
  confirmed_bookings_count integer not null default 0,
  total_deposit_collected numeric not null default 0,
  summary_text text,
  source text,
  confidence numeric,
  review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);
alter table weekly_summaries enable row level security;
drop policy if exists "weekly_summaries_v1_read" on weekly_summaries;
create policy "weekly_summaries_v1_read" on weekly_summaries for select using (true);
drop policy if exists "weekly_summaries_v1_write" on weekly_summaries;
create policy "weekly_summaries_v1_write" on weekly_summaries for all using (true) with check (true);

insert into units (unit_number, tower, size_sqft, size_sqm, selling_price, price_per_sqft, status)
values
('A-01-03', 'A', 850, 79.0, 425000, 500, 'reserved'),
('A-05-08', 'A', 1200, 111.5, 720000, 600, 'reserved'),
('A-12-02', 'A', 1500, 139.4, 975000, 650, 'available'),
('B-03-01', 'B', 850, 79.0, 442000, 520, 'available'),
('B-07-05', 'B', 1200, 111.5, 744000, 620, 'booked'),
('B-10-04', 'B', 1500, 139.4, 990000, 660, 'available')
on conflict (unit_number) do nothing;

insert into bookings (unit_id, purchaser_name, purchaser_ic, booking_form_signed, earnest_deposit_paid, deposit_amount, deposit_date, booking_status, sales_agent_name)
select id, 'Tan Chee Keong', '880215-14-5678', true, false, 7200, '2025-01-13', 'pending', 'Siti Aminah'
from units where unit_number = 'A-05-08'
and not exists (select 1 from bookings where unit_id = units.id and purchaser_name = 'Tan Chee Keong');

insert into bookings (unit_id, purchaser_name, purchaser_ic, booking_form_signed, earnest_deposit_paid, deposit_amount, deposit_date, booking_status, sales_agent_name, authorized_representative, authorized_at)
select id, 'Lim Wei Ming', '900330-08-1234', true, true, 7440, '2025-01-08', 'confirmed', 'Tan Boon Hui', 'Wong Fee Lee', '2025-01-10'
from units where unit_number = 'B-07-05'
and not exists (select 1 from bookings where unit_id = units.id and purchaser_name = 'Lim Wei Ming');

insert into bookings (unit_id, purchaser_name, purchaser_ic, booking_form_signed, earnest_deposit_paid, deposit_amount, deposit_date, booking_status, sales_agent_name)
select id, 'Nurul Huda', '850101-10-3456', true, true, 4250, '2025-01-15', 'pending', 'Siti Aminah'
from units where unit_number = 'A-01-03'
and not exists (select 1 from bookings where unit_id = units.id and purchaser_name = 'Nurul Huda');

insert into weekly_summaries (week_start, week_end, new_bookings_count, confirmed_bookings_count, total_deposit_collected, summary_text, source, confidence, review_status)
select '2025-01-06', '2025-01-12', 1, 1, 7440, '1 new booking this week. 1 booking confirmed. RM 7,440 collected in earnest deposits.', 'rule-based', 1.0, 'reviewed'
where not exists (select 1 from weekly_summaries where week_start = '2025-01-06');

insert into weekly_summaries (week_start, week_end, new_bookings_count, confirmed_bookings_count, total_deposit_collected, summary_text, source, confidence, review_status)
select '2025-01-13', '2025-01-19', 2, 0, 11450, '2 new bookings this week. 0 confirmed. RM 11,450 collected in earnest deposits.', 'rule-based', 1.0, 'unreviewed'
where not exists (select 1 from weekly_summaries where week_start = '2025-01-13');