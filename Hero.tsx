"use client";

export default function Hero() {
  return (
    <section className="relative min-h-[calc(100vh-72px)] flex items-center justify-center">

      {/* Background */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: "url('/pixel-room.png')" }}
      />

      {/* Dark overlay */}
      <div className="absolute inset-0 bg-black/60" />

      {/* Content */}
      <div className="relative z-10 text-center px-6">

        {/* Subtitle */}
        <h2
          className="font-game font-bold text-white text-3xl md:text-4xl mb-2 tracking-wide"
          style={{ textShadow: "3px 3px 0 #000" }}
        >
          Start Your
        </h2>

        {/* Main Title */}
        <h1
          className="font-game font-bold text-yellow-400 text-4xl md:text-6xl mb-4 tracking-wider"
          style={{ textShadow: "4px 4px 0 #000" }}
        >
          Coding Adventure
        </h1>

        {/* Description */}
        <p
          className="font-semibold text-neutral-300 mb-8"
          style={{ textShadow: "2px 2px 0 #000" }}
        >
          Beginner friendly coding courses and projects
        </p>

        {/* CTA Button */}
        <button
          className="
            relative
            px-8 py-3
            font-game
            font-bold
            text-black
            text-lg
            rounded-xl
            bg-[#FFBB00]
            border-[3px] border-black
            shadow-[0_6px_0_0_#000]
            active:translate-y-[3px]
            active:shadow-[0_3px_0_0_#000]
          "
        >
          <span className="absolute inset-0 rounded-xl bg-gradient-to-b from-white/40 to-transparent opacity-40" />
          GET STARTED
        </button>

      </div>
    </section>
  );
}
