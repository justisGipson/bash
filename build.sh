#####################################################
#####################################################
#   Simple build script to move webpack generated
#      files to another working directory
#
#              Then deploy on surge
#
#####################################################
#####################################################



#!/bin/bash
# build dev to generate the needed bundle files
npm run dev
# since these never change, setting vars to hold
# relative path
file1=<PATH_TO_FILE>
file2=<PATH_TO_FILE>
# same files always here too
file3=<PATH_TO_FILE>
file4=<PATH_TO_FILE>
# check that the files exist and are files
# runs sudo to remove the files, doesn't work without
# the sudo magic
# YOU WILL NEED TO ENTER YOUR ADMIN PASSWORD
if [[ -f $file3 && -f $file4 ]]; then
    echo "both exist"
    sudo rm -f $file3; echo "$file3 removed";
    sudo rm -f $file4; echo "$file4 removed";
fi;
# copies generated files to the right dir
cp $file1 <PATH_TO_COPY_TO>; echo "$file1 copied"
cp $file2 <PATH_TO_COPY_TO>; echo "$file2 copied"
# cd into right dir and deploy
cd <PATH_TO_WORKING_DIR>; echo "Deploying to Surge"; surge; echo "Done";
