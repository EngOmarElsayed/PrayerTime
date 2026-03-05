import Image from "next/image";

export default function Hero() {
  return (
    <section className="flex flex-col items-center text-center px-6 pt-32 pb-24">
      {/* App Icon */}
      <div className="mb-8">
        <Image
          src="/images/app-icon.png"
          alt="PrayerTime app icon"
          width={100}
          height={100}
          className="rounded-3xl"
          style={{
            boxShadow:
              "0 0 40px rgba(212, 168, 83, 0.3), 0 0 80px rgba(212, 168, 83, 0.1)",
          }}
          priority
        />
      </div>

      {/* Headline */}
      <h1 className="text-4xl sm:text-5xl md:text-6xl font-bold text-white max-w-3xl leading-tight mb-6">
        Prayer Times, Always Within Reach
      </h1>

      {/* Subtitle */}
      <p className="text-foreground-muted text-lg sm:text-xl max-w-2xl leading-relaxed mb-10">
        A beautiful macOS menu bar app that keeps you connected to your daily
        prayers with accurate times, Adhan notifications, and Hijri date — all
        just a click away.
      </p>

      {/* CTA Button */}
      <a
        href="#"
        className="gold-btn inline-flex items-center gap-2 px-5 py-3 sm:px-8 sm:py-4 rounded-xl text-sm sm:text-lg font-semibold"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="22"
          height="22"
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
        </svg>
        Download on the Mac App Store
      </a>

      {/* Main Screenshot */}
      <div className="mt-16 w-full flex justify-center">
        <Image
          src="/images/screenshot-prayers.png"
          alt="PrayerTime app showing prayer times in the menu bar"
          width={700}
          height={500}
          className="rounded-2xl border border-border"
          style={{
            maxWidth: "700px",
            width: "100%",
            height: "auto",
            boxShadow:
              "0 8px 60px rgba(212, 168, 83, 0.15), 0 2px 20px rgba(0, 0, 0, 0.4)",
          }}
          priority
        />
      </div>
    </section>
  );
}
