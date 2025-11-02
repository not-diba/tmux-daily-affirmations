#!/usr/bin/env bash

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux-daily-affirmations"
CACHE_FILE="$CACHE_DIR/affirmation.txt"
TODAY=$(date +%Y-%m-%d)

mkdir -p "$CACHE_DIR"

# If cache exists and matches today's date, print it
if [ -f "$CACHE_FILE" ]; then
  cached_date=$(head -n 1 "$CACHE_FILE")
  if [ "$cached_date" = "$TODAY" ]; then
    tail -n +2 "$CACHE_FILE"
    exit 0
  fi
fi

# Otherwise, fetch new affirmation
response=$(curl -s --max-time 5 https://www.affirmations.dev/)
affirmation=$(echo "$response" | jq -r '.affirmation' 2>/dev/null)

# Fallback if jq isn't available
if [ -z "$affirmation" ] || [ "$affirmation" = "null" ]; then
  affirmation=$(echo "$response" | sed -E 's/.*"affirmation":"([^"]+)".*/\1/')
fi

# --- Final fallback if still empty or API unreachable ---
if [ -z "$affirmation" ] || [ "$affirmation" = "null" ]; then
  affirmation="You are awesome"
fi

# Cache today's date + affirmation
{
  echo "$TODAY"
  echo "$affirmation"
} >"$CACHE_FILE"

echo "$affirmation"
