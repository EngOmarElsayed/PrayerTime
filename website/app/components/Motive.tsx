export default function Motive() {
  return (
    <section
      id="story"
      className="relative py-20 px-6 bg-surface-light overflow-hidden"
    >
      {/* Decorative crescent moon — low opacity background element */}
      <svg
        className="absolute right-[-60px] top-1/2 -translate-y-1/2 opacity-[0.04] pointer-events-none"
        width="320"
        height="320"
        viewBox="0 0 320 320"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        aria-hidden="true"
      >
        <path
          d="M240 160c0 66.274-53.726 120-120 120-22.08 0-42.77-5.96-60.54-16.36C93.3 285.42 135.16 300 180 300c77.32 0 140-62.68 140-140S257.32 20 180 20c-44.84 0-86.7 14.58-120.54 36.36C77.23 45.96 97.92 40 120 40c66.274 0 120 53.726 120 120z"
          fill="currentColor"
          className="text-gold"
        />
        {/* Small star accent */}
        <circle cx="200" cy="80" r="4" fill="currentColor" className="text-gold" />
        <circle cx="230" cy="120" r="2.5" fill="currentColor" className="text-gold" />
        <circle cx="215" cy="60" r="2" fill="currentColor" className="text-gold" />
      </svg>

      <div className="max-w-3xl mx-auto text-center relative z-10">
        {/* Section Title */}
        <h2 className="text-3xl sm:text-4xl font-bold text-white mb-12">
          Why I Built PrayerTime
        </h2>

        {/* Prominent Quote */}
        <blockquote className="relative mb-10">
          {/* Decorative opening quote mark */}
          <span
            className="absolute -top-6 left-1/2 -translate-x-1/2 text-gold opacity-30 select-none leading-none pointer-events-none"
            style={{ fontSize: "8rem" }}
            aria-hidden="true"
          >
            &ldquo;
          </span>

          <p className="relative text-2xl sm:text-3xl md:text-4xl font-semibold text-gold leading-snug pt-8">
            &ldquo;I spend 90% of my day on my Mac.&rdquo;
          </p>
        </blockquote>

        {/* Body Text */}
        <p className="text-foreground max-w-2xl mx-auto leading-relaxed text-base sm:text-lg">
          As someone who spends nearly all day working on my Mac, I needed a way
          to stay connected to my prayers without disrupting my workflow. I
          couldn&apos;t find a prayer time app that felt truly native to macOS
          &mdash; one that lived quietly in the menu bar and just worked. So I
          built PrayerTime. It&apos;s the app I wished existed: minimal,
          accurate, and designed to feel like it belongs on your Mac.
        </p>
      </div>
    </section>
  );
}
