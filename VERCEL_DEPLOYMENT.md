# Deploying Backend to Vercel

## Yes, Vercel will work! Here's how:

### Vercel Pros:
✅ Free tier available
✅ Easy deployment from GitHub
✅ Automatic HTTPS/SSL
✅ Global CDN
✅ Great for Node.js/Express APIs
✅ Serverless functions (good for APIs)

### Vercel Cons:
⚠️ Serverless functions have execution time limits (10s on free tier, 60s on pro)
⚠️ Not ideal for long-running processes or WebSocket connections
⚠️ Cold starts on free tier (first request may be slower)

## Setup Steps:

### 1. Prepare Your Backend for Vercel

Your backend needs to export a serverless function. If you're using Express:

**Option A: If you have an Express app**
Create `api/index.js` (or `api/index.ts`):
```javascript
const express = require('express');
const app = express();

// Your existing routes
app.use('/users', require('./routes/users'));

// Export as serverless function
module.exports = app;
```

**Option B: Use Vercel's API routes structure**
Create `api/users/signup.js`:
```javascript
export default async function handler(req, res) {
  if (req.method === 'POST') {
    // Your signup logic
    res.status(201).json({ user: {...} });
  }
}
```

### 2. Create `vercel.json` Configuration

```json
{
  "version": 2,
  "builds": [
    {
      "src": "api/**/*.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    }
  ]
}
```

### 3. Deploy to Vercel

**Via CLI:**
```bash
npm i -g vercel
vercel login
vercel
```

**Via GitHub:**
1. Push your backend code to GitHub
2. Go to https://vercel.com
3. Import your repository
4. Vercel will auto-detect and deploy

### 4. Get Your Vercel URL

After deployment, you'll get a URL like:
- `https://your-project.vercel.app`
- Or custom domain if configured

### 5. Update Flutter App

In `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-project.vercel.app/api';
```

### 6. Rebuild APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Important Notes:

- **API Routes**: Vercel expects API routes in `/api` folder
- **Environment Variables**: Set them in Vercel dashboard (Settings → Environment Variables)
- **Database**: If using a database, use a cloud service (MongoDB Atlas, Supabase, etc.)
- **CORS**: Make sure your backend allows requests from mobile apps

## Alternative: If Vercel doesn't fit your needs

If your backend has long-running processes or WebSockets, consider:
- **Railway** (recommended) - Easy, supports any Node.js app
- **Render** - Similar to Railway
- **Heroku** - Classic option
- **DigitalOcean App Platform** - More control

