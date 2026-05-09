#!/usr/bin/env bash
# Robust resume-able downloader. Reads jobs2.tsv (url\tsubdir\tname).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JOBS="$ROOT/downloads/logs/jobs2.tsv"
OUT="$ROOT/downloads"
LOG="$OUT/logs/run2.log"
mkdir -p "$OUT/pdf" "$OUT/img" "$OUT/thumb" "$OUT/other"
: > "$LOG"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
PARALLEL=6

fetch_one() {
  local url="$1" sub="$2" name="$3"
  local dest="$OUT/$sub/$name"
  if [[ -s "$dest" ]]; then
    echo "skip $sub/$name"
    return 0
  fi
  if curl -sSL --fail --retry 3 --retry-delay 2 --max-time 1800 \
       -H "User-Agent: $UA" \
       -H "Accept: */*" \
       -H "Accept-Language: en-US,en;q=0.9" \
       -H "Referer: https://www.war.gov/UFO/" \
       -H "Sec-Fetch-Dest: document" \
       -H "Sec-Fetch-Mode: navigate" \
       -H "Sec-Fetch-Site: same-origin" \
       -o "$dest.part" "$url"; then
    mv "$dest.part" "$dest"
    echo "ok   $sub/$name"
  else
    rm -f "$dest.part"
    echo "FAIL $url"
  fi
}

export -f fetch_one
export OUT UA

# Use a fifo + worker pool to avoid xargs argv limits
sem=$(mktemp -u)
mkfifo "$sem"
exec 3<>"$sem"
rm "$sem"
for ((i=0; i<PARALLEL; i++)); do echo >&3; done

while IFS=$'\t' read -r url sub name; do
  [[ -z "$url" ]] && continue
  read -u 3
  {
    fetch_one "$url" "$sub" "$name" >> "$LOG" 2>&1
    echo >&3
  } &
done < "$JOBS"
wait

echo "DONE" >> "$LOG"
