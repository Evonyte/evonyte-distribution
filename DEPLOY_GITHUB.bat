@echo off
echo ================================================
echo   EVONYTE - GitHub Deployment Script
echo ================================================
echo.

cd /d "%~dp0"

echo [1/4] Authenticating with GitHub...
echo.
gh auth login
if errorlevel 1 (
    echo ERROR: GitHub authentication failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Creating GitHub repository...
gh repo create evonyte-distribution --public --source=. --remote=origin --description="Evonyte Distribution System - Auto-update and file hosting for Evonyte Admin App"
if errorlevel 1 (
    echo ERROR: Failed to create repository!
    pause
    exit /b 1
)

echo.
echo [3/4] Pushing code to GitHub...
git push -u origin master
if errorlevel 1 (
    echo ERROR: Failed to push code!
    pause
    exit /b 1
)

echo.
echo [4/4] Enabling GitHub Pages...
gh repo edit --enable-pages --pages-branch master --pages-path /website
if errorlevel 1 (
    echo Warning: Failed to enable GitHub Pages via CLI
    echo You can enable it manually at: https://github.com/YOUR_USERNAME/evonyte-distribution/settings/pages
)

echo.
echo ================================================
echo   SUCCESS! Repository created and deployed!
echo ================================================
echo.
echo Next steps:
echo 1. Check your repo: gh repo view --web
echo 2. Deploy Edge Functions to Supabase (see DEPLOY_EDGE_FUNCTIONS.txt)
echo 3. Configure DNS for evonyte.com
echo.
pause
