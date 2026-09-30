import type { Metadata } from "next";
import Link from "next/link";
import { getTenantContext } from "@/lib/data/tenant";
import "./globals.css";

export const metadata: Metadata = {
  title: "Aira Sales Kit",
  description: "Unit inventory, bookings, and weekly sales activity",
};

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const tenant = await getTenantContext();
  return (
    <html lang="en">
      <body>
        <aside className="sidebar">
          <div className="brand"><img src="/images/aira-logo.png" alt="AIRA Residences"/><div>AIRA<small>Private sales advisory</small></div></div>
          <nav><Link href="/units">Residences</Link><Link href="/bookings">Allocations</Link><Link href="/weekly-summary">Portfolio</Link><Link href="/team">Advisory team</Link></nav>
          <p className="sidebar-note"><span>Private workspace</span><strong>{tenant.organizationName}</strong><br/>Damansara Heights · Kuala Lumpur</p>
        </aside>
        <main className="shell">{children}</main>
      </body>
    </html>
  );
}
