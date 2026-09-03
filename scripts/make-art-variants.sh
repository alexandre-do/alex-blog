#!/bin/bash
# Generate optimized -thumb (grid) and -large (lightbox) JPEG variants for
# every photo in project/art/paintings and project/art/drawings.
#
# Usage:
#   ./scripts/make-art-variants.sh                # process both folders
#   ./scripts/make-art-variants.sh project/art/paintings   # process one folder
#
# Run this after dropping a new artwork photo into project/art/paintings/
# or project/art/drawings/, then reference the -thumb/-large files from
# project/art.qmd. The plain original stays local (git-ignored) — only the
# derived files are meant to be committed.
set -euo pipefail

THUMB_MAX=640
LARGE_MAX=1800
THUMB_QUALITY=70
LARGE_QUALITY=82

process_dir() {
  local dir="$1"
  for f in "$dir"/*.jpg "$dir"/*.JPG; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    name="${base%.*}"

    # skip already-generated variants
    case "$name" in
      *-thumb|*-large) continue ;;
    esac

    thumb_out="$dir/${name}-thumb.jpg"
    large_out="$dir/${name}-large.jpg"

    if [ -e "$thumb_out" ] && [ -e "$large_out" ] && [ "$thumb_out" -nt "$f" ] && [ "$large_out" -nt "$f" ]; then
      echo "skip (up to date): $base"
      continue
    fi

    orig_w=$(sips -g pixelWidth "$f" | tail -1 | awk '{print $2}')
    orig_h=$(sips -g pixelHeight "$f" | tail -1 | awk '{print $2}')
    long_edge=$(( orig_w > orig_h ? orig_w : orig_h ))

    thumb_target=$(( long_edge < THUMB_MAX ? long_edge : THUMB_MAX ))
    large_target=$(( long_edge < LARGE_MAX ? long_edge : LARGE_MAX ))

    # -s format jpeg forces real JPEG output even when a photo is HEIC
    # data saved under a .jpg/.JPG extension (common with iPhone exports).
    sips -s format jpeg -Z "$thumb_target" --setProperty formatOptions "$THUMB_QUALITY" "$f" --out "$thumb_out" >/dev/null
    sips -s format jpeg -Z "$large_target" --setProperty formatOptions "$LARGE_QUALITY" "$f" --out "$large_out" >/dev/null

    printf "%s -> thumb(%s) large(%s)\n" "$base" "$(du -h "$thumb_out" | cut -f1)" "$(du -h "$large_out" | cut -f1)"
  done
}

if [ "$#" -ge 1 ]; then
  for d in "$@"; do
    process_dir "$d"
  done
else
  process_dir "project/art/paintings"
  process_dir "project/art/drawings"
fi
