#!/bin/sh

GEN=SEQ
# GEN=RAN

FILE=TIMESLICE_TAVG_US_2010-2019.csv

TRAIN_SET_PERCENT=70
TEST_SET_PERCENT=20
VAL_SET_PERCENT=$(( 100 - $TRAIN_SET_PERCENT - $TEST_SET_PERCENT ))

TRAIN_DATA=TRAIN_$FILE
TEST_DATA=TEST_$FILE
VAL_DATA=VAL_$FILE

> $TRAIN_DATA
> $TEST_DATA
> $VAL_DATA

for state in `cut -d',' -f1 $FILE | sort | uniq`
do
    NUM_STATE_DATA=`grep "$state" $FILE | wc -l`
    echo "$state: $NUM_STATE_DATA"
    
    TRAIN_NUM_DATA=$(( $NUM_STATE_DATA * $TRAIN_SET_PERCENT / 100 ))
    TEST_NUM_DATA=$(( $NUM_STATE_DATA * $TEST_SET_PERCENT / 100 ))
    VAL_NUM_DATA=$(( $NUM_STATE_DATA - $TRAIN_NUM_DATA - $TEST_NUM_DATA ))
    
    if [ $GEN == "SEQ" ]
    then
        echo "Sequential"
        STATE_DATA=`grep $state $FILE`
    elif [ $GEN == "RAN" ]
    then
        echo "Randomized"
        STATE_DATA=`grep $state $FILE | shuf`
    else
        echo "Unknown data gen type: " $GEN
        exit 1
    fi
    
    # Train set
    per=$TRAIN_SET_PERCENT
    num=$TRAIN_NUM_DATA; from=1; to=$(($from + $num - 1));
    echo Train set: $per% $num from=$from to=$to
    echo "$STATE_DATA" | head -$to >> $TRAIN_DATA
    
    # Test set
    per=$TEST_SET_PERCENT
    num=$TEST_NUM_DATA; from=$(($to + 1)); to=$(($from + $num - 1));
    echo Test set: $per% $num from=$from to=$to
    echo "$STATE_DATA" | head -$to | tail -$num >> $TEST_DATA
    
    # Validate set
    per=$VAL_SET_PERCENT
    num=$VAL_NUM_DATA; from=$(($to + 1)); to=$NUM_STATE_DATA;
    echo Validate set: $per% $num from=$from to=$to
    echo "$STATE_DATA" | tail -$num >> $VAL_DATA
    
    echo
done
