import { cookies } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import type { Organization, OrganizationMember, TenantContext } from "@/lib/types";

export const DEMO_ORGANIZATION_ID = "00000000-0000-0000-0000-000000000001";

export async function getTenantContext(): Promise<TenantContext> {
  const db = await createClient();
  const { data: { user } } = await db.auth.getUser();

  if (!user) {
    return { organizationId: DEMO_ORGANIZATION_ID, organizationName: "Aira Demo Team", slug: "demo", role: "demo", isDemo: true };
  }

  const cookieStore = await cookies();
  const preferred = cookieStore.get("aira_workspace")?.value;
  let query = db.from("organization_members").select("role, organizations!inner(id,name,slug,is_demo)").eq("user_id", user.id);
  if (preferred) query = query.eq("organization_id", preferred);
  const { data } = await query.limit(1).maybeSingle();
  const organization = data?.organizations as unknown as Organization | undefined;

  if (!organization) {
    return { organizationId: DEMO_ORGANIZATION_ID, organizationName: "Aira Demo Team", slug: "demo", role: "viewer", isDemo: true };
  }

  const role = data?.role as TenantContext["role"] | undefined;
  return { organizationId: organization.id, organizationName: organization.name, slug: organization.slug, role: role ?? "viewer", isDemo: organization.is_demo };
}

export async function getTeamMembers(): Promise<OrganizationMember[]> {
  const tenant = await getTenantContext();
  if (tenant.isDemo) return [];
  const db = await createClient();
  const { data, error } = await db.from("organization_members").select("organization_id,user_id,created_at,display_name,role").eq("organization_id", tenant.organizationId).order("created_at");
  if (error) throw new Error(error.message);
  return data as OrganizationMember[];
}

export async function getUserOrganizations(): Promise<Organization[]> {
  const db = await createClient();
  const { data: { user } } = await db.auth.getUser();
  if (!user) return [{ id: DEMO_ORGANIZATION_ID, name: "Aira Demo Team", slug: "demo", is_demo: true }];
  const { data, error } = await db.from("organization_members").select("organizations!inner(id,name,slug,is_demo)").eq("user_id", user.id);
  if (error) throw new Error(error.message);
  return (data ?? []).map(row => row.organizations as unknown as Organization);
}
