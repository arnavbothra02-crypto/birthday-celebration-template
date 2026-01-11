import { useEffect, useState } from "react";
import "./Countdown.css";

function Countdown({ unlockTimestamp, onBirthdayReached }) {
  const calculateTimeLeft = () => {
    const now = Date.now();
    const diff = unlockTimestamp - now;

    if (diff <= 0) {
      return {
        done: true,
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
      };
    }

    return {
      done: false,
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((diff / (1000 * 60)) % 60),
      seconds: Math.floor((diff / 1000) % 60),
    };
  };

  const [timeLeft, setTimeLeft] = useState(calculateTimeLeft);

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        const updated = calculateTimeLeft();

        if (!prev.done && updated.done) {
          onBirthdayReached?.();
        }

        return updated;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [unlockTimestamp]);

  if (timeLeft.done) return null;

  return (
    <div className="countdown">
      <div className="time-box">
        <span>{timeLeft.days}</span>
        <small>Days</small>
      </div>
      <div className="time-box">
        <span>{timeLeft.hours}</span>
        <small>Hours</small>
      </div>
      <div className="time-box">
        <span>{timeLeft.minutes}</span>
        <small>Minutes</small>
      </div>
      <div className="time-box">
        <span>{timeLeft.seconds}</span>
        <small>Seconds</small>
      </div>
    </div>
  );
}

export default Countdown;
