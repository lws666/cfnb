#!/bin/bash
# Rewrite git_sync.sh credentials from env, then loop main.py on an interval.
set -e

if [ -n "$GITHUB_TOKEN" ]; then
  sed -i "s|github_token=\"your_github_personal_access_token_here\"|github_token=\"${GITHUB_TOKEN}\"|" /app/git_sync.sh
fi
if [ -n "$GITHUB_USERNAME" ]; then
  sed -i "s|github_username=\"your_github_username\"|github_username=\"${GITHUB_USERNAME}\"|" /app/git_sync.sh
fi
if [ -n "$GITHUB_REPO" ]; then
  sed -i "s|repo_name=\"your_repo_name\"|repo_name=\"${GITHUB_REPO}\"|" /app/git_sync.sh
fi
sed -i "s|^branch=\"your_branch\"|branch=\"${GITHUB_BRANCH:-main}\"|" /app/git_sync.sh
chmod +x /app/git_sync.sh

# Koyeb health check endpoint
python3 /app/health_server.py &

INTERVAL_MIN=${SCAN_INTERVAL_MIN:-30}
while true; do
  echo "[$(date -u '+%F %T')] starting scan..."
  cd /app && python3 main.py || echo "scan failed, will retry next cycle"
  echo "[$(date -u '+%F %T')] scan done, sleeping ${INTERVAL_MIN}min"
  sleep $((INTERVAL_MIN * 60))
done
