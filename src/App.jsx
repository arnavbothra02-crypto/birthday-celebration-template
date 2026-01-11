import { useEffect, useRef, useState } from "react";
import "./App.css";

const PERSON_NAME = "Swastika";
const PERSONAL_MESSAGE = "Happy Birthday ❤️ This is just for you.";
const UNLOCK_DATE = new Date("2026-02-01T00:00:00");

const IMAGES = [
  "/images/pic1.jpeg",
  "/images/pic2.jpeg",
  "/images/pic3.jpeg",
  "/images/pic4.jpeg",
  "/images/pic5.jpeg",
  "/images/pic6.jpeg",
];

function App() {
  const [now, setNow] = useState(new Date());
  const unlocked = now >= UNLOCK_DATE;

  useEffect(() => {
    const timer = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  const timeLeft = UNLOCK_DATE - now;
  const hours = Math.max(Math.floor(timeLeft / (1000 * 60 * 60)), 0);
  const minutes = Math.max(Math.floor((timeLeft / (1000 * 60)) % 60), 0);
  const seconds = Math.max(Math.floor((timeLeft / 1000) % 60), 0);

  return (
    <div className="App">
      <div className="container">
        <h1>
          Counting down to <span className="highlight">{PERSON_NAME}</span>'s
          special day 🎂
        </h1>

        <p className="message">{PERSONAL_MESSAGE}</p>

        {!unlocked ? (
          <>
            <div className="countdown">
              <div>{hours}<span>HOURS</span></div>
              <div>{minutes}<span>MINUTES</span></div>
              <div>{seconds}<span>SECONDS</span></div>
            </div>
            <p className="locked-text">
              ✨ A special celebration awaits you at midnight ✨
            </p>
          </>
        ) : (
          <>
            <h2>🎉 It’s finally time! 🎉</h2>
            <div className="gallery">
              {IMAGES.map((src, i) => (
                <img key={i} src={src} alt={`memory-${i}`} />
              ))}
            </div>

            <audio controls autoPlay loop>
              <source src="/music.mp3" type="audio/mpeg" />
            </audio>
          </>
        )}
      </div>
    </div>
  );
}
export default App;
