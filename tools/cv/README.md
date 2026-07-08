# CV PDF source

`cv.tex` is the LaTeX source for the downloadable CV linked from `/cv/` (`cv_pdf` in `_pages/cv.md`).
It is a **hand-maintained mirror** of `assets/json/resume.json` — the JSON drives the on-site CV
(`cv_format: jsonresume`); this `.tex` drives the PDF. When you edit `resume.json`, update this file to
match, then regenerate.

## Regenerate the PDF

Requires XeLaTeX (TeX Live / TinyTeX). From this folder:

```bash
xelatex -interaction=nonstopmode -halt-on-error cv.tex
cp cv.pdf ../../assets/pdf/cv.pdf
```

This directory is excluded from the Jekyll build (`tools/` in `_config.yml` `exclude:`), so it is not
published with the site.
