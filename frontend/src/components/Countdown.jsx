import { useEffect, useState } from "react";
import "./Countdown.css";

function Countdown({ unlockDate, birthdayReached, onBirthdayReached }) {
  const calculateTimeLeft = () => {
    const now = new Date().getTime();
    const diff = unlockDate.getTime() - now;

    if (diff <= 0) {
      return null;
    }

    return {
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((diff / (1000 * 60)) % 60),
      seconds: Math.floor((diff / 1000) % 60),
    };
  };

  const [timeLeft, setTimeLeft] = useState(calculateTimeLeft());

  useEffect(() => {
    if (!timeLeft && !birthdayReached) {
      onBirthdayReached();
      return;
    }

    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);

    return () => clearInterval(timer);
  }, [timeLeft, birthdayReached, onBirthdayReached]);

  // 🔒 LOCKED STATE → SHOW COUNTDOWN
  if (!birthdayReached && timeLeft) {
    return (
      <div className="countdown-container">
        <div className="countdown-box">
          <span>{timeLeft.days}</span>
          <label>DAYS</label>
        </div>
        <div className="countdown-box">
          <span>{timeLeft.hours}</span>
          <label>HOURS</label>
        </div>
        <div className="countdown-box">
          <span>{timeLeft.minutes}</span>
          <label>MINUTES</label>
        </div>
        <div className="countdown-box">
          <span>{timeLeft.seconds}</span>
          <label>SECONDS</label>
        </div>
      </div>
    );
  }

  // 🔓 UNLOCKED → COUNTDOWN DISAPPEARS
  return null;
}
export default Countdown;
