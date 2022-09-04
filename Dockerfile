FROM cmzambranat/corespatial:4.2.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
## R config and packages
## Compile R packages
RUN install2.r --error --skipinstalled --ncpus -1 \
    ecmwfr \
    fasterize \
    fs \
    geofacet \
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
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so
