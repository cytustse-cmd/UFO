#!/usr/bin/env python3
"""Idempotent downloader for one PURSUE release.
Usage: fetch_release.py N   (reads data/release-0N/uap-csv.csv)
Method: war.gov blocks plain curl (403), so documents/images are fetched with
curl_cffi (Chrome TLS impersonation). DVIDS pages (video & audio rows) are
fetched the same way and the first CloudFront .mp4/.mp3 URL is extracted, then
downloaded with plain curl (resumable, -C -). Output: downloads/release-0N/{pdf,image,video,audio}/
"""
import csv, os, re, subprocess, sys, time
from curl_cffi import requests as R
n = sys.argv[1]; root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
out = f"{root}/downloads/release-0{n}"; rows = list(csv.DictReader(open(f"{root}/data/release-0{n}/uap-csv.csv")))
def get(url, dest):
    if os.path.exists(dest) and os.path.getsize(dest) > 0: return "skip"
    for a in range(4):
        try:
            x = R.get(url, impersonate="chrome", timeout=600)
            if x.status_code == 200 and x.content:
                open(dest + ".part", "wb").write(x.content); os.rename(dest + ".part", dest); return "ok"
            err = x.status_code
        except Exception as e: err = e
        time.sleep(5 * (a + 1))
    return f"FAIL {err}"
def curl(url, dest):
    if os.path.exists(dest): return "skip"
    for a in range(10):
        if subprocess.call(["curl", "-sSL", "--fail", "-C", "-", "--retry", "3", "--speed-limit", "10000", "--speed-time", "60", "-o", dest + ".part", url]) == 0:
            os.rename(dest + ".part", dest); return "ok"
        time.sleep(10)
    return "FAIL curl"
for r in rows:
    t = r["Type"].strip(); link = r["PDF | Image Link"].strip(); vid = r["DVIDS Video ID"].strip()
    if link:
        sub = "pdf" if link.lower().endswith(".pdf") else "image"
        os.makedirs(f"{out}/{sub}", exist_ok=True)
        print(sub, get(link, f"{out}/{sub}/{os.path.basename(link)}"), link, flush=True)
    if vid:
        sub = "audio" if t == "AUD" else "video"; os.makedirs(f"{out}/{sub}", exist_ok=True)
        if any(f.startswith(vid + "_") and not f.endswith(".part") for f in os.listdir(f"{out}/{sub}")):
            print(sub, "skip", vid); continue
        media = None
        for a in range(4):
            try:
                h = R.get(f"https://www.dvidshub.net/{'audio' if t=='AUD' else 'video'}/{vid}", impersonate="chrome", timeout=60).text
                m = re.findall(r'https://[^"\'\s]*\.(?:mp4|mp3|m4a|wav)', h)
                if not m and t == "AUD":
                    h = R.get(f"https://www.dvidshub.net/video/{vid}", impersonate="chrome", timeout=60).text
                    m = re.findall(r'https://[^"\'\s]*\.(?:mp4|mp3|m4a|wav)', h)
                if m: media = m[0]; break
            except Exception: pass
            time.sleep(5)
        if not media: print(sub, "RESOLVE-FAIL", vid, flush=True); continue
        print(sub, curl(media, f"{out}/{sub}/{vid}_{os.path.basename(media)}"), vid, media, flush=True)
print("DONE")
