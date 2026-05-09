#!/usr/bin/env bash
# Resolve DVIDS video IDs to CloudFront mp4 URLs and download.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IDS="$ROOT/data/dvids_video_ids.txt"
OUT="$ROOT/downloads/video"
LOG="$ROOT/downloads/logs/video.log"
mkdir -p "$OUT"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"

resolve_and_get() {
  local id="$1"
  local page="https://www.dvidshub.net/video/$id"
  local mp4
  mp4=$(curl -sL -A "$UA" "$page" | grep -oE 'https://[^"]*\.mp4' | head -1)
  if [[ -z "$mp4" ]]; then
    echo "RESOLVE-FAIL $id" >&2
    return 1
  fi
  local name
  name=$(basename "$mp4")
  local dest="$OUT/${id}_${name}"
  if [[ -s "$dest" ]]; then
    echo "skip $dest"
    return 0
  fi
  curl -sSL --fail --retry 3 -A "$UA" -o "$dest.part" "$mp4" \
    && mv "$dest.part" "$dest" \
    && echo "ok $id -> $dest" \
    || { echo "DL-FAIL $id $mp4" >&2; rm -f "$dest.part"; return 1; }
}
export -f resolve_and_get
export UA OUT

xargs -P 4 -I{} bash -c 'resolve_and_get "{}"' < "$IDS" 2>&1 | tee "$LOG"
