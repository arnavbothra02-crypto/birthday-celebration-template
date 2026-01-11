import { gsap } from "gsap";
import { ScrollToPlugin } from "gsap/ScrollToPlugin";
import { useRef, useState } from "react";
import "./App.css";

import CelebrationPage from "./components/CelebrationPage";
import Countdown from "./components/Countdown";
import Effects from "./components/Effects";
import Gallery from "./components/Gallery";
import Hearts from "./components/Hearts";
import MessageCard from "./components/MessageCard";
import MusicPlayer from "./components/MusicPlayer";

gsap.registerPlugin(ScrollToPlugin);

/* =======================
   🔐 CONFIG (EDIT HERE)
   ======================= */
const PERSON_NAME = "Swastika";
const PERSONAL_MESSAGE = "Happy Birthday ❤️ This is just for you.";
const YOUR_NAME = "Arnav";
const UNLOCK_DATE = new Date(Date.now() + 10 * 60 * 1000); // 1 Feb midnight

function App() {
  const [currentPage, setCurrentPage] = useState(1);

  // 🔒 DATE-BASED LOCK (no localStorage, no cache issues)
  const [birthdayReached, setBirthdayReached] = useState(
    new Date() >= UNLOCK_DATE
  );

  const [showEffects, setShowEffects] = useState(false);

  const page1Ref = useRef(null);
  const page2Ref = useRef(null);
  const page3Ref = useRef(null);
  const page4Ref = useRef(null);
  const musicPlayerRef = useRef(null);

  const goToPage = (pageNumber) => {
    const refs = {
      1: page1Ref,
      2: page2Ref,
      3: page3Ref,
      4: page4Ref,
    };

    const currentRef = refs[currentPage];
    const nextRef = refs[pageNumber];
    const isForward = pageNumber > currentPage;

    gsap.to(currentRef.current, {
      x: isForward ? "-100%" : "100%",
      opacity: 0,
      duration: 0.6,
      ease: "power2.inOut",
    });

    gsap.set(nextRef.current, {
      x: isForward ? "100%" : "-100%",
      opacity: 0,
      visibility: "visible",
    });

    gsap.to(nextRef.current, {
      x: "0%",
      opacity: 1,
      duration: 0.6,
      delay: 0.2,
      ease: "power2.inOut",
      onComplete: () => {
        setCurrentPage(pageNumber);
        gsap.set(currentRef.current, { visibility: "hidden", x: "0%" });
        gsap.to(window, { scrollTo: { y: 0 }, duration: 0.3 });
      },
    });
  };

  const handleBirthdayReached = () => {
    setBirthdayReached(true);
    setShowEffects(true);
    setTimeout(() => setShowEffects(false), 10000);
  };

  return (
    <div className="app">
      <MusicPlayer ref={musicPlayerRef} />
      <Hearts />

      {/* ================= PAGE 1 : COUNTDOWN ================= */}
      <div
        ref={page1Ref}
        className={`page ${currentPage === 1 ? "active" : ""}`}
        style={{ visibility: currentPage === 1 ? "visible" : "hidden" }}
      >
        <section className="hero">
          <h1 id="heroTitle">
            {birthdayReached ? (
              <>
                Happy Birthday{" "}
                <span className="highlight">{PERSON_NAME}</span> 🎂
              </>
            ) : (
              <>
                Counting down to{" "}
                <span className="highlight">{PERSON_NAME}'s</span> special day 🎂
              </>
            )}
          </h1>
          <p>{PERSONAL_MESSAGE}</p>
        </section>

        <Countdown
          onBirthdayReached={handleBirthdayReached}
          birthdayReached={birthdayReached}
          unlockDate={UNLOCK_DATE}
        />

        <section className="teaser">
          <h2 id="teaserHeading">
            {birthdayReached
              ? "💖 Ready for your surprise! 💖"
              : "✨ A special celebration awaits you at midnight... ✨"}
          </h2>
          <p className="teaser-hint">
            Something magical is about to unfold 💫
          </p>
        </section>

        <button
          className="celebrate-btn"
          disabled={!birthdayReached}
          onClick={() => goToPage(2)}
        >
          🎀 Let's Celebrate
        </button>
      </div>

      {/* ================= PAGE 2 : CELEBRATION ================= */}
      <div
        ref={page2Ref}
        className={`page ${currentPage === 2 ? "active" : ""}`}
        style={{ visibility: currentPage === 2 ? "visible" : "hidden" }}
      >
        <CelebrationPage
          onComplete={() => goToPage(3)}
          musicPlayerRef={musicPlayerRef}
        />
      </div>

      {/* ================= PAGE 3 : MESSAGE ================= */}
      <div
        ref={page3Ref}
        className={`page ${currentPage === 3 ? "active" : ""}`}
        style={{ visibility: currentPage === 3 ? "visible" : "hidden" }}
      >
        <button className="back-btn" onClick={() => goToPage(2)}>
          ← Back
        </button>

        <MessageCard isActive={currentPage === 3} />

        <button className="page-nav-btn" onClick={() => goToPage(4)}>
          📸 View Our Memories
        </button>
      </div>

      {/* ================= PAGE 4 : GALLERY ================= */}
      <div
        ref={page4Ref}
        className={`page ${currentPage === 4 ? "active" : ""}`}
        style={{ visibility: currentPage === 4 ? "visible" : "hidden" }}
      >
        <button className="back-btn" onClick={() => goToPage(3)}>
          ← Back
        </button>

        <Gallery isActive={currentPage === 4} />

        <section className="final">
          <h2 className="final-message">
            💖 Forever Yours — {YOUR_NAME} 💖
          </h2>
          <p className="final-subtitle">
            Every memory, every moment, always you ✨
          </p>
        </section>
      </div>

      {showEffects && <Effects />}
    </div>
  );
}
export default App;
