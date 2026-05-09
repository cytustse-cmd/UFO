# war.gov UFO Archive Mirror

Mirror of all materials published at https://www.war.gov/UFO/ (Release 01, May 8 2026) — the U.S. Department of War's Presidential Unsealing and Reporting System for UAP Encounters (PURSUE).

## Contents

| Category | Count | Location |
|----------|-------|----------|
| Declassified PDFs | 116 | GitHub Release `release-01` (assets) |
| Main images (UAP) | 14 | `downloads/img/` |
| Thumbnails | 130 | `downloads/thumb/` |
| DVIDS videos (mp4) | 28 | GitHub Release `release-01` (assets) |
| Metadata CSV | 161 records | `data/uap-csv.csv` |

Total raw archive: ~3.8 GB. PDFs and videos are attached to the GitHub Release because several files exceed GitHub's 100 MB per-file repo limit (largest: 353 MB).

## Reproduce

```bash
bash scripts/download2.sh        # PDFs + thumbnails + main images
bash scripts/download_videos2.sh # DVIDS videos
```

The scripts are idempotent (skip already-downloaded files) and read from `data/uap-csv.csv` and `data/dvids_video_ids.txt`.

## Sources

- Page: https://www.war.gov/UFO/
- Backend CSV: https://www.war.gov/Portals/1/Interactive/2026/UFO/uap-csv.csv
- PDF/image host: https://www.war.gov/medialink/ufo/release_1/
- Videos: DVIDS (https://www.dvidshub.net/video/{id})

Captured 2026-05-09.
