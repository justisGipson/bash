#!/bin/bash

# for each file starting with "20" and ends with ".csv"
for csv_file in `ls 20*.csv`; do
    # extract csv_file to TAVG_US_$cav_file message
    echo "csv_file -> TAVG_US_$csv_file"
    # grep "TAVG" $csv_file: extract lines in file with text "TAVG"
    # |: pipe grep "^US" from those that start with US
    # > TAVG_US_$csv_file: save extracted lines to TAVG_US_$csv_file
    grep "TAVG" $csv_file | grep "^US" > TAVG_US_$csv_file
done
