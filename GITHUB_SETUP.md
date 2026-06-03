# GitHub Setup Guide

Follow these steps to push this project to your own GitHub account.

---

## Step 1: Create a New Repository on GitHub

1. Go to https://github.com/new
2. Fill in the details:
   - **Repository name**: `score-predictor` (or your preferred name)
   - **Description**: "Football match prediction platform with live updates and automated notifications"
   - **Visibility**: Choose Public or Private
   - **DO NOT** check "Initialize with README" (you already have one)
   - **DO NOT** add .gitignore or license (you already have them)
3. Click "Create repository"

---

## Step 2: Verify Your Git Configuration

Open terminal in the project directory and run:

```bash
# Check your Git username
git config user.name

# Check your Git email
git config user.email

# If not set, configure them:
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Step 3: Prepare Your Local Repository

The old remote has already been removed. Now let's check what files will be committed:

```bash
# Check Git status
git status

# View what will be committed
git diff --cached
```

---

## Step 4: Make Sure .env is Not Tracked

**IMPORTANT**: Never commit your `.env` file with real credentials!

```bash
# If .env is shown in git status, remove it from tracking:
git rm --cached .env

# Verify .env is in .gitignore:
cat .gitignore | grep .env
```

---

## Step 5: Commit Your Changes

```bash
# Add all files
git add .

# Create a commit
git commit -m "Initial commit: Football score predictor with FastAPI and Next.js"
```

---

## Step 6: Link Your GitHub Repository

Replace `YOUR_USERNAME` with your actual GitHub username:

```bash
git remote add origin https://github.com/YOUR_USERNAME/score-predictor.git

# Verify the remote was added
git remote -v
```

---

## Step 7: Push to GitHub

```bash
# Push to main branch
git push -u origin main

# If your default branch is 'master', use:
# git push -u origin master
```

If you get authentication errors, you may need to:

### Option A: Use Personal Access Token (Recommended)

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a name: "Score Predictor Deploy"
4. Select scopes: `repo` (full control)
5. Generate and copy the token
6. When pushing, use token as password:
   ```bash
   Username: your_github_username
   Password: paste_your_token_here
   ```

### Option B: Use SSH (Alternative)

1. Generate SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```
2. Add to SSH agent:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```
3. Copy public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
4. Add to GitHub → Settings → SSH and GPG keys → New SSH key
5. Change remote to SSH:
   ```bash
   git remote set-url origin git@github.com:YOUR_USERNAME/score-predictor.git
   ```

---

## Step 8: Verify on GitHub

1. Go to your repository: `https://github.com/YOUR_USERNAME/score-predictor`
2. You should see all files except `.env`
3. Check that `.env.example` is there (template for others)

---

## Step 9: Make Future Updates

After making changes to your code:

```bash
# Check what changed
git status

# Add changes
git add .

# Commit with a message
git commit -m "Description of what you changed"

# Push to GitHub
git push
```

---

## Common Issues & Solutions

### "Permission denied"
- Use a Personal Access Token instead of password
- Or set up SSH authentication

### "fatal: not a git repository"
- Make sure you're in the project directory
- Run: `git init` if needed

### ".env file is being committed"
- Run: `git rm --cached .env`
- Verify `.env` is in `.gitignore`
- Commit and push again

### "remote origin already exists"
- Remove old remote: `git remote remove origin`
- Add your remote: `git remote add origin https://github.com/YOUR_USERNAME/score-predictor.git`

---

## Next Steps

After pushing to GitHub:
1. ✅ Your code is safely backed up
2. 🚀 Ready to deploy to Railway (see [DEPLOYMENT.md](DEPLOYMENT.md))
3. 🔄 Railway can auto-deploy on every push
4. 📝 Collaborate with others by sharing the repo

---

## Security Checklist

Before pushing, make sure:
- [ ] `.env` is in `.gitignore`
- [ ] `.env` is NOT shown in `git status`
- [ ] `.env.example` has dummy values only
- [ ] Database passwords are not in any committed files
- [ ] JWT secrets are not hardcoded
- [ ] Email passwords are not exposed

✅ You're good to go!
