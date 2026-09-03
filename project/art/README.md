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
4. `quarto render project/art.qmd` (or `quarto preview`) to check it looks
   right, then commit — only the `-thumb`/`-large` files will be staged,
   the original stays local.
