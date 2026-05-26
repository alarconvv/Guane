# syntax=docker/dockerfile:1

ARG R_VERSION=4.6.0
FROM rocker/shiny:${R_VERSION}

ENV DEBIAN_FRONTEND=noninteractive \
    RENV_CONFIG_SANDBOX_ENABLED=FALSE \
    RENV_PATHS_LIBRARY=/opt/guane/renv/library \
    APPLICATION_LOGS_TO_STDOUT=true

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libgsl-dev \
    libglpk-dev \
    libxt6 \
    libuv1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/guane

COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

RUN Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv'); renv::restore(prompt = FALSE)"

COPY . .

RUN Rscript -e "renv::restore(prompt = FALSE); renv::install('.', rebuild = TRUE)"

EXPOSE 3838

CMD ["Rscript", "-e", "Sys.setenv(RENV_PROJECT='/opt/guane'); source('/opt/guane/renv/activate.R'); library(guane); guane::run_app(host='0.0.0.0', port=3838)"]