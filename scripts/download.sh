#!/usr/bin/env bash
# Download all war.gov UFO assets listed in data/uap-csv.csv
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA="$ROOT/data"
OUT="$ROOT/downloads"
mkdir -p "$OUT/pdf" "$OUT/img" "$OUT/thumb" "$OUT/video" "$OUT/logs"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"

fetch() {
  local url="$1" dest="$2"
  if [[ -s "$dest" ]]; then
    echo "skip $dest"
    return 0
  fi
  curl -sSL --fail --retry 3 --retry-delay 2 \
    -H "User-Agent: $UA" \
    -H "Accept: */*" \
    -H "Accept-Language: en-US,en;q=0.9" \
    -H "Referer: https://www.war.gov/UFO/" \
    -H "Sec-Fetch-Dest: document" \
    -H "Sec-Fetch-Mode: navigate" \
    -H "Sec-Fetch-Site: same-origin" \
    -o "$dest.part" "$url" \
  && mv "$dest.part" "$dest" \
  && echo "ok  $dest" \
  || { echo "FAIL $url" >&2; rm -f "$dest.part"; return 1; }
}
export -f fetch
export UA

download_list() {
  local list="$1" subdir="$2"
  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    name="$(basename "${url%%\?*}")"
    dest="$OUT/$subdir/$name"
    echo "$url|$dest"
  done < "$list"
}

# Build job list
JOBS="$OUT/logs/jobs.txt"
: > "$JOBS"
download_list "$DATA/urls_pdf.txt"   pdf   >> "$JOBS"
download_list "$DATA/urls_thumb.txt" thumb >> "$JOBS"

echo "Total jobs: $(wc -l < "$JOBS")"

# Run with parallelism 6
xargs -P 6 -I{} bash -c '
  IFS="|" read -r url dest <<< "{}"
  fetch "$url" "$dest"
' < "$JOBS" 2>&1 | tee "$OUT/logs/run.log"
