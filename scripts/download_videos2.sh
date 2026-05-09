#!/usr/bin/env bash
# DVIDS video downloader, resume-able, no duplicate races.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IDS="$ROOT/data/dvids_video_ids.txt"
OUT="$ROOT/downloads/video"
LOG="$ROOT/downloads/logs/video2.log"
mkdir -p "$OUT"
: > "$LOG"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
PARALLEL=4

resolve_and_get() {
  local id="$1"
  # If we already have any file matching ${id}_*, skip
  if compgen -G "$OUT/${id}_*" > /dev/null; then
    echo "skip $id"
    return 0
  fi
  local mp4
  mp4=$(curl -sL -A "$UA" "https://www.dvidshub.net/video/$id" \
        | grep -oE 'https://[^"]*\.mp4' | head -1)
  if [[ -z "$mp4" ]]; then
    echo "RESOLVE-FAIL $id"
    return 1
  fi
  local name=$(basename "$mp4")
  local dest="$OUT/${id}_${name}"
  if curl -sSL --fail --retry 3 --max-time 1800 -A "$UA" -o "$dest.part" "$mp4"; then
    mv "$dest.part" "$dest"
    echo "ok   $id $name"
  else
    rm -f "$dest.part"
    echo "DL-FAIL $id $mp4"
  fi
}
export -f resolve_and_get
export OUT UA

sem=$(mktemp -u); mkfifo "$sem"; exec 3<>"$sem"; rm "$sem"
for ((i=0; i<PARALLEL; i++)); do echo >&3; done

while read -r id; do
  [[ -z "$id" ]] && continue
  read -u 3
  { resolve_and_get "$id" >> "$LOG" 2>&1; echo >&3; } &
done < "$IDS"
wait

echo "DONE" >> "$LOG"
