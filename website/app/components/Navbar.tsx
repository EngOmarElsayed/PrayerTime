"use client";

import { useState, useEffect } from "react";
import Image from "next/image";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Close mobile menu when a link is clicked
  const handleLinkClick = () => {
    setIsOpen(false);
  };

  const navLinks = [
    { label: "Features", href: "#features" },
    { label: "Why", href: "#story" },
    { label: "Contact", href: "#contact" },
  ];

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-background/80 backdrop-blur-xl border-b border-border shadow-lg shadow-black/10"
          : "bg-transparent"
      }`}
    >
      <div className="max-w-6xl mx-auto px-6 flex items-center justify-between h-16">
        {/* Logo */}
        <a href="#" className="flex items-center gap-2.5 group">
          <Image
            src="/images/app-icon.png"
            alt="PrayerTime"
            width={32}
            height={32}
            className="rounded-lg"
          />
          <span className="text-white font-semibold text-lg group-hover:text-gold-light transition-colors">
            PrayerTime
          </span>
        </a>

        {/* Desktop Navigation */}
        <div className="hidden md:flex items-center gap-8">
          {navLinks.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className="text-foreground-muted hover:text-gold-light transition-colors text-sm font-medium"
            >
              {link.label}
            </a>
          ))}
          <a
            href="#"
            className="gold-btn px-4 py-2 rounded-lg text-sm font-semibold"
          >
            Download
          </a>
        </div>

        {/* Mobile Hamburger Button */}
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="md:hidden flex flex-col justify-center items-center w-10 h-10 rounded-lg hover:bg-surface transition-colors"
          aria-label="Toggle menu"
        >
          <span
            className={`block w-5 h-0.5 bg-foreground-muted transition-all duration-300 ${
              isOpen ? "rotate-45 translate-y-[3px]" : ""
            }`}
          />
          <span
            className={`block w-5 h-0.5 bg-foreground-muted mt-1 transition-all duration-300 ${
              isOpen ? "opacity-0" : ""
            }`}
          />
          <span
            className={`block w-5 h-0.5 bg-foreground-muted mt-1 transition-all duration-300 ${
              isOpen ? "-rotate-45 -translate-y-[7px]" : ""
            }`}
          />
        </button>
      </div>

      {/* Mobile Menu */}
      <div
        className={`md:hidden overflow-hidden transition-all duration-300 ${
          isOpen ? "max-h-64 border-b border-border" : "max-h-0"
        }`}
        style={{
          backgroundColor: scrolled ? "rgba(10, 10, 15, 0.95)" : "rgba(10, 10, 15, 0.98)",
          backdropFilter: "blur(20px)",
        }}
      >
        <div className="px-6 py-4 flex flex-col gap-3">
          {navLinks.map((link) => (
            <a
              key={link.href}
              href={link.href}
              onClick={handleLinkClick}
              className="text-foreground-muted hover:text-gold-light transition-colors text-base font-medium py-2"
            >
              {link.label}
            </a>
          ))}
          <a
            href="#"
            onClick={handleLinkClick}
            className="gold-btn inline-flex justify-center px-4 py-2.5 rounded-lg text-sm font-semibold mt-1"
          >
            Download
          </a>
        </div>
      </div>
    </nav>
  );
}
