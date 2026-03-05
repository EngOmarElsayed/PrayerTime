import Navbar from "./components/Navbar";
import Hero from "./components/Hero";
import Screenshots from "./components/Screenshots";
import Features from "./components/Features";
import Motive from "./components/Motive";
import Contact from "./components/Contact";
import Footer from "./components/Footer";
import FadeIn from "./components/FadeIn";

export default function Home() {
  return (
    <main>
      <Navbar />
      <Hero />
      <FadeIn><Screenshots /></FadeIn>
      <FadeIn delay={100}><Features /></FadeIn>
      <FadeIn delay={100}><Motive /></FadeIn>
      <FadeIn delay={100}><Contact /></FadeIn>
      <Footer />
    </main>
  );
}
