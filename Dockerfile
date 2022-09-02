FROM cmzambranat/corespatial:4.2.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
## R config and packages
RUN ## Compile R packages
  install2.r --error --skipinstalled \
  ecmwfr \
  fasterize \
  fs \
  ggmap \
  ggpattern \
  ggsci \
  ggspatial \
  googleway \
  landscapemetrics \
  leaflet \
  leafpop \
  lulcc \
  mapmisc \
  mapview \
  MetBrewer \
  pdp \
  prioritizr \
  projects \
  randomForestExplainer \
  rangeBuilder \
  rasterVis \
  rcartocolor \
  rgrass \
  rmapshaper \
  rnaturalearth \
  rnaturalearthdata \
  RNCEP \
  scico \
  sfdep \
  spatialRF \
  stars \
  terra \
  tidync \
  tmap \
  waywiser \
  zip \
  && installGithub.r macroecology/letsR \
  && installGithub.r azvoleff/gfcanalysis \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages
RUN echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
  && Rscript -e "install.packages('INLA', repos=c(getOption('repos'), INLA = 'https://inla.r-inla-download.org/R/testing'), dep = TRUE, Ncpus = parallel::detectCores())" \
  && rm /usr/local/lib/R/etc/Makevars.site \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
  && R -e "update.packages(ask = FALSE)"
