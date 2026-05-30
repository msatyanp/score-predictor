"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { adminNavigation } from "@/lib/navigation";

const isActivePath = (pathname: string, href: string): boolean => {
  if (href === "/admin") {
    return pathname === "/admin";
  }

  return pathname === href || pathname.startsWith(`${href}/`);
};

export const AdminNav = () => {
  const pathname = usePathname();

  return (
    <nav aria-label="Admin navigation" className="flex flex-wrap gap-2">
      {adminNavigation.map((item) => {
        const active = isActivePath(pathname, item.href);

        return (
          <Link
            key={item.href}
            href={item.href}
            className={`inline-flex h-10 items-center rounded-md px-3 text-sm font-medium transition ${active
              ? "text-blue-600"
              : "border-zinc-200 bg-white text-zinc-700 hover:border-zinc-300 hover:bg-zinc-50"
              }`}
          >
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
