FROM cmzambranat/corespatial:4.3.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
## Core spatial
## R config and packages
## Compile R packages
RUN echo "CFLAGS=-w" >> /usr/local/lib/R/etc/Makevars.site \
    &&  echo "CXXFLAGS=-w"  >> /usr/local/lib/R/etc/Makevars.site \
    &&  echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
## install from github
    && installGithub.r -d s-u/unixtools \
## Compile R packages
    && install2.r --error --skipinstalled \
    ecmwfr \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages
RUN echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
    && rm /usr/local/lib/R/etc/Makevars.site \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
    && R -e "update.packages(ask = FALSE)" \
    COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
