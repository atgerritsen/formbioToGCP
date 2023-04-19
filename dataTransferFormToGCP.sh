# install Formbio CLI: https://docs.form.bio/form-bio-cli-sdk

curl -sSL https://storage.googleapis.com/formbio-go-releases/public/latest/install/linux | bash

sudo ln -s $HOME/.local/bin/formbio /usr/local/bin/formbio

# login with API token

formbio storage cp -r formbio://colossal/avian/shapiro_lab/seq/PE .

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash miniconda.sh

screen -S #name

# cleaned up and renamed a lot of files, then uploaded the fgf10 sequence from chicken
# conda install -n bioconda bwa

bwa index chicken_fgf10DNA.fa

ls | sort | grep "_R1" > sortedR1.txt

# april 14 2023 - copying over and mapping trimmed and filtered Dodo reads to see if there is a quality difference

formbio storage cp -r formbio://colossal/avian/DodoAnalysis/filtered_reads/Dodo_PE_processed.fq .

