-- Inventory transcribed from "AIRA_Tower A&B Available Sales Chart.pdf".
-- Preserve historical demo bookings while removing their units from live inventory.
alter table units add column if not exists floor_label text;
alter table units add column if not exists unit_type text;
alter table units add column if not exists list_price numeric;
alter table units add column if not exists id_fee numeric;
alter table units add column if not exists source_active boolean not null default true;

update units
set source_active = false
where organization_id = '00000000-0000-0000-0000-000000000001';

insert into units (
  organization_id, tower, unit_number, floor, floor_label, size_sqft, size_sqm,
  unit_type, list_price, selling_price, price_per_sqft, id_fee, status, source_active
) values
('00000000-0000-0000-0000-000000000001','A','A-01-03',1,'01',5943,552,'A2b',9496000,10450250,1598,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-01-3A',1,'01',5943,552,'A2b',9781000,10450250,1646,800000,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-02-03',2,'02',5351,497,'A2',9291000,9919085,1736,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-02-05',2,'02',4489,417,'B',7897000,8359760,1759,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-02-3A',2,'02',5351,497,'A2',9291000,9919085,1736,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-03-01',3,'03',5253,488,'A1',9111000,10393350,1734,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-03-03',3,'03',5351,497,'A2',9345000,10316900,1746,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-03-05',3,'03',4489,417,'B',7941000,8679100,1769,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-03-3A',3,'03',5351,497,'A2',9345000,10316900,1746,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-05-03',5,'05',5351,497,'A2',9451000,10443655,1766,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-07-05',7,'07',4489,417,'B',8115000,8991325,1808,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-15-03',15,'15',5351,497,'A2',9695000,12789750,1812,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-G-01',0,'G',7201,669,'D',11899000,10709370,1652,null,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-G-02',0,'G',5856,544,'E',10133000,8765050,1730,850000,'available',true),
('00000000-0000-0000-0000-000000000001','A','A-G-03',0,'G',6383,602,'F',10861000,9600300,1702,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-01-01',1,'01',1894,176,'G2',3220000,2876000,1700,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-01-02',1,'01',1894,176,'H2',3220000,2876000,1700,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-01-03',1,'01',1894,176,'G1',2898000,2856000,1530,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-01-04',1,'01',1894,176,'H1',2898000,2856000,1530,520000,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-02-02',2,'02',1894,176,'H2',3250000,2891000,1716,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-02-04',2,'02',1894,176,'H1',2925000,2871000,1544,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-03-04',3,'03',1894,176,'H1',2952000,2886000,1559,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-05-04',5,'05',1894,176,'H1',3009000,3016000,1589,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-06-03',6,'06',1894,176,'G1',3039000,3051000,1605,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-08-01',8,'08',1894,176,'G2',3452000,3141000,1823,450000,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-13-04',13,'13',1894,176,'H1',3331000,3387000,1759,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-13A-03',13,'13A',1894,176,'G1',3366000,3429000,1777,500000,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-15-01',15,'15',1894,176,'G2',3703000,3491000,1955,null,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-3A-03',3,'3A',1894,176,'G1',2979000,2901000,1573,450000,'available',true),
('00000000-0000-0000-0000-000000000001','B','B-3A-04',3,'3A',1894,176,'H1',2979000,2901000,1573,null,'available',true)
on conflict (organization_id, unit_number) do update set
  tower = excluded.tower,
  floor = excluded.floor,
  floor_label = excluded.floor_label,
  size_sqft = excluded.size_sqft,
  size_sqm = excluded.size_sqm,
  unit_type = excluded.unit_type,
  list_price = excluded.list_price,
  selling_price = excluded.selling_price,
  price_per_sqft = excluded.price_per_sqft,
  id_fee = excluded.id_fee,
  status = 'available',
  source_active = true;

