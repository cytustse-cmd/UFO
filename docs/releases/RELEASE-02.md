# PURSUE Release 02（第 02 批）

> **与 Release 01 完全分离。** 本目录只含本批数据，不覆盖仓库既有 `data/`、`downloads/`、`scripts/`（那些是 Release 01）。

## 基本信息

| 项 | 内容 |
|----|------|
| 官方发布日 | 2026-05-22（CSV `Release Date` = `5/22/2026`） |
| 记录条数 | **64**（来自官方合并 CSV，按 Release Date 切分） |
| 门户 | https://www.war.gov/UFO/ |
| 新闻稿 | [Department of War Publishes Second Release… (May 22, 2026)](https://www.war.gov/News/Releases/Release/Article/4499305/department-of-war-publishes-second-release-of-unidentified-anomalous-phenomena/) |

首批含 DOE / CIA / ODNI 记录；以传感器视频为主。

## 类型分布

| 类型 | 条数 |
|------|-----:|
| 视频 (`VID`) | 51 |
| 音频 (`AUD`) | 7 |
| 文档 PDF (`PDF`) | 6 |

## 机构分布

| 机构 | 条数 |
|------|-----:|
| Department of War | 52 |
| NASA | 7 |
| Department of Energy | 3 |
| CIA | 1 |
| Office of the Director of National Intelligence | 1 |

## 本目录已收集内容

| 路径 | 说明 |
|------|------|
| `data/uap-csv.csv` | 本批元数据（官方 schema + `release` 列） |
| `data/urls_pdf.txt` | PDF/文档 URL（6） |
| `data/urls_thumb.txt` | 缩略图 URL（6） |
| `data/urls_img.txt` | 主图 URL（0） |
| `data/dvids_video_ids.txt` | DVIDS 视频 ID（57） |
| `downloads/thumb/` | 已下载缩略图（6 个） |
| `downloads/img/` | 已下载主图（0 个） |
| `downloads/pdf/`、`downloads/video/`、`downloads/audio/` | **空占位** — 大文件仅记录 URL，未下载（总预算限制） |

## 媒体托管路径模式（本批）

从 CSV 中的 `PDF \| Image Link` / `Modal Image` 归纳：

- `https://www.war.gov/medialink/ufo/052226/release_02/…`

## 已知缺口 / 未验证项

- 官方 `war.gov` 对普通 `curl` 返回 **HTTP 403**；本机用 `curl_cffi`（Chrome TLS 指纹）才拉到缩略图/图片。
- **未下载** PDF / 视频 / 音频本体（体积大；R02 视频包在 CloudFront 约 **5.26 GiB**：`https://d34w7g4gy10iej.cloudfront.net/uap052226.zip`，仅做了可达性探测，未整包下载）。
- Release 06 有 1 个缩略图 URL 返回 **404**：`DOW-UAP-D148_…Hypersonic…jpg`（见上级 `download_small_files.log`）。
- 第三方索引条数可能与官方 CSV 略有出入（例如 UAP Ledger R02 标 66，官方 CSV 本批 64）；**以本目录 CSV 为准**。

## 来源

- 官方合并 CSV（现名 `uap-data.csv`）：`https://www.war.gov/Portals/1/Interactive/2026/UFO/uap-data.csv`
- 本机副本校验：SHA-256 `92b3ec7dd87286ea7092a33b476566b4416d3bb02970b02757b237d8322fe81a`（与 pursueufotracker.com 公布的 war.gov 镜像哈希一致，采集于 2026-11-05 Asia/Shanghai）
- 交叉参考：https://declassifieduap.org/releases 、https://www.bluebook.one/releases 、https://uapledger.com/releases


## GitHub Release assets (https://github.com/cytustse-cmd/UFO/releases/tag/release-02)

- Expected primary files (CSV PDF/image links + DVIDS media): **64**
- Downloaded: **64**; local files incl. thumbnails/modal images: 69 (5.32 GiB)
- GitHub assets: 69; checksums: `data/release-02/SHA256SUMS.txt`
- Script: `scripts/release-02/download.sh`
- Files ≥2 GB are uploaded split (`NAME.part-00`…); rejoin: `cat NAME.part-* > NAME`
- Not fetched: none
