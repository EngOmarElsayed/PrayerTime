import Image from "next/image";

const screenshots = [
  {
    src: "/images/screenshot-menubar.png",
    alt: "PrayerTime clean menu bar integration",
    caption: "Clean Menu Bar Integration",
  },
  {
    src: "/images/screenshot-prayers.png",
    alt: "PrayerTime showing all prayer times at a glance",
    caption: "All Prayer Times at a Glance",
  },
  {
    src: "/images/screenshot-settings.png",
    alt: "PrayerTime customizable settings panel",
    caption: "Customizable Settings",
  },
];

export default function Screenshots() {
  return (
    <section id="screenshots" className="py-20 px-6">
      {/* Geometric Divider */}
      <div className="flex items-center justify-center mb-16 max-w-md mx-auto">
        <div className="flex-1 h-px bg-gold/30" />
        <div className="mx-4 w-3 h-3 rotate-45 border border-gold/60 bg-gold/10" />
        <div className="flex-1 h-px bg-gold/30" />
      </div>

      <div className="max-w-6xl mx-auto">
        {/* Section Title */}
        <h2 className="text-3xl sm:text-4xl font-bold text-center text-white mb-14">
          See It in{" "}
          <span className="text-gold">Action</span>
        </h2>

        {/* Screenshot Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {screenshots.map((shot) => (
            <div
              key={shot.src}
              className="bg-surface rounded-xl border border-border overflow-hidden transition-transform duration-300 hover:scale-[1.02]"
              style={{
                boxShadow:
                  "0 4px 30px rgba(0, 0, 0, 0.4), 0 0 20px rgba(212, 168, 83, 0.05)",
              }}
            >
              <div className="p-3">
                <Image
                  src={shot.src}
                  alt={shot.alt}
                  width={600}
                  height={450}
                  className="rounded-lg w-full h-auto"
                />
              </div>
              <p className="text-foreground-muted text-sm text-center pb-4 px-3 font-medium">
                {shot.caption}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
