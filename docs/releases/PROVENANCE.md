# Provenance

## Canonical metadata

- Official URL (blocked to plain curl from this box): https://www.war.gov/Portals/1/Interactive/2026/UFO/uap-data.csv
- Former URL (reported 404 by trackers): …/uap-csv.csv
- Mirror used: https://pursueufotracker.com/data/uap-data.csv
- SHA-256: 92b3ec7dd87286ea7092a33b476566b4416d3bb02970b02757b237d8322fe81a
- Rows: 478 (all releases combined as of 2026-10-26 revision per tracker; Release 07 content dated 2026-10-23)
- Captured: 2026-11-05 Asia/Shanghai

## Split rule

Rows grouped by exact `Release Date` string in the CSV:
- 5/8/2026 → release-01 (not written into per-release dirs here)
- 5/22/2026 → release-02
- 6/12/2026 → release-03
- 7/10/2026 → release-04
- 8/7/2026 → release-05
- 9/18/2026 → release-06
- 10/23/2026 → release-07

## Small-file download

- Tool: curl_cffi impersonate=chrome131
- Scope: Modal Image thumbs + Type=IMG main images for release-02..07
- Result: 213 OK, 1 FAIL (404 on one R06 thumb URL as listed in CSV)
- Bytes: ~48 MB

## Not downloaded

- PDFs, videos, audio (URLs recorded only)
- Full CloudFront bundle https://d34w7g4gy10iej.cloudfront.net/uap052226.zip (~5.26 GiB; HTTP 206 Range OK)
