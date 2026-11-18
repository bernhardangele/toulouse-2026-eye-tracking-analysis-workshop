# syntax=docker/dockerfile:1

FROM bangele1/analysis-in-a-box-rocker:4.6.2

ARG TARGETARCH

USER root

# Python packages go in their own venv; libpython3-dev lets reticulate embed the
# venv's Python shared library when rendering workshop.qmd or running workshop_*.R.
RUN apt-get update && apt-get install -y --no-install-recommends libpython3-dev \
    && rm -rf /var/lib/apt/lists/*
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV RETICULATE_PYTHON=/opt/venv/bin/python

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# R packages (most are already in the base image; this fills in anything missing).
COPY install_r_packages.R /tmp/install_r_packages.R
RUN --mount=type=cache,id=pkgcache-${TARGETARCH},target=/root/.cache/R/pkgcache \
    PKG_SYSREQS=false Rscript /tmp/install_r_packages.R

# RStudio sessions don't inherit Docker ENV, so repeat RETICULATE_PYTHON in Renviron.site.
RUN echo "RETICULATE_PYTHON=/opt/venv/bin/python" >> /usr/local/lib/R/etc/Renviron.site

WORKDIR /home/rstudio/project
