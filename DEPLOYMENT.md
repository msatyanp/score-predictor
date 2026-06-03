# Deployment Guide

## Architecture

- **Frontend**: Next.js → Vercel
- **Backend**: FastAPI + APScheduler → Railway
- **Database**: MySQL (external or Railway)

---

## 1. Deploy Backend to Railway

### Prerequisites
- GitHub account
- Railway account (sign up at https://railway.app)

### Steps

1. **Push code to GitHub** (see main README)

2. **Create new Railway project**
   - Go to https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - Select the `backend` folder as root directory

3. **Configure Environment Variables**
   
   Go to your Railway project → Variables, and add:

   ```
   DATABASE_URL=mysql+aiomysql://username:password@host:3306/database
   JWT_SECRET=your_long_random_secret
   JWT_ALGORITHM=HS256
   JWT_ACCESS_EXPIRE_MINUTES=30
   JWT_REFRESH_EXPIRE_MINUTES=10080
   EMAIL_FROM=your@email.com
   EMAIL_PASS=your_app_password
   EMAIL_SMTP=smtp.gmail.com
   EMAIL_PORT=587
   SITE_URL=https://your-frontend.vercel.app
   API_BASE_PATH=/api/v1
   CORS_ORIGINS=["https://your-frontend.vercel.app","http://localhost:8026"]
   PORT=8025
   ```

   **Important**: 
   - URL-encode special characters in password (# → %23, @ → %40, ! → %21)
   - Update SITE_URL after deploying frontend
   - Update CORS_ORIGINS after deploying frontend

4. **Deploy**
   - Railway will automatically detect Dockerfile
   - Click "Deploy"
   - Wait for build to complete
   - Copy your Railway URL (e.g., `https://your-app.railway.app`)

5. **Verify Deployment**
   ```bash
   curl https://your-app.railway.app/health
   # Should return: {"status":"healthy"}
   ```

---

## 2. Deploy Frontend to Vercel

### Steps

1. **Go to Vercel Dashboard**
   - Visit https://vercel.com
   - Click "Add New" → "Project"
   - Import your GitHub repository

2. **Configure Build Settings**
   - Framework Preset: Next.js
   - Root Directory: `frontend`
   - Build Command: `npm run build` (default)
   - Output Directory: `.next` (default)

3. **Environment Variables**
   
   Add in Vercel project settings:

   ```
   NEXT_PUBLIC_API_BASE_URL=https://your-backend.railway.app/api/v1
   ```

4. **Deploy**
   - Click "Deploy"
   - Wait for build to complete
   - Copy your Vercel URL (e.g., `https://your-app.vercel.app`)

5. **Update Backend CORS**
   - Go back to Railway
   - Update `CORS_ORIGINS` environment variable:
     ```
     CORS_ORIGINS=["https://your-app.vercel.app"]
     ```
   - Update `SITE_URL`:
     ```
     SITE_URL=https://your-app.vercel.app
     ```
   - Railway will automatically redeploy

---

## 3. Database Setup

### Option A: Use Existing MySQL (freehostia.com)
- Already configured in your `.env`
- Just copy `DATABASE_URL` to Railway environment variables
- Make sure to URL-encode the password

### Option B: Add MySQL to Railway
1. In Railway project, click "New" → "Database" → "Add MySQL"
2. Railway will create `DATABASE_URL` automatically
3. No need to manually configure

---

## 4. Verify Everything Works

1. **Check Backend Health**
   ```bash
   curl https://your-backend.railway.app/health
   ```

2. **Check API Documentation**
   ```
   https://your-backend.railway.app/docs
   ```

3. **Open Frontend**
   ```
   https://your-frontend.vercel.app
   ```

4. **Check Railway Logs**
   - Go to Railway dashboard
   - Click on your service
   - View "Logs" tab
   - Verify scheduler jobs are running (you should see logs every 2-5 minutes)

---

## Monitoring

### Railway Logs
View real-time logs to monitor:
- Scheduled jobs (every 2 min, 5 min, 30 min, etc.)
- API requests
- Database connections
- Email sending

### Important Scheduler Jobs
- `[JOB1]` - Live match data extraction (every 2 min)
- `[JOB2]` - Update current match day (every hour)
- `[JOB3]` - Auto-lock & send emails (every 5 min)
- `[JOB4]` - Reminder emails (every 30 min)
- `[JOB5]` - Daily matches digest (daily at 7 AM UTC)

---

## Costs

- **Vercel**: Free tier (enough for this project)
- **Railway**: $5 free credit/month (~500 hours)
  - Approximately $5-10/month after free credit
- **Database**: Free on freehostia.com or ~$5/month on Railway

---

## Troubleshooting

### Backend won't start
- Check Railway logs for errors
- Verify all environment variables are set
- Check DATABASE_URL format and encoding

### CORS errors
- Update `CORS_ORIGINS` in Railway with your Vercel frontend URL
- Use JSON array format: `["https://url1.com","https://url2.com"]`

### Scheduler not running
- Check Railway logs for `[JOB1]`, `[JOB2]` etc.
- Verify Railway service is always-on (not sleeping)
- Check if free credits are exhausted

### Database connection fails
- Verify DATABASE_URL has correct host, username, password, database name
- Check special characters are URL-encoded
- Test connection from Railway logs
