# Backend Deployment Guide

## To make your app work on any device worldwide, you need to deploy your backend server to a public cloud service.

## Quick Options:

### Option 1: Railway (Easiest - Recommended for Quick Start)
1. Go to https://railway.app
2. Sign up (free tier available)
3. Connect your GitHub repo or deploy directly
4. Set environment variables if needed
5. Railway gives you a public URL like: `https://your-app.railway.app`
6. Update the API base URL in `lib/services/api_service.dart`

### Option 2: Render
1. Go to https://render.com
2. Sign up (free tier available)
3. Create a new Web Service
4. Connect your repository
5. Render gives you a URL like: `https://your-app.onrender.com`

### Option 3: Heroku
1. Go to https://heroku.com
2. Sign up (free tier limited, paid options available)
3. Install Heroku CLI
4. Deploy your backend
5. Get URL like: `https://your-app.herokuapp.com`

### Option 4: DigitalOcean / AWS / Google Cloud
- More complex but more control
- Good for production with high traffic
- Requires more setup and configuration

### Option 5: VPS (Virtual Private Server)
- Rent a VPS from providers like:
  - DigitalOcean ($5/month)
  - Linode
  - Vultr
  - AWS EC2
- Deploy your backend manually
- You'll get a public IP address

## Steps After Deployment:

1. **Update API URL in Flutter app:**
   - Edit `lib/services/api_service.dart`
   - Change `baseUrl` to your deployed backend URL
   - Example: `static const String baseUrl = 'https://your-app.railway.app/api';`

2. **Rebuild APK:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Test the connection:**
   - Install the new APK on your device
   - Try login/signup
   - Should work from anywhere in the world!

## Important Notes:

- **SSL/HTTPS**: Make sure your deployed backend uses HTTPS (most cloud services provide this automatically)
- **CORS**: Configure your backend to allow requests from your Flutter app
- **Environment Variables**: Store sensitive data (API keys, database URLs) as environment variables
- **Database**: If your backend uses a database, you'll need to deploy that too (or use a cloud database service)

