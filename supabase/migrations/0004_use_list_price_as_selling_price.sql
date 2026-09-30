-- Owner clarification: the sales chart List Price is the app Selling Price.
-- Scope to the imported AIRA inventory; preserve bookings and availability.
update public.units
set selling_price = list_price
where organization_id = '00000000-0000-0000-0000-000000000001'
  and source_active = true
  and list_price is not null;
