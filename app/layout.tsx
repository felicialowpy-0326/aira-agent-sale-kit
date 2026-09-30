import type { Metadata } from "next";
import Link from "next/link";
import "./globals.css";

export const metadata: Metadata = {
  title: "Aira Sales Kit",
  description: "Unit inventory, bookings, and weekly sales activity",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <aside className="sidebar">
          <div className="brand"><span>A</span><div>Aira<small>Sales Kit</small></div></div>
          <nav><Link href="/units">Units</Link><Link href="/bookings">Bookings</Link><Link href="/weekly-summary">Weekly Summary</Link></nav>
          <p className="sidebar-note">Two towers. One source of truth.</p>
        </aside>
        <main className="shell">{children}</main>
      </body>
    </html>
  );
}
