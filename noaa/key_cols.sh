#!/bin/bash

for csv_file in `ls TAVG_US_*.csv`; do
    echo "Extracting cols $csv_file"
    # cat $csv_file: 'cat' is to concatenate files - here used to show one year csv file
    # |: cut -d',' -f1,2,4: Cut columns 1,2,4 with , delimitor
    # > $csv_file.cut: Save to temporary file | > $csv_file.cut:
    cat $csv_file | cut -d',' -f1,2,4 > $csv_file.cut
    # mv $csv_file.cut $csv_file: Rename temporary file to original file
    mv $csv_file.cut $csv_file
done
