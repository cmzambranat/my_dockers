FROM cmzambranat/corespatial:4.4.3
LABEL maintainer="Carlos Zambrana-Torrelio <cmzambranat@gmail.com>"

# R configuration, package installation, and cleanup
RUN echo "CFLAGS=-w\nCXXFLAGS=-w\nMAKEFLAGS=-j$(nproc)" > /usr/local/lib/R/etc/Makevars.site \
    && installGithub.r -d s-u/unixtools \
    && install2.r --error --skipinstalled ecmwfr fasterize fs geofacet ggmap ggpattern ggsci \
    ggspatial googleway landscapemetrics leaflet leafpop lulcc mapmisc mapview MetBrewer pdp \
    prioritizr projects randomForestExplainer rangeBuilder rasterVis rcartocolor rgrass rmapshaper \
    rnaturalearth rnaturalearthdata RNCEP scico sfdep spatialRF stars terra tidync tmap waywiser zip \
    flexdashboard highcharter treemap \
    && installGithub.r macroecology/letsR \
    && installGithub.r azvoleff/gfcanalysis \
    && Rscript -e "install.packages('INLA', repos=c(getOption('repos'), INLA = 'https://inla.r-inla-download.org/R/testing'), dep = TRUE, Ncpus = parallel::detectCores())" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages /usr/local/lib/R/etc/Makevars.site

# Update R packages
RUN R -e "update.packages(ask = FALSE)"

# Copy configuration file
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
