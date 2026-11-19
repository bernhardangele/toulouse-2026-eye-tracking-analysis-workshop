# Analysing eye-tracking experiments

Workshop slides and self-contained analysis scripts for reading and visual-world eye-tracking data using
[pymovements](https://github.com/pymovements/pymovements) (Python, via `reticulate`) for eye-tracker preprocessing and
R (`tidyverse`, `lme4`) for cleaning, plotting, and mixed-effects models.

This workshop is the analysis companion to the
[OpenSesame and PyGaze recording workshop](https://github.com/bernhardangele/eye-movement-experiments-with-opensesame).
It covers the six conceptual analysis steps on simulated example data (`reading`, `boundary`, `movingwindow`, and `vwp`).

- **Slides:** <https://bernhardangele.github.io/toulouse-2026-eye-tracking-analysis-workshop/#/title-slide>
- **Repository:** <https://github.com/bernhardangele/toulouse-2026-eye-tracking-analysis-workshop>

## Files

| Path | Purpose |
|---|---|
| `workshop.qmd` | Quarto reveal.js presentation (renders to self-contained `workshop.html`) |
| `workshop_reading.R`, `workshop_boundary.R`, `workshop_movingwindow.R`, `workshop_vwp.R` | One self-contained R script per experiment (embeds the Python preprocessing step via `reticulate`) |
| `workshop_preprocessing.py`, `workshop_analysis.R` | Shared Python and R scripts whose code sections are displayed in `workshop.qmd` |
| `workshop_animations.py`, `assets/` | Helper module, GSAP animations, and SCSS theme for `workshop.qmd` |
| `data/example_data/` | Simulated OpenSesame `.csv` log files and 1000 Hz EyeLink `.asc` files for all four experiments |
| `Makefile` | Build targets (`make`, `make preview`, `make preprocess`, `make analysis`, `make scripts`, `make clean`) |
| `.devcontainer/`, `Dockerfile`, `requirements.txt`, `install_r_packages.R` | Dev Container setup with Python, `pymovements`, R, and Quarto |
| `.github/workflows/deploy.yml` | GitHub Actions workflow to render and deploy `workshop.qmd` to GitHub Pages |

## Running the analyses

From the repository root (or after opening `workshop.Rproj` in RStudio), run any of the four self-contained scripts:

```bash
Rscript workshop_reading.R
Rscript workshop_boundary.R
Rscript workshop_movingwindow.R
Rscript workshop_vwp.R
```

The first run preprocesses that experiment's `.asc` files into `data/example_data/derived/<experiment>/` and then runs
the R cleaning, plots, and mixed model. You can also open any `workshop_*.R` file in RStudio or VS Code and step through
it line by line.

## Rendering the presentation

```bash
make              # preprocesses all experiments (if needed) and renders workshop.html
make preview      # live preview server for workshop.qmd
make help         # list all Makefile targets
```

## Environment setup

### Option 1: Dev Container (VS Code / GitHub Codespaces)

1. Open this folder in VS Code with the **Dev Containers** extension installed and select **Reopen in Container** (or
   launch a GitHub Codespace).
2. Once built, R, Python (`/opt/venv`), `pymovements`, `tidyverse`, `lme4`, `reticulate`, and Quarto are ready to use.
3. Optional: RStudio Server is also available on forwarded port `8787` (`http://localhost:8787`, user `rstudio`, password
   `workshop` — do not expose port `8787` on an untrusted network).

### Option 2: Local installation (without Docker)

Requires [R](https://cran.r-project.org/), [Python 3](https://www.python.org/), and [Quarto](https://quarto.org/):

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
Rscript install_r_packages.R
make
```

## Deploying slides to GitHub Pages

1. Push this repository to GitHub with `main` as the default branch.
2. In your GitHub repository, open **Settings → Pages** and set **Source** to **GitHub Actions**.
3. Every push to `main` (or manual run from the **Actions** tab) executes
   [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml), renders `workshop.qmd`, and publishes the slides.
