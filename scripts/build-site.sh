#!/bin/bash
# Render the full Quarto site and sync the output into the repo root,
# which is what GitHub Pages actually serves from on the gh-pages branch.
#
# IMPORTANT: this repo's deploy convention is to commit the rendered
# HTML/CSS/JS at the repo root (not just in the gitignored _site/ build
# dir). Do NOT rely on `quarto render` (whole project) or
# `quarto render project/<file>.qmd` (single file) alone:
#   - a single-file render regenerates that page in Quarto's "standalone"
#     mode, which drops the site navbar and gives the page its own
#     private *_files/ asset copy instead of the shared site_libs/
#   - a bare `quarto render` has been observed to delete the previously
#     synced root-level copies (index.html, about.html, site_libs/, ...)
#     as a side effect of Quarto's project clean/freshness tracking
# Always use this script when you want the on-disk site — and therefore
# what `git add`/commit picks up — to be correct.
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf _site
quarto render
rsync -a _site/ ./
rm -rf _site

echo "Site rendered and synced to repo root."
