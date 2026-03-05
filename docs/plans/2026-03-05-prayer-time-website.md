# PrayerTime Landing Page Website Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a dark-themed Next.js landing page for the PrayerTime macOS menu bar app, deployable to Vercel.

**Architecture:** Next.js App Router with Tailwind CSS. Single-page site with sections: Hero, Screenshots, Features, Motive, Contact (Web3Forms), Footer. Dark theme with gold/amber accents and subtle Islamic geometric SVG patterns. All assets copied from `../assets/` into `public/`.

**Tech Stack:** Next.js 15 (App Router), Tailwind CSS 4, TypeScript, Web3Forms API

---

### Task 1: Scaffold Next.js Project

**Files:**
- Create: `website/` directory via `create-next-app`

**Step 1: Create the Next.js project**

Run:
```bash
cd /Users/omarelsayed/Desktop/PrayPal
npx create-next-app@latest website --typescript --tailwind --eslint --app --src-dir=false --import-alias="@/*" --use-npm
```

Accept defaults. This scaffolds the project with App Router + Tailwind + TypeScript.

**Step 2: Copy assets into public/**

```bash
mkdir -p website/public/images
cp assets/AppIcon-iOS-Default-1024x1024@1x.png website/public/images/app-icon.png
cp "assets/Screenshot 2026-03-05 at 5.06.51 PM.png" website/public/images/screenshot-menubar.png
cp "assets/Screenshot 2026-03-05 at 5.07.04 PM.png" website/public/images/screenshot-prayers.png
cp "assets/Screenshot 2026-03-05 at 5.07.12 PM.png" website/public/images/screenshot-settings.png
```

**Step 3: Verify dev server starts**

Run: `cd website && npm run dev`
Expected: Server starts on localhost:3000

**Step 4: Commit**

```bash
git add website/
git commit -m "chore: scaffold Next.js website project with assets"
```

---

### Task 2: Global Layout, Fonts, and Theme

**Files:**
- Modify: `website/app/layout.tsx`
- Modify: `website/app/globals.css`
- Modify: `website/app/page.tsx` (clear default content)

**Step 1: Set up globals.css with dark theme and geometric pattern CSS**

Replace `globals.css` with:
- Dark background (`#0a0a0f`)
- Gold accent color variables (`--gold: #d4a853`, `--gold-light: #e8c97a`)
- Custom geometric pattern background using CSS (repeating SVG data URI of Islamic star pattern)
- Smooth scroll, custom scrollbar

**Step 2: Update layout.tsx**

- Set metadata: title "PrayerTime — Prayer Times in Your Menu Bar", description
- Use Inter + Amiri (Google Fonts) — Amiri for Arabic/Islamic accent text
- Dark body background

**Step 3: Clear page.tsx**

Replace with a simple "Coming soon" placeholder to verify theme works.

**Step 4: Verify theme renders**

Run dev server, confirm dark background and fonts load.

**Step 5: Commit**

```bash
git add website/app/
git commit -m "feat: set up dark theme, fonts, and global styles"
```

---

### Task 3: Hero Section Component

**Files:**
- Create: `website/app/components/Hero.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Hero component**

Contents:
- App icon (120px, rounded) with subtle glow effect
- Headline: "Prayer Times, Always Within Reach"
- Subtitle: "A beautiful macOS menu bar app that keeps you connected to your daily prayers with accurate times, Adhan notifications, and Hijri date — all just a click away."
- CTA button: "Download on the Mac App Store" (placeholder link, styled with gold accent)
- Main screenshot (`screenshot-prayers.png`) displayed in a macOS-style window frame with subtle shadow
- Decorative geometric pattern elements (SVG) flanking the hero

**Step 2: Add Hero to page.tsx**

Import and render `<Hero />`.

**Step 3: Verify in browser**

Confirm hero renders with icon, text, button, and screenshot.

**Step 4: Commit**

```bash
git add website/app/components/Hero.tsx website/app/page.tsx
git commit -m "feat: add hero section with app icon, CTA, and screenshot"
```

---

### Task 4: Screenshots Showcase Section

**Files:**
- Create: `website/app/components/Screenshots.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Screenshots component**

- Section title: "See It in Action"
- Display all 3 screenshots in a horizontal row (responsive — stacks on mobile)
- Each screenshot in a rounded card with subtle border and shadow
- Captions beneath each: "Clean Menu Bar Integration", "All Prayer Times at a Glance", "Customizable Settings"
- Subtle geometric divider above section

**Step 2: Add to page.tsx**

**Step 3: Verify responsive layout**

**Step 4: Commit**

```bash
git add website/app/components/Screenshots.tsx website/app/page.tsx
git commit -m "feat: add screenshots showcase section"
```

---

### Task 5: Features Section

**Files:**
- Create: `website/app/components/Features.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Features component**

6 feature cards in a 3x2 grid (responsive):

1. **Accurate Prayer Times** — Icon: clock/compass — "Uses the Aladhan API with 23+ calculation methods including ISNA, Muslim World League, Umm Al-Qura, and more."
2. **Adhan Notifications** — Icon: bell/speaker — "Choose between system notification, short Adhan, or full Adhan. Stop the Adhan anytime with one click."
3. **Islamic (Hijri) Date** — Icon: calendar — "View the current Hijri date in English or Arabic, displayed right alongside your prayer times."
4. **Menu Bar Display** — Icon: monitor — "Choose Icon Only, Icon + Countdown, or Prayer Name + Countdown to match your workflow."
5. **Smart & Automatic** — Icon: gear — "Auto-refreshes after midnight, supports 12/24-hour format, launches at login, and detects your location."
6. **Privacy First** — Icon: shield — "Your location is used solely for prayer time calculation. Never stored, never shared."

Each card: dark card background (`#12121a`), gold icon accent, title, description. Subtle border with geometric corner accents.

**Step 2: Add to page.tsx**

**Step 3: Verify grid layout and responsiveness**

**Step 4: Commit**

```bash
git add website/app/components/Features.tsx website/app/page.tsx
git commit -m "feat: add features section with 6 feature cards"
```

---

### Task 6: Motive Section

**Files:**
- Create: `website/app/components/Motive.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Motive component**

- Section with a different visual treatment — slightly lighter dark bg (`#0f0f18`), geometric pattern overlay
- Title: "Why I Built PrayerTime"
- Personal quote styled prominently: "I spend 90% of my day on my Mac."
- Body text: "As someone who spends nearly all day working on my Mac, I needed a way to stay connected to my prayers without disrupting my workflow. I couldn't find a prayer time app that felt truly native to macOS — one that lived quietly in the menu bar and just worked. So I built PrayerTime. It's the app I wished existed: minimal, accurate, and designed to feel like it belongs on your Mac."
- Subtle decorative crescent/mosque silhouette in background (CSS/SVG)

**Step 2: Add to page.tsx**

**Step 3: Verify styling**

**Step 4: Commit**

```bash
git add website/app/components/Motive.tsx website/app/page.tsx
git commit -m "feat: add motive/story section"
```

---

### Task 7: Contact Form Section

**Files:**
- Create: `website/app/components/Contact.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Contact component with Web3Forms**

- Section title: "Get in Touch"
- Subtitle: "Have feedback, a feature request, or just want to say hello?"
- Form fields: Name, Email, Message (textarea)
- Hidden input: `access_key` = `3a7556f1-d63a-4428-bdfa-f9ee82f10f3f`
- Form action: POST to `https://api.web3forms.com/submit`
- Client-side: use React state + fetch, show success/error message
- Gold submit button, dark input fields with subtle borders
- Inputs styled to match dark theme

**Step 2: Add to page.tsx**

**Step 3: Test form submission**

Submit a test message and verify it works via Web3Forms.

**Step 4: Commit**

```bash
git add website/app/components/Contact.tsx website/app/page.tsx
git commit -m "feat: add contact form with Web3Forms integration"
```

---

### Task 8: Footer

**Files:**
- Create: `website/app/components/Footer.tsx`
- Modify: `website/app/page.tsx`

**Step 1: Build Footer component**

- Minimal dark footer
- App icon (small) + "PrayerTime" text
- Links: Features (anchor), Contact (anchor), Privacy note
- Copyright: "© 2026 PrayerTime. All rights reserved."
- Subtle geometric border at top

**Step 2: Add to page.tsx**

**Step 3: Commit**

```bash
git add website/app/components/Footer.tsx website/app/page.tsx
git commit -m "feat: add footer"
```

---

### Task 9: Polish, Animations, and Responsive

**Files:**
- Modify: various components
- Modify: `website/app/globals.css`

**Step 1: Add scroll-triggered fade-in animations**

Use CSS `@keyframes` + Intersection Observer (lightweight, no library) for sections to fade in on scroll.

**Step 2: Verify mobile responsiveness**

Check all breakpoints: mobile (375px), tablet (768px), desktop (1280px+).

**Step 3: Add smooth scroll for anchor links**

Navigation from footer links should smooth-scroll to sections.

**Step 4: Commit**

```bash
git add website/
git commit -m "feat: add animations, polish responsive layout"
```

---

### Task 10: Vercel Deployment Prep

**Files:**
- Verify: `website/next.config.ts` (ensure images config is correct)
- Verify: build passes

**Step 1: Run production build**

```bash
cd website && npm run build
```

Expected: Build succeeds with no errors.

**Step 2: Verify with `npm start`**

Run `npm start` and check the production build renders correctly.

**Step 3: Final commit**

```bash
git add website/
git commit -m "chore: verify production build for Vercel deployment"
```
