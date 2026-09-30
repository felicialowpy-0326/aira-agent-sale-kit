-- Team workspaces and tenant isolation. Existing v1 data remains available in a
-- public demo workspace so the no-login product tour continues to work.
create table if not exists organizations (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  slug text not null unique,
  is_demo boolean not null default false
);

create table if not exists organization_members (
  organization_id uuid not null references organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  display_name text,
  role text not null default 'agent' check (role in ('owner', 'manager', 'agent')),
  primary key (organization_id, user_id)
);

insert into organizations (id, name, slug, is_demo)
values ('00000000-0000-0000-0000-000000000001', 'Aira Demo Team', 'demo', true)
on conflict (id) do update set name = excluded.name, is_demo = true;

alter table units add column if not exists organization_id uuid references organizations(id);
alter table bookings add column if not exists organization_id uuid references organizations(id);
alter table audit_logs add column if not exists organization_id uuid references organizations(id);

update units set organization_id = '00000000-0000-0000-0000-000000000001' where organization_id is null;
update bookings set organization_id = '00000000-0000-0000-0000-000000000001' where organization_id is null;
update audit_logs set organization_id = '00000000-0000-0000-0000-000000000001' where organization_id is null;

alter table units alter column organization_id set not null;
alter table bookings alter column organization_id set not null;
alter table audit_logs alter column organization_id set not null;

drop index if exists units_unit_number_key;
create unique index if not exists units_organization_unit_number_key
  on units(organization_id, unit_number);
create index if not exists bookings_organization_id_idx on bookings(organization_id);
create index if not exists audit_logs_organization_id_idx on audit_logs(organization_id);
create index if not exists organization_members_user_id_idx on organization_members(user_id);

alter table organizations enable row level security;
alter table organization_members enable row level security;

-- Security-definer helper avoids recursive RLS evaluation when membership
-- policies need to check the membership table itself.
create or replace function is_organization_member(target_organization_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from organization_members
    where organization_id = target_organization_id and user_id = auth.uid()
  );
$$;
revoke all on function is_organization_member(uuid) from public;
grant execute on function is_organization_member(uuid) to anon, authenticated;

drop policy if exists "organizations_visible_to_members" on organizations;
create policy "organizations_visible_to_members" on organizations for select using (
  is_demo or is_organization_member(id)
);

drop policy if exists "members_visible_to_team" on organization_members;
create policy "members_visible_to_team" on organization_members for select using (
  user_id = auth.uid() or is_organization_member(organization_id)
);

drop policy if exists "units_v1_read" on units;
drop policy if exists "units_v1_write" on units;
create policy "units_tenant_read" on units for select using (
  organization_id = '00000000-0000-0000-0000-000000000001'
  or is_organization_member(organization_id)
);
create policy "units_tenant_write" on units for all using (
  organization_id = '00000000-0000-0000-0000-000000000001' and auth.uid() is null
  or is_organization_member(organization_id)
) with check (
  organization_id = '00000000-0000-0000-0000-000000000001' and auth.uid() is null
  or is_organization_member(organization_id)
);

drop policy if exists "bookings_v1_read" on bookings;
drop policy if exists "bookings_v1_write" on bookings;
create policy "bookings_tenant_read" on bookings for select using (
  organization_id = '00000000-0000-0000-0000-000000000001'
  or is_organization_member(organization_id)
);
create policy "bookings_tenant_write" on bookings for all using (
  organization_id = '00000000-0000-0000-0000-000000000001' and auth.uid() is null
  or is_organization_member(organization_id)
) with check (
  organization_id = '00000000-0000-0000-0000-000000000001' and auth.uid() is null
  or is_organization_member(organization_id)
);

drop policy if exists "audit_logs_v1_read" on audit_logs;
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_tenant_read" on audit_logs for select using (
  organization_id = '00000000-0000-0000-0000-000000000001'
  or is_organization_member(organization_id)
);
create policy "audit_logs_tenant_insert" on audit_logs for insert with check (
  organization_id = '00000000-0000-0000-0000-000000000001' and auth.uid() is null
  or is_organization_member(organization_id)
);

-- Creates the first workspace and owner membership atomically for a signed-in user.
create or replace function create_organization(team_name text, team_slug text)
returns uuid language plpgsql security definer set search_path = public as $$
declare new_id uuid;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  insert into organizations(name, slug) values (trim(team_name), lower(trim(team_slug))) returning id into new_id;
  insert into organization_members(organization_id, user_id, role) values (new_id, auth.uid(), 'owner');
  return new_id;
end;
$$;
revoke all on function create_organization(text, text) from public;
grant execute on function create_organization(text, text) to authenticated;
