#!/bin/bash

FROM_YEAR=2010
TO_YEAR=2020

year=$FROM_YEAR

while [ $year -le $TO_YEAR ]; do
    # show year being downloaded
    echo $year
    # fetch
    wget https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/${year}.csv.gz
    # unzip
    gzip -d ${year}.csv.gz
    # move to next year
    year=$(($year+1))
done
