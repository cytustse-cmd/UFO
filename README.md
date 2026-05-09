# war.gov UFO Archive Mirror

Complete mirror of the U.S. Department of War's first public UAP file release (Release 01, May 8 2026), captured from <https://www.war.gov/UFO/>.

This is the inaugural drop of the **Presidential Unsealing and Reporting System for UAP Encounters (PURSUE)** — an interagency declassification effort coordinated by DOW, ODNI, AARO, FBI, NASA, DOE, and DOS, ordered by President Trump for "total transparency" on Unidentified Anomalous Phenomena.

> All cases archived here are **unresolved** — the government was unable to make a definitive determination on the nature of the observed phenomena. Some materials have not yet been analyzed for resolution of any anomalies.

## What's inside

| Category | Count | Where |
|----------|------:|-------|
| Declassified PDFs | 119 | [Release `release-01`](https://github.com/cytustse-cmd/UFO/releases/tag/release-01) |
| DVIDS videos (mp4) | 28 | [Release `release-01`](https://github.com/cytustse-cmd/UFO/releases/tag/release-01) |
| Main images (UAP imagery) | 14 | [`downloads/img/`](downloads/img) |
| Thumbnails | 130 | [`downloads/thumb/`](downloads/thumb) |
| Metadata index (CSV) | 161 records | [`data/uap-csv.csv`](data/uap-csv.csv) |

Total raw archive size: **~3.7 GB**. PDFs and videos live on the GitHub Release because several files exceed GitHub's 100 MB per-file repo limit (largest single PDF: 353 MB).

### Source agencies

| Agency | Records |
|--------|--------:|
| Department of War (DOW) | 82 |
| FBI | 57 |
| NASA | 15 |
| Department of State (DOS) | 7 |

### Top incident locations

Western United States · Arabian Gulf · Syria · Iraq · Moon (Apollo missions) · Mediterranean · Greece · UAE · Low Earth Orbit · East China Sea

### Date range

Incidents documented from **1946 to 2025**, including:
- FBI 62-HQ-83894 case file (1947–1968) — UFO/flying-disc investigations, Oak Ridge photographs, propulsion proposals
- Apollo 11/12/17 & Skylab transcripts and onboard imagery (1969–1973)
- Recent unresolved military mission reports across CENTCOM/INDOPACOM AORs (2020–2025)

## Repository layout

```
data/
  uap-csv.csv             ← canonical metadata for all 161 entries
  urls_pdf.txt            ← extracted PDF/Image download URLs
  urls_thumb.txt          ← extracted thumbnail URLs
  dvids_video_ids.txt     ← DVIDS video IDs (deduped)
downloads/
  img/                    ← 14 main JPG/PNG images (committed)
  thumb/                  ← 130 thumbnails (committed)
  pdf/                    ← 119 declassified PDFs (gitignored — see Release)
  video/                  ← 28 DVIDS mp4 (gitignored — see Release)
  logs/                   ← download/upload logs
scripts/
  download2.sh            ← idempotent PDF + image + thumbnail downloader
  download_videos2.sh     ← DVIDS video resolver + downloader
  upload_release.sh       ← one-by-one Release asset uploader (resilient)
```

## Reproduce from scratch

```bash
# 1. Re-download everything (idempotent, skips files already present)
bash scripts/download2.sh           # ~3 GB of PDFs + images
bash scripts/download_videos2.sh    # ~1.3 GB of DVIDS videos

# 2. (Optional) re-upload to your own GitHub Release
bash scripts/upload_release.sh
```

The `download*` scripts read directly from `data/uap-csv.csv` (the same CSV the war.gov frontend uses) and `data/dvids_video_ids.txt`. They URL-encode paths, dedupe, retry on failure, and resume.

## Sources

- Landing page: <https://www.war.gov/UFO/>
- Backend metadata CSV: <https://www.war.gov/Portals/1/Interactive/2026/UFO/uap-csv.csv>
- PDF/image host: `https://www.war.gov/medialink/ufo/release_1/`
- Video host: DVIDS — `https://www.dvidshub.net/video/{id}` → CloudFront mp4
- Press release: [DOW announcement, May 8 2026](https://www.war.gov/News/Releases/Release/Article/4480582/department-of-war-releases-unidentified-anomalous-phenomena-files-in-historic-t/)

## Notes

- **Captured**: 2026-05-09
- **Verbatim mirror** — files are bit-identical to the originals served by war.gov / DVIDS at capture time.
- DOW will release additional tranches every few weeks; this repo covers Release 01 only. Future releases will be added as `release-02`, `release-03`, …
- All materials are U.S. government works in the public domain.
