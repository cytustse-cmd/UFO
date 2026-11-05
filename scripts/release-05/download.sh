#!/usr/bin/env bash
# Idempotent; requires: pip install curl_cffi. See scripts/lib/fetch_release.py for method.
set -eu
cd "$(dirname "$0")/../.."
python3 scripts/lib/fetch_release.py 5
