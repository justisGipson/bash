PATTERN_FILE=us_stations.txt

for DATA_FILE in `ls TAVG_US_*.csv`
do
    echo ${DATA_FILE}
    
    awk -F, \
    'FNR==NR { x[$1]=$2; next; } { $1=x[$1]; print $0 }' \
    OFS=, \
    ${PATTERN_FILE} ${DATA_FILE} > ${DATA_FILE}.tmp
    
    mv ${DATA_FILE}.tmp ${DATA_FILE}
done
