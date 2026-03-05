"use client";

import { useState, FormEvent } from "react";

export default function Contact() {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [successMessage, setSuccessMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  async function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setIsSubmitting(true);
    setSuccessMessage("");
    setErrorMessage("");

    const form = e.currentTarget;
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());

    try {
      const response = await fetch("https://api.web3forms.com/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        setSuccessMessage(
          "Thanks for reaching out! I'll get back to you soon."
        );
        form.reset();
      } else {
        setErrorMessage("Something went wrong. Please try again.");
      }
    } catch {
      setErrorMessage("Network error. Please check your connection and try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <section id="contact" className="py-20 px-6">
      {/* Section Header */}
      <div className="text-center mb-14">
        <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
          Get in Touch
        </h2>
        <p className="text-foreground-muted text-lg max-w-2xl mx-auto leading-relaxed">
          Have feedback, a feature request, or just want to say hello?
        </p>
      </div>

      {/* Contact Form */}
      <form
        onSubmit={handleSubmit}
        className="max-w-lg mx-auto space-y-5"
      >
        <input
          type="hidden"
          name="access_key"
          value="3a7556f1-d63a-4428-bdfa-f9ee82f10f3f"
        />

        {/* Name Field */}
        <div>
          <label
            htmlFor="name"
            className="block text-foreground-muted text-sm font-medium mb-1.5"
          >
            Name
          </label>
          <input
            type="text"
            id="name"
            name="name"
            required
            placeholder="Your name"
            className="w-full bg-surface border border-border rounded-lg px-4 py-3 text-foreground placeholder:text-foreground-muted/50 focus:outline-none focus:border-gold transition-colors duration-200"
          />
        </div>

        {/* Email Field */}
        <div>
          <label
            htmlFor="email"
            className="block text-foreground-muted text-sm font-medium mb-1.5"
          >
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            required
            placeholder="your@email.com"
            className="w-full bg-surface border border-border rounded-lg px-4 py-3 text-foreground placeholder:text-foreground-muted/50 focus:outline-none focus:border-gold transition-colors duration-200"
          />
        </div>

        {/* Message Field */}
        <div>
          <label
            htmlFor="message"
            className="block text-foreground-muted text-sm font-medium mb-1.5"
          >
            Message
          </label>
          <textarea
            id="message"
            name="message"
            rows={4}
            required
            placeholder="Your message..."
            className="w-full bg-surface border border-border rounded-lg px-4 py-3 text-foreground placeholder:text-foreground-muted/50 focus:outline-none focus:border-gold transition-colors duration-200 resize-vertical"
          />
        </div>

        {/* Submit Button */}
        <button
          type="submit"
          disabled={isSubmitting}
          className="w-full py-3 rounded-xl text-lg font-semibold text-black transition-all duration-300 hover:scale-105 hover:shadow-lg disabled:opacity-60 disabled:hover:scale-100 disabled:cursor-not-allowed"
          style={{
            background: "linear-gradient(135deg, #d4a853, #e8c97a, #d4a853)",
            boxShadow: "0 4px 24px rgba(212, 168, 83, 0.3)",
          }}
        >
          {isSubmitting ? "Sending..." : "Send Message"}
        </button>

        {/* Success Message */}
        {successMessage && (
          <p className="text-green-400 text-sm text-center mt-3">
            {successMessage}
          </p>
        )}

        {/* Error Message */}
        {errorMessage && (
          <p className="text-red-400 text-sm text-center mt-3">
            {errorMessage}
          </p>
        )}
      </form>
    </section>
  );
}
