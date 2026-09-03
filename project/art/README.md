# Adding artwork to the gallery

The Artwork page (`project/art.qmd`) shows two galleries — **Oil Paintings**
(`project/art/paintings/`) and **Watercolor** (`project/art/drawings/`).

Each photo needs two derived files, which are what the page actually loads:

- `<name>-thumb.jpg` — small (≤640px), used in the gallery grid
- `<name>-large.jpg` — bigger (≤1800px), used for the click-to-zoom lightbox

The plain original (`<name>.jpg`) is git-ignored — it stays on your machine
only, as the source to regenerate from if you ever want different sizes.

## Steps to add a new piece

1. Drop the photo into `project/art/paintings/` or `project/art/drawings/`,
   named like the existing files (e.g. `paint_7.jpg`, `water_7.JPG`).
2. Generate its `-thumb`/`-large` variants:

   ```sh
   ./scripts/make-art-variants.sh
   ```

   (Re-running is safe — it skips any photo whose variants are already up
   to date.)
3. Add a `<figure>` block for it in `project/art.qmd`, following the pattern
   already used for the other images in that section (same `data-gallery`
   value so it joins that section's lightbox group).
4. Rebuild the site with `./scripts/build-site.sh`, then commit — only the
   `-thumb`/`-large` files and the regenerated pages will be staged, the
   original photo stays local.

   **Do not run `quarto render project/art.qmd` (or any single
   `.qmd` file) to check your work.** This repo commits the rendered
   HTML/CSS/JS at the repo root — that's what GitHub Pages actually
   serves. Rendering a single file regenerates it in Quarto's
   "standalone" mode, which silently drops the site navbar and gives the
   page its own private `*_files/` asset copy instead of the shared
   `site_libs/`. A bare `quarto render` (whole project) has also been
   observed to delete the root-level copies as a side effect of Quarto's
   project clean/freshness tracking. `./scripts/build-site.sh` renders
   the whole project into `_site/` and syncs it back to the root
   correctly — always use it instead of calling `quarto` directly. For
   a quick look while editing, `quarto preview` is safe (it doesn't
   write to the repo root).
