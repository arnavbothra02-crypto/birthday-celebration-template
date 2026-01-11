import { useEffect, useState } from "react";
import "./Countdown.css";

export default function Countdown({
  unlockDate,
  birthdayReached,
  onBirthdayReached,
}) {
  const calculateTimeLeft = () => {
    const difference = unlockDate - new Date();
    if (difference <= 0) return null;

    return {
      days: Math.floor(difference / (1000 * 60 * 60 * 24)),
      hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((difference / (1000 * 60)) % 60),
      seconds: Math.floor((difference / 1000) % 60),
    };
  };

  const [timeLeft, setTimeLeft] = useState(calculateTimeLeft());
  const [flip, setFlip] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      const updated = calculateTimeLeft();

      if (!updated) {
        clearInterval(timer);
        onBirthdayReached();
        return;
      }

      setFlip((prev) => !prev);
      setTimeLeft(updated);
    }, 1000);

    return () => clearInterval(timer);
  }, [unlockDate]);

  if (!timeLeft) return null;

  const renderUnit = (value, label, pulse = false) => (
    <div className={`time-box ${flip ? "flip" : ""} ${pulse ? "pulse" : ""}`}>
      <span className="time-value">{String(value).padStart(2, "0")}</span>
      <span className="time-label">{label}</span>
    </div>
  );

  return (
    <div className="countdown-wrapper">
      <div className="countdown-glass">
        {renderUnit(timeLeft.days, "Days")}
        {renderUnit(timeLeft.hours, "Hours")}
        {renderUnit(timeLeft.minutes, "Minutes")}
        {renderUnit(timeLeft.seconds, "Seconds", timeLeft.minutes === 0)}
      </div>
    </div>
  );
}
