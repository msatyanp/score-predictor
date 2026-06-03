# 🚀 Quick Start Guide - Complete Deployment

Your project is now ready to push to GitHub and deploy to Railway! Follow these steps in order.

---

## ✅ What's Been Done

1. ✅ Removed old Git remote (sarojshakya01's repo)
2. ✅ Updated `.gitignore` to exclude sensitive files
3. ✅ Created `.env.example` template
4. ✅ Added Railway configuration (`railway.toml`)
5. ✅ Updated Dockerfile for Railway compatibility
6. ✅ Created comprehensive deployment guides
7. ✅ Committed all changes locally
8. ✅ `.env` is NOT being tracked (safe!)

---

## 📝 Next Steps

### Step 1: Push to Your GitHub Account

1. **Create a new repository on GitHub**:
   - Go to: https://github.com/new
   - Name: `score-predictor` (or your choice)
   - Visibility: Public or Private
   - **Don't initialize with README**
   - Click "Create repository"

2. **Add your GitHub remote**:
   ```bash
   cd /Users/satya/Desktop/score-predictor
   git remote add origin https://github.com/YOUR_USERNAME/score-predictor.git
   ```
   Replace `YOUR_USERNAME` with your GitHub username

3. **Push to GitHub**:
   ```bash
   git push -u origin main
   ```
   
   If you need authentication help, see [GITHUB_SETUP.md](GITHUB_SETUP.md)

---

### Step 2: Deploy Backend to Railway

1. **Sign up/Login to Railway**:
   - Go to: https://railway.app
   - Sign up with GitHub

2. **Create New Project**:
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your `score-predictor` repository
   - Railway will detect the Dockerfile automatically

3. **Configure Root Directory**:
   - In Railway dashboard → Settings → Service Settings
   - Set "Root Directory" to: `backend`
   - Save changes

4. **Add Environment Variables**:
   - Go to Variables tab
   - Click "New Variable" and add each one:

   ```
   DATABASE_URL=mysql+aiomysql://satmah7_football:football123%23%40%21@mysql.freehostia.com/satmah7_football
   JWT_SECRET=change_this_to_a_long_random_secret
   JWT_ALGORITHM=HS256
   JWT_ACCESS_EXPIRE_MINUTES=30
   JWT_REFRESH_EXPIRE_MINUTES=10080
   EMAIL_FROM=your@email.com
   EMAIL_PASS=your_app_password
   EMAIL_SMTP=smtp.gmail.com
   EMAIL_PORT=587
   SITE_URL=https://your-frontend.vercel.app
   API_BASE_PATH=/api/v1
   CORS_ORIGINS=["http://localhost:8026"]
   PORT=8025
   ```

   **Note**: Update these with your real values, especially:
   - `EMAIL_FROM` and `EMAIL_PASS` (Gmail app password)
   - `JWT_SECRET` (use a long random string)
   - We'll update `SITE_URL` and `CORS_ORIGINS` after deploying frontend

5. **Deploy**:
   - Railway will automatically start building
   - Wait 2-3 minutes for deployment
   - Once deployed, click "Settings" → "Networking" → "Generate Domain"
   - Copy your Railway URL (e.g., `https://score-predictor-production-xxxx.up.railway.app`)

6. **Test Backend**:
   ```bash
   curl https://your-backend-url.railway.app/health
   # Should return: {"status":"healthy"}
   ```

---

### Step 3: Deploy Frontend to Vercel

1. **Sign up/Login to Vercel**:
   - Go to: https://vercel.com
   - Sign up with GitHub

2. **Import Project**:
   - Click "Add New" → "Project"
   - Select your `score-predictor` repository
   - Click "Import"

3. **Configure Build Settings**:
   - Framework Preset: **Next.js** (auto-detected)
   - Root Directory: **frontend**
   - Build Command: `npm run build` (default)
   - Output Directory: `.next` (default)

4. **Add Environment Variable**:
   - Expand "Environment Variables"
   - Add:
     ```
     Name: NEXT_PUBLIC_API_BASE_URL
     Value: https://your-backend-url.railway.app/api/v1
     ```
   - Use the Railway URL from Step 2

5. **Deploy**:
   - Click "Deploy"
   - Wait for build to complete (~2-3 minutes)
   - Copy your Vercel URL (e.g., `https://score-predictor.vercel.app`)

---

### Step 4: Update Backend CORS Settings

Now that frontend is deployed, update Railway environment variables:

1. Go to Railway dashboard → Your service → Variables
2. Update these variables:
   ```
   SITE_URL=https://your-frontend.vercel.app
   CORS_ORIGINS=["https://your-frontend.vercel.app"]
   ```
3. Railway will automatically redeploy

---

## 🎉 You're Live!

- **Frontend**: https://your-frontend.vercel.app
- **Backend**: https://your-backend-url.railway.app
- **API Docs**: https://your-backend-url.railway.app/docs

---

## 📊 Verify Everything Works

1. **Check Backend Health**:
   ```bash
   curl https://your-backend.railway.app/health
   ```

2. **Check API Documentation**:
   Open: `https://your-backend.railway.app/docs`

3. **Check Frontend**:
   Open: `https://your-frontend.vercel.app`

4. **Monitor Scheduler Jobs**:
   - Go to Railway → Logs
   - You should see logs like:
     - `[JOB1] extract_live_match_data – starting` (every 2 min)
     - `[JOB2] update_current_match_day – starting` (hourly)
     - `[JOB3] send_autolock_email – starting` (every 5 min)
     - etc.

---

## 💰 Cost Breakdown

- **GitHub**: Free
- **Vercel**: Free tier (generous limits)
- **Railway**: 
  - $5 free credit/month
  - ~$5-10/month after free credit
  - Always-on service (no sleeping)
- **Database**: Using your existing freehostia.com (free)

**Total**: ~$5-10/month (or free with Railway credits)

---

## 📚 Additional Resources

- [GITHUB_SETUP.md](GITHUB_SETUP.md) - Detailed GitHub setup
- [DEPLOYMENT.md](DEPLOYMENT.md) - Complete deployment guide
- [Readme.md](Readme.md) - Project documentation

---

## 🆘 Need Help?

Common issues and solutions:

### Backend won't start
- Check Railway logs for errors
- Verify all environment variables are set correctly
- Check DATABASE_URL format

### CORS errors in browser
- Make sure `CORS_ORIGINS` in Railway matches your Vercel URL exactly
- Include the protocol: `https://` not just the domain
- Use JSON array format: `["https://url.com"]`

### Frontend can't reach backend
- Check `NEXT_PUBLIC_API_BASE_URL` in Vercel settings
- Verify backend is healthy: `curl https://backend-url/health`
- Check browser console for errors

### Scheduler not running
- Check Railway logs
- Make sure Railway service is not sleeping (it shouldn't on paid plan)
- Verify free credits haven't been exhausted

---

## 🎯 What's Next?

After deployment:
- Set up your database tables (run migrations if any)
- Add match data via admin panel
- Invite users to register
- Monitor Railway logs during live matches
- Set up alerts for errors (Railway + Discord/Slack integration)

Good luck with your score predictor! ⚽🏆
