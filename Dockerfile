FROM rocker/verse:4.4.1
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    libssl-dev \
    curl \
    libarchive-dev \
    libcairo2-dev \
    libsecret-1-dev \
    htop \
    wget \
  && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# R configurations
RUN echo "CFLAGS=-w\nCXXFLAGS=-w\nMAKEFLAGS=-j$(nproc)" > /usr/local/lib/R/etc/Makevars.site \
  && installGithub.r -d s-u/unixtools

# Install R packages
RUN install2.r --error --skipinstalled \
  config \
  countrycode \
  DT \
  docxtractr \
  flextable \
  flexdashboard \
  formattable \
  ggthemes \
  ggh4x \
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
  rmdformats \
  rticles \
  shinyjs \
  tufte \
  quarto \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages

# Update R packages
RUN R -e "update.packages(ask = FALSE)"

# Set environment variables
RUN echo CHROMOTE_CHROME=/usr/bin/google-chrome >> /usr/local/lib/R/etc/.Renviron

# Copy configurations
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
