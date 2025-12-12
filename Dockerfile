FROM rocker/verse:4.5.2
## rocker verse tags here: https://github.com/rocker-org/rocker-versioned2/wiki
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
# hope it works
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
  && RSTUDIO_URL="https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.0-548-amd64.deb" \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -p git -p ssh-agent -p 'history-substring-search' \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'
### R config and packages
RUN echo "CFLAGS=-w" >> /usr/local/lib/R/etc/Makevars.site \
  && echo "CXXFLAGS=-w"  >> /usr/local/lib/R/etc/Makevars.site \
  && echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
## Compile R packages
  && install2.r --error --skipinstalled \
  ape \
  config \
  countrycode \
  DT \
  docxtractr \
  ggh4x \
  ggthemes \
  gt \
  here \  
  janitor \
  lemon \
  mindr \
  patchwork \
  printr \
  rentrez \
  shinyjs \
  traits \
## install bioconductor packages
  && Rscript -e 'requireNamespace("BiocManager"); BiocManager::install();' \
  && Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("annotate")' \
  && Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("Biostrings")' \
  && Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("genbankr")' \
## install from github 
  && installGithub.r -d s-u/unixtools \
  && installGithub.r mhahsler/rBLAST \
  && R -e "update.packages(ask = FALSE); tinytex::install_tinytex(force = TRUE)" \
  && rm /usr/local/lib/R/etc/Makevars.site \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
