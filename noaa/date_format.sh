#!/bin/bash

for csv_file in `ls TAVG_*.csv`; do
    echo Date formatting $csv_file
    # insert , after year
    sed -i '' 's/,..../&,/' $csv_file
    # insert , after month
    sed -i '' 's/,....,../&,/' $csv_file
done
