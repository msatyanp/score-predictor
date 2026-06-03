# Football Score Predictor
Predict your score and compare with your friends.

A comprehensive football match prediction platform with real-time score updates, automated email notifications, and leaderboard tracking.

## 🌟 Features

- **Live Match Updates**: Automatic polling of UEFA API every 2 minutes
- **Prediction System**: Submit predictions for match scores, cards, duration, etc.
- **Automated Notifications**: Email reminders and daily match digests
- **Leaderboard**: Track rankings and compete with friends
- **Auto-locking**: Matches lock 60 minutes before kickoff
- **Admin Panel**: Manage matches, teams, and settings

---

## 📋 Requirements
1. NodeJS 20+
2. Python 3.13+
3. MySQL 5.7+

---

## 🛠 Tech Stack

### Backend
- **FastAPI** - Modern Python web framework
- **APScheduler** - Background job scheduler (5 automated tasks)
- **SQLAlchemy** - Async ORM with MySQL
- **Pydantic** - Data validation
- **aiomysql** - Async MySQL driver

### Frontend
- **Next.js 16** - React framework
- **TypeScript** - Type safety
- **TailwindCSS** - Styling

### Database
- **MySQL 5.7+** / MariaDB

---

## 🚀 Quick Start

### Option 1: Local Development (Docker - Recommended)

1. **Clone and Setup**
   ```bash
   git clone <your-repo-url>
   cd score-predictor
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials and settings
   # Note: URL-encode special characters in passwords (# → %23, @ → %40, ! → %21)
   ```

3. **Start Services**
   ```bash
   docker compose up --build -d
   ```

4. **Access Application**
   - Frontend: http://localhost:8026
   - Backend API: http://localhost:8025
   - API Docs: http://localhost:8025/docs

### Option 2: Local Development (Manual)

#### Backend Setup
```bash
python3.13 -m venv .venv
source .venv/bin/activate
cd backend
cp sample.env .env
# Edit .env with your configuration
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8025
```

#### Frontend Setup
```bash
npm install pnpm -g
cd frontend
pnpm install
pnpm run dev
```

---

## 🌐 Production Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

**Recommended Stack:**
- Frontend: Vercel (free tier)
- Backend: Railway ($5/month)
- Database: Railway MySQL or external provider

### Quick Deploy

1. **Push to GitHub** (see instructions below)
2. **Deploy Backend to Railway**
   - Connect GitHub repo
   - Set environment variables
   - Deploy from `backend` folder
3. **Deploy Frontend to Vercel**
   - Import GitHub repo
   - Set `NEXT_PUBLIC_API_BASE_URL`
   - Deploy from `frontend` folder

---

## 📦 Project Structure

```
score-predictor/
├── backend/
│   ├── app/
│   │   ├── api/          # API endpoints
│   │   ├── core/         # Config & security
│   │   ├── db/           # Database setup & schemas
│   │   ├── models/       # SQLAlchemy models
│   │   ├── repositories/ # Data access layer
│   │   ├── schemas/      # Pydantic schemas
│   │   ├── services/     # Business logic
│   │   └── workers/      # APScheduler jobs
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/
│   ├── app/              # Next.js app router
│   ├── components/       # React components
│   └── Dockerfile
├── docker-compose.yml
├── .env.example
└── DEPLOYMENT.md
```

---

## 🤖 Background Jobs

The backend runs 5 automated scheduled tasks:

1. **Live Match Data** (every 2 min) - Fetches scores from UEFA API
2. **Current Match Day** (hourly) - Updates active match day
3. **Auto-lock & Email** (every 5 min) - Locks matches and sends predictions
4. **Reminder Email** (every 30 min) - Reminds users to submit predictions
5. **Daily Digest** (7 AM UTC) - Sends today's match schedule

---

## 🔒 Environment Variables

See `.env.example` for all required variables. Key ones:

```bash
DATABASE_URL=mysql+aiomysql://user:password@host:3306/database
JWT_SECRET=your_secret_key
EMAIL_FROM=your@email.com
EMAIL_PASS=your_app_password
CORS_ORIGINS=["http://localhost:8026"]
NEXT_PUBLIC_API_BASE_URL=http://localhost:8025/api/v1
```

**Important**: URL-encode special characters in DATABASE_URL password:
- `#` → `%23`
- `@` → `%40`
- `!` → `%21`

---

## 📚 API Documentation

Once the backend is running, visit:
- Swagger UI: http://localhost:8025/docs
- ReDoc: http://localhost:8025/redoc

---

## 🐛 Troubleshooting

### Backend container unhealthy
- Check `CORS_ORIGINS` is in JSON array format: `["http://localhost:8026"]`
- Verify DATABASE_URL has special characters URL-encoded
- Check logs: `docker logs sp_backend`

### Database connection failed
- Ensure MySQL is running and accessible
- Verify credentials in DATABASE_URL
- For Docker: use `host.docker.internal` as host (already configured)

### Frontend can't reach backend
- Check `NEXT_PUBLIC_API_BASE_URL` is set correctly
- Verify CORS_ORIGINS includes your frontend URL
- Check backend is running: `curl http://localhost:8025/health`

---

## 📄 License

MIT License - feel free to use for your own tournaments!

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request
