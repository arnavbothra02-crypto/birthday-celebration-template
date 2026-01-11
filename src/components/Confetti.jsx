import { useEffect, useState } from "react";
import "./Countdown.css";

function Countdown({ unlockDate, onBirthdayReached, birthdayReached }) {
  const calculateTimeLeft = () => {
    const now = new Date();
    const difference = unlockDate - now;

    if (difference <= 0) {
      onBirthdayReached();
      return { days: 0, hours: 0, minutes: 0, seconds: 0 };
    }

    return {
      days: Math.floor(difference / (1000 * 60 * 60 * 24)),
      hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((difference / (1000 * 60)) % 60),
      seconds: Math.floor((difference / 1000) % 60),
    };
  };

  const [timeLeft, setTimeLeft] = useState(calculateTimeLeft());

  useEffect(() => {
    if (birthdayReached) return;
    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);
    return () => clearInterval(timer);
  }, [birthdayReached]);

  return (
    <div className="countdown-wrapper">
      {Object.entries(timeLeft).map(([label, value]) => (
        <div className="countdown-card" key={label}>
          <span className="countdown-number">{value}</span>
          <span className="countdown-label">{label}</span>
        </div>
      ))}
    </div>
  );
}

export default Countdown;
