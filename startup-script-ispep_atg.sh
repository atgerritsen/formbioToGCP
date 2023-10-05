# GCP VM startup script for bioinformatics & RStudio Server
# Author: Stephen Turner
# Last updated: 2023-05-20

# Check to see if you've already initialized. If so, exit.
INITIALIZED=/opt/initialized
[ -f INITIALIZED ] && exit 0

# Install system libs
sudo apt-get update
sudo apt-get install -y \
    vim \
    wget \
    curl \
    gnupg \
    git \
    tmux \
    htop \
    tree \
    make \
    cmake \
    ncftp \
    bzip2 \
    parallel \
    perl \
    gcc \
    g++ \
    pandoc \
    ca-certificates \
    build-essential \
    readline-doc \
    default-jre \
    zlib1g-dev \
    libc-dev \
    libbz2-dev \
    liblzma-dev \
    libssl-dev \
    libperl-dev \
    libffi-dev \
    libgsl0-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libgtextutils-dev \
    libxml2-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libreadline-dev \
    && echo "Done" >> /dev/null

# Google Cloud Storage FUSE
# https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Optionally set the time zone (to the best time zone)
# sudo timedatectl set-timezone America/New_York

# Install latest version of R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt-get update
# sudo apt-get install -y r-base-core r-recommended r-base-html r-base
sudo apt-get install -y r-base

# # Install R packages using Posit package manager: tidyverse, devtools, and stephen's greatest hits
# sudo Rscript -e 'install.packages(c("tidyverse"), repos=c("CRAN"="https://packagemanager.rstudio.com/cran/__linux__/focal/latest/"))'
# sudo Rscript -e 'install.packages(c("devtools"), repos=c("CRAN"="https://packagemanager.rstudio.com/cran/__linux__/focal/latest/"))'
# sudo Rscript -e 'remotes::install_github("stephenturner/Tverse", upgrade=FALSE, repos=c("CRAN"="https://packagemanager.rstudio.com/cran/__linux__/focal/latest/"))'

# Install RStudio server
sudo apt-get install -y gdebi-core
wget -q https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.1-446-amd64.deb
sudo gdebi --non-interactive rstudio-server-2023.03.1-446-amd64.deb
sudo rm -rf rstudio-server-2023.03.1-446-amd64.deb
# sudo rstudio-server verify-installation

# Prevent python2 stuff from ever being installed as a dependency
sudo apt-mark hold python2 python2-minimal python2.7 python2.7-minimal libpython2-stdlib libpython2.7-minimal libpython2.7-stdlib

# Python 3
sudo apt-get install -y python3 python3-pip
sudo ln -s /usr/bin/python3 /usr/bin/python
# Get mambaforge but don't install it
wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
# sudo usermod -aG docker $USER

# Nextflow
cd ${HOME}/build
# Get the latest build
# wget -qO- https://get.nextflow.io | bash
# Get a 22.10 build with support for DSL1
wget https://github.com/nextflow-io/nextflow/releases/download/v22.10.8/nextflow
sudo mv nextflow /usr/local/bin
sudo chmod 755 /usr/local/bin/nextflow

# miniconda
# wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh

# Clean up the tmp dir
cd / && sudo rm -rf ${HOME}/build

# Write the date to the $INITIALIZED file
sudo sh -c "date > $INITIALIZED && chmod 444 $INITIALIZED"
