FROM rocker/geospatial:4.3.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-unauthenticated --no-install-recommends --no-upgrade --add-apt-repository ppa:ubuntugis/ubuntugis-unstable\
  curl \
  gdal-bin \
  grass \
  grass-dev \
  grass-doc \
  htop \
  libarchive-dev \
  libcairo2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libsecret-1-dev \
  libudunits2-dev \
  openssh-server \
  proj-data \
  proj-bin \
  python3-gdal \
  unzip \
  wget \
  build-essential \
  flex make bison gcc libgcc1 g++ ccache \
  python3 python3-dev \
  python3-opengl python3-wxgtk4.0 \
  python3-dateutil libgsl-dev python3-numpy \
  wx3.0-headers wx-common libwxgtk3.0-gtk3-dev \
  libwxbase3.0-dev   \
  libncurses5-dev \
  libbz2-dev \
  zlib1g-dev gettext \
  libtiff5-dev libpnglite-dev \
  libcairo2 libcairo2-dev \
  sqlite3 libsqlite3-dev \
  libpq-dev \
  libreadline6-dev libfreetype6-dev \
  libfftw3-3 libfftw3-dev \
  libboost-thread-dev libboost-program-options-dev  libpdal-dev\
  subversion libzstd-dev \
  checkinstall \
  libglu1-mesa-dev libxmu-dev \
  ghostscript wget \
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
