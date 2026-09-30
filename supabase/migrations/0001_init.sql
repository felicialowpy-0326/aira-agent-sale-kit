create table if not exists units (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  tower text not null,
  unit_number text not null,
  floor int not null,
  size_sqft numeric not null,
  size_sqm numeric not null,
  selling_price numeric not null,
  price_per_sqft numeric not null,
  status text not null default 'available'
);

create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  unit_id uuid not null references units(id),
  purchaser_name text not null,
  purchaser_ic text,
  purchaser_email text,
  purchaser_phone text,
  booking_form_signed boolean not null default false,
  earnest_deposit_amount numeric not null default 0,
  earnest_deposit_paid boolean not null default false,
  deposit_paid_at timestamptz,
  agent_name text not null,
  status text not null default 'pending',
  sales_dept_approved_by text,
  approved_at timestamptz,
  booking_date date not null default current_date
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  action text not null,
  entity_type text,
  entity_id uuid,
  details jsonb
);

create unique index if not exists units_unit_number_key on units(unit_number);

create unique index if not exists one_active_booking_per_unit on bookings(unit_id) where status in ('pending', 'confirmed');

alter table units enable row level security;
drop policy if exists "units_v1_read" on units;
create policy "units_v1_read" on units for select using (true);
drop policy if exists "units_v1_write" on units;
create policy "units_v1_write" on units for all using (true) with check (true);

alter table bookings enable row level security;
drop policy if exists "bookings_v1_read" on bookings;
create policy "bookings_v1_read" on bookings for select using (true);
drop policy if exists "bookings_v1_write" on bookings;
create policy "bookings_v1_write" on bookings for all using (true) with check (true);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into units (tower, unit_number, floor, size_sqft, size_sqm, selling_price, price_per_sqft, status) values
('A', 'A-05-01', 5, 1200, 111.48, 720000, 600, 'available'),
('A', 'A-05-02', 5, 1350, 125.42, 810000, 600, 'booked'),
('A', 'A-08-01', 8, 1200, 111.48, 750000, 625, 'available'),
('A', 'A-12-02', 12, 1450, 134.71, 942500, 650, 'available'),
('B', 'B-03-01', 3, 1100, 102.19, 660000, 600, 'available'),
('B', 'B-06-02', 6, 1400, 130.06, 896000, 640, 'booked'),
('B', 'B-10-01', 10, 1200, 111.48, 780000, 650, 'available'),
('B', 'B-15-02', 15, 1600, 148.64, 1120000, 700, 'available')
on conflict (unit_number) do nothing;

insert into bookings (unit_id, purchaser_name, purchaser_ic, purchaser_email, purchaser_phone, booking_form_signed, earnest_deposit_amount, earnest_deposit_paid, deposit_paid_at, agent_name, status, sales_dept_approved_by, approved_at, booking_date)
select u.id, 'Tan Wei Ming', '800101-14-5566', 'tanwm@email.com', '012-3456789', true, 5000, true, now() - interval '5 days', 'Jason Tan', 'confirmed', 'Sarah Lim', now() - interval '4 days', current_date - 5
from units u
where u.unit_number = 'A-05-02'
and not exists (select 1 from bookings b where b.unit_id = u.id and b.status in ('pending','confirmed'));

insert into bookings (unit_id, purchaser_name, purchaser_ic, purchaser_email, purchaser_phone, booking_form_signed, earnest_deposit_amount, earnest_deposit_paid, agent_name, status, booking_date)
select u.id, 'Lee Mei Ling', '850315-08-1234', 'leeml@email.com', '019-8765432', true, 5000, false, 'Nurul Aisyah', 'pending', current_date - 2
from units u
where u.unit_number = 'B-06-02'
and not exists (select 1 from bookings b where b.unit_id = u.id and b.status in ('pending','confirmed'));

insert into audit_logs (action, entity_type, details)
select 'booking_created', 'booking', '{"unit_number": "A-05-02", "purchaser": "Tan Wei Ming", "agent": "Jason Tan"}'::jsonb
where not exists (select 1 from audit_logs where action = 'booking_created' and details->>'unit_number' = 'A-05-02');

insert into audit_logs (action, entity_type, details)
select 'deposit_confirmed', 'booking', '{"unit_number": "A-05-02", "amount": 5000}'::jsonb
where not exists (select 1 from audit_logs where action = 'deposit_confirmed' and details->>'unit_number' = 'A-05-02');

insert into audit_logs (action, entity_type, details)
select 'booking_confirmed', 'booking', '{"unit_number": "A-05-02", "approved_by": "Sarah Lim"}'::jsonb
where not exists (select 1 from audit_logs where action = 'booking_confirmed' and details->>'unit_number' = 'A-05-02');

insert into audit_logs (action, entity_type, details)
select 'booking_created', 'booking', '{"unit_number": "B-06-02", "purchaser": "Lee Mei Ling", "agent": "Nurul Aisyah"}'::jsonb
where not exists (select 1 from audit_logs where action = 'booking_created' and details->>'unit_number' = 'B-06-02');