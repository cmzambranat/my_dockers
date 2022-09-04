FROM cmzambranat/corespatial:4.2.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
## R config and packages
## Compile R packages
RUN install2.r --error --skipinstalled --ncpus -1 \
    ecmwfr \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so
