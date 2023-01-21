FROM rocker/verse:4.2.2
MAINTAINER "Carlos Zambrana-Torrelio" cmzambranat@gmail.com
## Installs to help install
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-unauthenticated --no-install-recommends --no-upgrade \
    openssh-server \
    python3.8 \
    python3.8-dev \
    python3-pip \
    curl \
    libarchive-dev \
    libcairo2-dev \
    libsecret-1-dev \
    htop \
    wget \
  && RSTUDIO_URL="https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.2-576-amd64.deb" \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/
## R config and packages
RUN echo "CFLAGS=-w" >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "CXXFLAGS=-w"  >> /usr/local/lib/R/etc/Makevars.site \
  &&  echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
## install from github
  && installGithub.r -d s-u/unixtools \
## Compile R packages
  && install2.r --error --skipinstalled \
  BTM \
  classInt \
  colorspace \
  cowplot \
  cshapes \
  countrycode \
  discrim \
  docxtractr \
  doMC \
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
  #
  hexView \
  DT \
  DiagrammeR \
  igraph \
  ggraph \
  incidentally \
  widyr \
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
  && installGithub.r ropensci/gutenbergr \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages
RUN echo "MAKEFLAGS=-j$(nproc)"  >> /usr/local/lib/R/etc/Makevars.site \
  && rm /usr/local/lib/R/etc/Makevars.site \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds /root/tmp/downloaded_packages \
  && R -e "update.packages(ask = FALSE)" \
  && echo CHROMOTE_CHROME=/usr/bin/google-chrome >> /usr/local/lib/R/etc/.Renviron
COPY --chown=rstudio /config/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
