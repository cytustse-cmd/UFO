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

---

## 后续批次（Release 02–07）

> 以上内容全部属于 **Release 01**，保持原样。后续批次各自放在独立的 `release-0N` 目录里，不与 Release 01 混用。

| 批次 | 官方发布日 | 记录数 | 元数据 | 说明 |
|------|-----------|------:|--------|------|
| 02 | 2026-05-22 | 64 | [`data/release-02/`](data/release-02) | [RELEASE-02](docs/releases/RELEASE-02.md) |
| 03 | 2026-06-12 | 72 | [`data/release-03/`](data/release-03) | [RELEASE-03](docs/releases/RELEASE-03.md) |
| 04 | 2026-07-10 | 40 | [`data/release-04/`](data/release-04) | [RELEASE-04](docs/releases/RELEASE-04.md) |
| 05 | 2026-08-07 | 41 | [`data/release-05/`](data/release-05) | [RELEASE-05](docs/releases/RELEASE-05.md) |
| 06 | 2026-09-18 | 75 | [`data/release-06/`](data/release-06) | [RELEASE-06](docs/releases/RELEASE-06.md) |
| 07 | 2026-10-23 | 28 | [`data/release-07/`](data/release-07) | [RELEASE-07](docs/releases/RELEASE-07.md) |

新增目录结构：

```
data/release-0N/          ← 该批元数据 CSV 与链接清单（urls_pdf / urls_thumb / urls_img / dvids_video_ids）
data/all-releases/        ← 官方合并总表（478 行）的副本，仅供对照
downloads/release-0N/     ← 该批缩略图与图片（img、thumb）
docs/releases/            ← 每批说明与数据来源（PROVENANCE.md）
```

注意事项：

- **本仓库只收录元数据、链接、缩略图和图片**。后续批次的 PDF、视频、音频尚未下载，只记录了官方链接；`.gitignore` 已为 `downloads/release-*/pdf|video|audio` 预留。
- 官方当前的合并总表里，Release 01 为 158 条，而本仓库 `data/uap-csv.csv` 是 5 月 9 日抓取的 161 条，说明官方后来修订过第一批；Release 01 的数据没有改动。
- Release 06 有 1 张缩略图（`DOW-UAP-D148…`）官方链接返回 404，未能下载。
- 元数据总表来自第三方镜像站 pursueufotracker.com（与其公布的 war.gov 文件哈希一致），因为 war.gov 对脚本直接访问返回 403。详见 [`docs/releases/PROVENANCE.md`](docs/releases/PROVENANCE.md)。
- 第 02 批官方还提供了整包压缩包（约 5.26 GiB），见 `data/release-02/cloudfront_uap052226_note.json`，尚未下载。


## PURSUE Releases 02–07: GitHub Release assets

Full files (PDF/video/audio/images/thumbnails) are published as GitHub Release assets, separate from Release 01. Download scripts: `scripts/release-0N/download.sh` (method in `scripts/lib/fetch_release.py`). Files ≥2 GB are split as `NAME.part-00`, `NAME.part-01`…; rejoin with `cat NAME.part-* > NAME`.

| Release | Date | CSV rows | Expected primary files | Downloaded | Local files (incl. thumbs/images) | Assets on GitHub | Total size | Missing |
|---|---|---|---|---|---|---|---|---|
| [release-02](https://github.com/cytustse-cmd/UFO/releases/tag/release-02) | 2026-05-22 | 64 | 64 | 64 | 69 | 69 | 5.32 GiB | 0 |
| [release-03](https://github.com/cytustse-cmd/UFO/releases/tag/release-03) | 2026-06-12 | 72 | 72 | 72 | 145 | 126 | 5.58 GiB | 0 |
| [release-04](https://github.com/cytustse-cmd/UFO/releases/tag/release-04) | 2026-07-10 | 40 | 40 | 40 | 60 | 54 | 4.00 GiB | 0 |
| [release-05](https://github.com/cytustse-cmd/UFO/releases/tag/release-05) | 2026-08-07 | 41 | 41 | 41 | 69 | 63 | 0.64 GiB | 0 |
| [release-06](https://github.com/cytustse-cmd/UFO/releases/tag/release-06) | 2026-09-18 | 75 | 75 | 75 | 133 | 133 | 3.49 GiB | 0 |
| [release-07](https://github.com/cytustse-cmd/UFO/releases/tag/release-07) | 2026-10-23 | 28 | 28 | 28 | 56 | 56 | 0.31 GiB | 0 |
