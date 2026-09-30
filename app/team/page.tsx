import { getTeamMembers, getTenantContext, getUserOrganizations } from "@/lib/data/tenant";
import { selectWorkspace } from "@/app/actions";

export const dynamic = "force-dynamic";

export default async function TeamPage(){
  const [tenant,members,organizations]=await Promise.all([getTenantContext(),getTeamMembers(),getUserOrganizations()]);
  return <>
    <header className="header-row"><div><p className="eyebrow">Workspace</p><h1>{tenant.organizationName}</h1><p className="lede">Units, bookings, and reporting are isolated to this team workspace.</p></div><span className="badge available">{tenant.role}</span></header>
    <section className="grid">
      <article className="card"><h2>Switch workspace</h2><form action={selectWorkspace}><label>Team<select name="organization_id" defaultValue={tenant.organizationId}>{organizations.map(org=><option key={org.id} value={org.id}>{org.name}</option>)}</select></label><button className="button">Open workspace</button></form></article>
      <article className="card"><h2>Team members</h2>{tenant.isDemo?<p className="meta">The public demo workspace has no private members. Signed-in teams see their owners, managers, and agents here.</p>:members.map(member=><p className="stat-line" key={member.user_id}><span>{member.display_name||member.user_id}</span><span className="badge">{member.role}</span></p>)}</article>
    </section>
  </>;
}
