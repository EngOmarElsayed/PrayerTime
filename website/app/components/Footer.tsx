import Image from "next/image";

export default function Footer() {
  const navLinks = [
    { label: "Features", href: "#features" },
    { label: "Why", href: "#story" },
    { label: "Screenshots", href: "#screenshots" },
    { label: "Contact", href: "#contact" },
  ];

  return (
    <footer className="bg-surface border-t border-border">
      <div className="max-w-6xl mx-auto py-8 px-6">
        {/* Top row: brand + navigation */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
          {/* Left side: App icon + name */}
          <div className="flex items-center gap-3">
            <Image
              src="/images/app-icon.png"
              alt="PrayerTime app icon"
              width={32}
              height={32}
              className="rounded-lg"
            />
            <span className="text-white font-medium">PrayerTime</span>
          </div>

          {/* Right side: Navigation links */}
          <nav className="flex items-center gap-6">
            {navLinks.map((link) => (
              <a
                key={link.href}
                href={link.href}
                className="text-foreground-muted text-sm hover:text-gold transition-colors duration-200"
              >
                {link.label}
              </a>
            ))}
          </nav>
        </div>

        {/* Bottom: Copyright */}
        <div className="mt-8 pt-6 border-t border-border text-center">
          <p className="text-foreground-muted text-sm">
            &copy; 2026 PrayerTime. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
