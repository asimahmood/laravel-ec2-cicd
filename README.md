# CI/CD Pipeline with GitHub Actions and AWS EC2

This repository contains a complete CI/CD pipeline setup for deploying a Laravel application to AWS EC2 using GitHub Actions.

## Features
- ✅ Zero downtime deployment using symlink switching
- 🔁 Automatic rollback on failure (via shell script control)
- 🔐 Secure SSH deployment using GitHub Secrets
- ⚙️ Composer optimized builds
- 🧪 Laravel migrations + caching in production

## Tools Used
- GitHub Actions
- AWS EC2
- Laravel
- Composer
- SSH

## Architecture
```
GitHub Repo → GitHub Actions → SSH to EC2 → Run deploy.sh → Laravel served from symlink
```

## How It Works
1. On push to `main`, GitHub Actions triggers `deploy.yml`
2. It sets up SSH access using a GitHub Secret (`EC2_SSH_KEY`)
3. SSH runs `deploy.sh` on the EC2 instance:
    - Clones repo into timestamped release dir
    - Installs dependencies
    - Runs migrations and caches config
    - Switches symlink `current/` to new release (zero downtime)
4. Nginx and PHP-FPM are reloaded

## Setting up EC2
1. SSH into your EC2 and install PHP, Composer, and Laravel dependencies
2. Set up directory structure:
```bash
sudo mkdir -p /var/www/laravel-app/releases
sudo mkdir -p /var/www/laravel-app/current
sudo chown -R ec2-user:www-data /var/www/laravel-app
```
3. Add `deploy.sh` to EC2 user's home directory
4. Create `.env` in `/var/www/laravel-app/.env`

## GitHub Secrets Required
- `EC2_HOST` → Your EC2 public DNS or IP
- `EC2_SSH_KEY` → Private key of the EC2 instance's authorized SSH key

## Usage
Push to `main` and GitHub Actions will handle the rest.

## License
MIT
