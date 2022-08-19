FROM rocker/geospatial:4.2.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-unauthenticated --no-install-recommends --no-upgrade \
    openssh-server \
    python3.8 \
    python3.8-dev \
    curl \
    libarchive-dev \
    libcairo2-dev \
    libgdal-dev \
    libproj-dev \
    libgeos++-dev \
    libsecret-1-dev \
    libudunits2-dev \
    grass \
    grass-dev \
    grass-doc \
    htop \
    wget \
  && RSTUDIO_URL="https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.1-554-amd64.deb" \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/
## R config and packages
RUN echo "CFLAGS=-w" >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "CXXFLAGS=-w"  >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
## install from github 
  && installGithub.r -d s-u/unixtools \
  #&& installGithub.r PredictiveEcology/Require \
  #&& installGithub.r PredictiveEcology/reproducible \
## Compile R packages
  && install2.r --error --skipinstalled \
  assertr \
  adehabitatHR \
  classInt \
  colorspace \
  cowplot \
  cshapes \
  countrycode \
  epimdr \
  ecmwfr \
  #fastshp \
  fasterize \
  fs \
  here \
  #gdalUtils \
  ggrepel \
  ggforce \
  ggmap \
  ggpattern \
  ggpmisc \
  ggspatial \
  ggthemes \
  ggtext \
  ggsci \
  googledrive \
  googleway \
  gtsummary \
  janitor \
  knitcitations \
  landscapemetrics \
  lemon \
  leaflet \
  leafpop \
 #libwgeom \
  lulcc \
  mapmisc \
  mapview \
  mapboxapi \
  MetBrewer \
  mobr \
  #mobsim \
  #NetLogoR \
  patchwork \
  pbapply \
  piggyback \
  prioritizr \
  projects \
  rangeBuilder \
  rasterVis \
  rcartocolor \
  rmapshaper \
  RNCEP \
  rgrass \
  rnaturalearth \
  rnaturalearthdata \
  red \
  renv \
  ROI \
  scico \
  stars \
  styler \
  targets \
  taxadb \
  taxize \
  terra \
  tidync \
  tmap \
  vroom \
  zip \
  && installGithub.r macroecology/letsR \
  && installGithub.r azvoleff/gfcanalysis \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages
RUN echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
  && Rscript -e "install.packages('INLA', repos=c(getOption('repos'), INLA = 'https://inla.r-inla-download.org/R/testing'), dep = TRUE, Ncpus = parallel::detectCores())" \
  && rm /usr/local/lib/R/etc/Makevars.site \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
  && R -e "update.packages(ask = FALSE)" 
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
