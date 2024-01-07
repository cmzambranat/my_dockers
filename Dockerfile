FROM rocker/geospatial:4.3.2
LABEL maintainer="Carlos Zambrana-Torrelio <cmzambranat@gmail.com>"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    htop \
    hugo \
    libgsl-dev \
    libglpk40 \
    libfftw3-dev \
    openssh-server \
    wget \
    zlib1g-dev \
    xclip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

# R configuration and package installation
RUN echo "CFLAGS=-w\nCXXFLAGS=-w\nMAKEFLAGS=-j$(nproc)" > /usr/local/lib/R/etc/Makevars.site \
  && installGithub.r -d s-u/unixtools \
  && install2.r --error --skipinstalled assertr classInt colorspace countrycode cowplot cshapes DT flextable formattable ggforce ggh4x ggpmisc ggrepel ggtext ggthemes googledrive googlesheets4 gt gtsummary here janitor kableExtra knitcitations lemon officedown officer patchwork pbapply piggyback renv scales styler targets vroom geodata \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
  && R -e "update.packages(ask = FALSE)"

# Copy configuration file
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
