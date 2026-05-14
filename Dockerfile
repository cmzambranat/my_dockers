FROM rocker/verse:4.6.0
## rocker verse tags: https://github.com/rocker-org/rocker-versioned2/wiki
LABEL maintainer="Carlos Zambrana-Torrelio <cmzambranat@gmail.com>"
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
    libudunits2-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libgdal-dev \
    libproj-dev \
    libsqlite3-dev \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
  && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# R configurations
RUN echo "CFLAGS=-w\nCXXFLAGS=-w\nMAKEFLAGS=-j$(nproc)" > /usr/local/lib/R/etc/Makevars.site \
  && install2.r --error remotes \
  && installGithub.r -d s-u/unixtools
# Install uv (reticulate's Python package manager)
RUN curl -Ls https://astral.sh/uv/install.sh | sh \
  && mv /root/.local/bin/uv /usr/local/bin/uv \
  && mv /root/.local/bin/uvx /usr/local/bin/uvx
# Create a persistent virtual environment for reticulate and install markitdown
RUN python3 -m venv /opt/r-reticulate \
  && /opt/r-reticulate/bin/pip install --upgrade pip \
  && /opt/r-reticulate/bin/pip install "markitdown[all]" openai
# Install R packages
RUN install2.r --error --skipinstalled \
  BTM \
  classInt \
  colorspace \
  cowplot \
  cshapes \
  countrycode \
  discrim \
  docxtractr \
  doMC \
  duckplyr \
  flextable \
  formattable \
  fs \
  ggrepel \
  ggforce \
  gt \
  gtsummary \
  glue \
  gtExtras \
  ggmap \
  ggpmisc \
  ggthemes \
  ggtext \
  googleway \
  googledrive \
  googlesheets4 \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds # Cleanup for this layer 
RUN install2.r --error --skipinstalled \
  here \
  huxtable \
  janitor \
  kableExtra \
  keras \
  kknn \
  lemon \
  naivebayes \
  officer \
  openxlsx \
  pacman \
  parallel \
  parsnip \
  patchwork \
  pbapply \
  piggyback \
  ranger \
  reticulate \
  scales \
  SnowballC \
  stacks \
  stopwords \
  styler \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds # Cleanup for this layer
RUN install2.r --error --skipinstalled \
  targets \
  text \
  textclean \
  textmineR \
  textrank \
  textrecipes \
  themis \
  tictoc \
  tidylog \
  tidytext \
  tidymodels \
  tidyxl \
  tm \
  topicmodels \
  tokenizers \
  udpipe \
  vip \
  webshot2 \
  wordcloud \
  workflowsets \
  xgboost \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds # Cleanup for this layer
RUN install2.r --error --skipinstalled \
  hexView \
  DT \
  DiagrammeR \
  igraph \
  ggraph \
  incidentally \
  widyr \
  writexl \
  XML \
  tidylda \
  quanteda \
  janeaustenr \
  aRxiv \
  NLP \
  openNLP \
  openNLPdata \
  sotu \
  corporaexplorer \
  humaniformat \
  quarto \
  ragnar \
  && installGithub.r ropensci/gutenbergr \
  && installGithub.r elipousson/officerExtras \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages

# Update R packages
RUN R -e "update.packages(ask = FALSE)"

# Set environment variables
RUN echo CHROMOTE_CHROME=/usr/bin/google-chrome >> /usr/local/lib/R/etc/.Renviron

# Tell reticulate to always use this venv (goes in Renviron alongside CHROMOTE_CHROME)
RUN echo RETICULATE_PYTHON=/opt/r-reticulate/bin/python >> /usr/local/lib/R/etc/.Renviron

# Copy configurations
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
