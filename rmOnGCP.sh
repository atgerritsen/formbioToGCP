# attach bucket to instance to get genomes 

gcloud init
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`

echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install fuse gcsfuse
gcsfuse -v

# bulk decompress pipeline: within google bucket

gcloud dataflow jobs run unzip \
    --gcs-location gs://dataflow-templates/latest/Bulk_Decompress_GCS_Files \
    --region us-central1 \
    --parameters \
inputFilePattern=gs://alidagenome/compressed/*.gz,\
outputDirectory=gs://alidagenome/decompressed,\
outputFailureFile=gs://alidagenome/decompressed
# this is the command to attach the bucket with the uncompressed genomes 
gcsfuse alidagenome genomes

# making a new environment on the VM alida-cactus, this assumes you have conda installed 

conda create -n rm python=3.9 h5py
conda activate rm
wget https://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.1.5.tar.gz
gunzip RepeatMasker-4.1.5.tar.gz
tar xvf RepeatMasker-4.1.5.tar
wget http://www.repeatmasker.org/rmblast-2.11.0+-x64-linux.tar.gz
gunzip rmblast-2.11.0+-x64-linux.tar.gz
tar xvf rmblast-2.11.0+-x64-linux.tar
wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v4.09.1/trf409.linux64
chmod +x trf409.linux64
ln -s trf409.linux64 trf

# run the configure lines, type in paths to rmblast and trf
chmod +x famdb.py #for some reason
chmod +x RepeatMasker
chmod +x ProcessRepeats

# in the top directory now for the test run 

./RepeatMasker -xsmall -species chicken -pa 8 -dir ../maskedOut/ ../genomes/AloBec.fasta

# if success, then run the following in the same directory. 

#!/bin/bash

# this should be run in the RepeatMasker dir

inputDir="../genomes"    # input directory
outputDir="../maskedOut"  # output directory

# list through every file in the input directory
for inputFile in "$inputDir"/*; do
    # check if it is a file (not a directory)
    if [ -f "$inputFile" ]; then
        # get the filename (without path)
        filename=$(basename "$inputFile")

        # prepare the output path
        outputFile="$outputDir/$filename"

        # run the command with the input file and output path
        ./RepeatMasker -xsmall -species chicken -pa 8 -dir  "$outputFile" "$inputFile"
    fi
done



