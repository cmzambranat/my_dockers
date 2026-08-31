# syntax=docker/dockerfile:1

FROM rocker/verse:4.6.1

LABEL org.opencontainers.image.authors="Carlos Zambrana-Torrelio <cmzambranat@gmail.com>"

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

ENV CHROMOTE_CHROME=/usr/bin/google-chrome


# ------------------------------------------------------------------------------
# System dependencies
# ------------------------------------------------------------------------------

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        libssl-dev \
        curl \
        libarchive-dev \
        libcairo2-dev \
        libsecret-1-dev \
        htop \
        wget \
    && wget -q \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
        -O /tmp/google-chrome.deb \
    && apt-get install -y --no-install-recommends /tmp/google-chrome.deb \
    && rm -f /tmp/google-chrome.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------------------------
# R configuration
# ------------------------------------------------------------------------------

RUN printf 'MAKEFLAGS=-j%s\n' "$(nproc)" \
        > /usr/local/lib/R/etc/Makevars.site


# ------------------------------------------------------------------------------
# GitHub R packages
# ------------------------------------------------------------------------------

RUN install2.r --error remotes \
    && installGithub.r s-u/unixtools

# ------------------------------------------------------------------------------
# CRAN packages
# ------------------------------------------------------------------------------

RUN install2.r --error --skipinstalled \
        config \
        countrycode \
        docxtractr \
        DT \
        flextable \
        flexdashboard \
        formattable \
        ggh4x \
        ggthemes \
        gt \
        gtsummary \
        here \
        janitor \
        kableExtra \
        lemon \
        linl \
        pagedown \
        patchwork \
        pinp \
        prettydoc \
        printr \
        quarto \
        rmdformats \
        rticles \
        shinyjs \
        tufte \
    && rm -rf \
        /tmp/downloaded_packages \
        /tmp/*.rds \
        /root/tmp/downloaded_packages


# ------------------------------------------------------------------------------
# RStudio configuration
# ------------------------------------------------------------------------------

RUN mkdir -p /home/rstudio/.config/rstudio \
    && chown -R rstudio:rstudio /home/rstudio/.config

COPY --chown=rstudio:rstudio \
    config/rstudio-prefs.json \
    /home/rstudio/.config/rstudio/rstudio-prefs.json
