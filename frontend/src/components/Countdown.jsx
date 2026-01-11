import { useEffect, useState } from "react";
import "./Countdown.css";

export default function Countdown({ unlockDate, onBirthdayReached }) {
  const getTime = () => {
    const diff = unlockDate.getTime() - new Date().getTime();

    if (diff <= 0) {
      return {
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        unlocked: true,
      };
    }

    return {
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((diff / (1000 * 60)) % 60),
      seconds: Math.floor((diff / 1000) % 60),
      unlocked: false,
    };
  };

  const [time, setTime] = useState(getTime());
  const [flip, setFlip] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      const updated = getTime();
      setTime(updated);
      setFlip((f) => !f);

      if (updated.unlocked) {
        onBirthdayReached();
        clearInterval(timer);
      }
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  return (
    <div className="countdown-wrapper">
      <div className="countdown-glass">
        {["days", "hours", "minutes", "seconds"].map((key) => (
          <div
            key={key}
            className={`time-box ${flip ? "flip" : ""} ${
              key === "seconds" && time.minutes === 0 ? "pulse" : ""
            }`}
          >
            <span className="time-value">
              {String(time[key]).padStart(2, "0")}
            </span>
            <span className="time-label">{key}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
