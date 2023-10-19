FROM rocker/geospatial:4.3.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-unauthenticated --no-install-recommends --no-upgrade \
    curl \
    gnupg \
    htop \
    hugo \
    libgsl-dbg \
    libgsl-dev \
    libglpk40 \ 
    libfftw3-dev \
    openssh-server \
    wget \
    zlib1g-dev \
    xclip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/
## R config and packages
RUN echo "CFLAGS=-w" >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "CXXFLAGS=-w"  >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
## install from github 
  && installGithub.r -d s-u/unixtools \
## Compile R packages
  && install2.r --error --skipinstalled \
  assertr \
  classInt \
  colorspace \
  countrycode \
  cowplot \
  cshapes \
  DT \
  flextable \
  formattable \
  ggforce \
  ggh4x \
  ggpmisc \
  ggrepel \
  ggtext \
  ggthemes \
  googledrive \
  googlesheets4 \
  gt \
  gtsummary \
  here \
  janitor \
  kableExtra \
  knitcitations \
  lemon \
  officedown \
  officer \
  patchwork \
  pbapply \
  piggyback \
  renv \
  scales \
  styler \
  targets \
  vroom \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
  && R -e "update.packages(ask = FALSE)" 
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
