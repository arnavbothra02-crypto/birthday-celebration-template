import { useEffect, useState } from "react";

export default function Countdown({ unlockTimestamp, onBirthdayReached }) {
  const [now, setNow] = useState(Date.now());

  useEffect(() => {
    const interval = setInterval(() => {
      setNow(Date.now());
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  const diff = unlockTimestamp - now;

  const totalSeconds = Math.max(0, Math.floor(diff / 1000));
  const days = Math.floor(totalSeconds / (60 * 60 * 24));
  const hours = Math.floor((totalSeconds / (60 * 60)) % 24);
  const minutes = Math.floor((totalSeconds / 60) % 60);
  const seconds = Math.floor(totalSeconds % 60);

  useEffect(() => {
    if (diff <= 0) {
      onBirthdayReached();
    }
  }, [diff, onBirthdayReached]);

  return (
    <div
      style={{
        display: "flex",
        gap: "20px",
        justifyContent: "center",
        fontSize: "24px",
        marginTop: "20px",
      }}
    >
      <div>{days}d</div>
      <div>{hours}h</div>
      <div>{minutes}m</div>
      <div>{seconds}s</div>
    </div>
  );
}
