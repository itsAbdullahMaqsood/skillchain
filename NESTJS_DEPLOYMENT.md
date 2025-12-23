# NestJS Backend Deployment Guide

## Your Backend Structure:
- **Framework**: NestJS (TypeScript)
- **Database**: MongoDB (Mongoose)
- **Port**: 3001 (or PORT env variable)
- **API Routes**: `/users/signup`, `/users/login`
- **Swagger Docs**: Available at `/api` endpoint

## Deployment Options for NestJS:

### ✅ Option 1: Railway (BEST for NestJS - Recommended)
**Why Railway?**
- Perfect for NestJS applications
- Automatic MongoDB setup available
- Easy environment variable management
- Free tier with $5 credit/month
- Simple deployment from GitHub

**Steps:**
1. Go to https://railway.app and sign up
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your backend repository
4. Railway will auto-detect NestJS
5. Add MongoDB service (or use MongoDB Atlas)
6. Set environment variables:
   - `PORT` (Railway sets this automatically)
   - `MONGODB_URI` (your MongoDB connection string)
   - Any other env vars your app needs
7. Deploy!
8. Get your URL: `https://your-app.railway.app`

### ✅ Option 2: Render
**Steps:**
1. Go to https://render.com
2. Create new "Web Service"
3. Connect your GitHub repo
4. Build command: `npm install && npm run build`
5. Start command: `npm run start:prod`
6. Add MongoDB (or use MongoDB Atlas)
7. Set environment variables
8. Deploy!

### ✅ Option 3: Heroku
**Steps:**
1. Install Heroku CLI
2. `heroku create your-app-name`
3. `git push heroku main`
4. Add MongoDB addon: `heroku addons:create mongolab`
5. Set environment variables
6. Deploy!

### ⚠️ Option 4: Vercel (Limited)
**Note**: Vercel works but has limitations:
- Serverless functions (10s timeout on free tier)
- Need to restructure for serverless
- Not ideal for traditional NestJS apps

## Required Environment Variables:

Based on your backend structure, you'll need:

```env
PORT=3001
MONGODB_URI=mongodb://your-connection-string
# Add any other env vars your app uses
```

## Database Setup:

### Option A: MongoDB Atlas (Cloud Database - Recommended)
1. Go to https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Get connection string
4. Add to environment variables as `MONGODB_URI`

### Option B: Railway MongoDB
- Railway offers MongoDB as a service
- Automatically sets `MONGODB_URI`

## After Deployment:

1. **Update Flutter App:**
   - Edit `lib/services/api_service.dart`
   - Change `baseUrl` to your deployed URL
   - Example: `static const String baseUrl = 'https://your-app.railway.app/api';`

2. **Rebuild APK:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Test:**
   - Install APK on any device
   - Should work from anywhere in the world!

## Quick Railway Deployment (Recommended):

1. **Prepare your backend:**
   - Make sure backend is in a separate GitHub repo (or move it out of Flutter project)
   - Or deploy from the folder: `lib/skill-chain-backend-master`

2. **Deploy:**
   - Go to Railway.app
   - New Project → Deploy from GitHub
   - Select repo
   - Add MongoDB service
   - Set `MONGODB_URI` environment variable
   - Deploy!

3. **Get URL and update Flutter app**

## Important Notes:

- **CORS**: Your backend already has `app.enableCors()` which is good!
- **Swagger**: Available at `https://your-url/api` for API documentation
- **Database**: Make sure MongoDB is accessible from your cloud service
- **Environment Variables**: Keep sensitive data in environment variables, not in code

