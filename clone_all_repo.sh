curl -s "https://api.github.com/users/$username/repos?per_page=100" | jq -r ".[].git_url" | xargs -L1 git clone
