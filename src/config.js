// 🎂 Birthday Configuration
// Edit this file to personalize the celebration

export const PERSON_NAME = "Swastika";

// Birthday unlock date (local time)
export const UNLOCK_DATE = new Date("2026-02-01T00:00:00");

// Check if birthday has arrived
export const isBirthdayUnlocked = () => {
  return new Date() >= UNLOCK_DATE;
};
