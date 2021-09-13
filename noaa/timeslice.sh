#!/bin/bash

TIME_SLICE_PERIOD=20

file=TAVG_US_2010-2019.csv

# For each state in file
for state in `cut -d',' -f1 $file | sort | uniq`
do
    # Get all temperature values for the state
    state_tavgs=`grep $state $file | cut -d',' -f5`
    # How many time slices will this result in?
    # mber of temperatures recorded minus size of one timeslice
    num_slices=`echo $state_tavgs | wc -w`
    num_slices=$((${num_slices} - ${TIME_SLICE_PERIOD}))
    # Initialize
    slice_start=1; num_slice=0;
    # For each timeslice
    while [ $num_slice -lt $num_slices ]
    do
        # One timeslice is from slice_start to slice_end
        slice_end=$(($slice_start + $TIME_SLICE_PERIOD - 1))
        # X (1-20)
        sliceX="$slice_start-$slice_end"
        # y (21)
        slicey=$(($slice_end + 1))
        # Print state and timeslice temperature values (column 1-20 and 21)
        echo $state `echo $state_tavgs | cut -d' ' -f$sliceX,$slicey`
        # Increment
        slice_start=$(($slice_start + 1)); num_slice=$(($num_slice + 1));
    done
done
