# 🎂 Birthday Celebration Website for Swastika

A romantic corporate-style birthday countdown website built with React 18 + Vite.

## 🚀 Vercel Deployment Instructions

### Option 1: Deploy from GitHub (Recommended)

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Updated for Vercel deployment with React 18"
   git push origin main
   ```

2. **Import to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Click "Add New Project"
   - Import your GitHub repository
   - **Important Settings**:
     - Framework Preset: `Vite`
     - Root Directory: `./` (leave as root)
     - Build Command: `npm run build`
     - Output Directory: `dist`
     - Install Command: `npm install`
     - Node Version: `20.x` (recommended)

3. Click **Deploy**!

### Option 2: Deploy via Vercel CLI

```bash
npm install -g vercel
cd /path/to/project
vercel --prod
```

## 📦 Tech Stack

- **React**: 18.2.0
- **Vite**: 5.2.0
- **GSAP**: 3.14.2 (animations)
- **Node**: 18.x or 20.x

## ⚙️ Local Development

```bash
# Install dependencies
npm install

# Start dev server (http://localhost:5173)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 🎨 Customization

### Update Birthday Date
Edit `src/components/Countdown.jsx` line 22:
```javascript
const birthdayDate = new Date("2026-02-01T00:00:00");
```

### Update Message
Edit `src/components/MessageCard.jsx` to customize the birthday message.

### Add Images
Place images in `public/images/` folder (pic1.jpg through pic6.jpg)

### Add Music
Place your music file at `public/music.mp3`

## 🔍 Verification

✅ React 18.2.0 (No React 19 references)
✅ Clean dependency tree (No legacy-peer-deps)
✅ Vite 5.2.0 (Stable version)
✅ ESLint 8.x (Compatible configuration)
✅ Build succeeds: `npm run build`
✅ Node 18/20 compatible

## 🎉 Features

- Countdown timer to birthday (Feb 1, 2026)
- Animated curtain reveal for message
- Photo gallery
- Background music
- Confetti effects
- Mobile responsive
- Smooth GSAP animations

## 📝 Notes

- Birthday message celebrates Swastika with romantic corporate tone
- Signatures: "Mother of Dragons, MD 🐉" & "CEO of Missing Her"
- All application logic and UI preserved from original design
- Only dependency/config fixes applied for Vercel compatibility

---

**Made with 💖 for Swastika's Birthday**
