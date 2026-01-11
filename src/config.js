// 🎂 Birthday Configuration
// Edit this file to personalize the celebration

export const PERSON_NAME = "Swastika";

// Personalized message
export const BIRTHDAY_MESSAGE = "Happy Birthday ❤️ This is just for you.";

// Closing signature
export const CLOSING_SIGNATURE = "Forever Yours — Arnav";

// Birthday unlock date (local time)
export const UNLOCK_DATE = new Date("2026-02-01T00:00:00");

// Check if birthday has arrived
export const isBirthdayUnlocked = () => {
  return new Date() >= UNLOCK_DATE;
};
