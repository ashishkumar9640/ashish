"use client";

import Image from "next/image";
import { useState } from "react";

export default function Header() {
  const [open, setOpen] = useState(false);

  return (
    <header className="bg-black border-b border-neutral-800">
      <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">

        {/* LOGO */}
        <div className="flex items-center gap-3">
          <Image src="/logo.png" alt="Logo" width={36} height={36} />
          <span className="font-game text-lg">
            Smart <span className="text-yellow-400">Learn</span>
          </span>
        </div>

        {/* NAV */}
        <nav className="hidden md:flex items-center gap-8 text-neutral-300">
          <div className="relative">
            <button
              onClick={() => setOpen(!open)}
              className="hover:text-white"
            >
              Courses ▾
            </button>

            {open && (
              <div className="absolute top-8 left-0 bg-neutral-900 border border-neutral-700 rounded-md w-48 z-50">
                {[
                  "HTML",
                  "CSS",
                  "React",
                  "Advanced React",
                  "Python",
                  "Advanced Python",
                  "Generative AI",
                  "Machine Learning",
                  "JavaScript",
                ].map(item => (
                  <div
                    key={item}
                    className="px-4 py-2 text-sm hover:bg-neutral-800 cursor-pointer"
                  >
                    {item}
                  </div>
                ))}
              </div>
            )}
          </div>

          <a className="hover:text-white">Projects</a>
          <a className="hover:text-white">Pricing</a>
          <a className="hover:text-white">Contact Us</a>
        </nav>

        {/* SIGNUP BUTTON */}
        <button
          className="
            relative
            px-5 py-2
            font-game
            text-black
            rounded-xl
            bg-[#FFBB00]
            border-[3px] border-black
            shadow-[0_5px_0_0_#000]
            active:translate-y-[3px]
            active:shadow-[0_2px_0_0_#000]
          "
        >
          <span className="absolute inset-0 rounded-xl bg-gradient-to-b from-white/40 to-transparent opacity-40" />
          Signup
        </button>
      </div>
    </header>
  );
}
