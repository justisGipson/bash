### Bash data processing

give all scripts permissions to do things

Might have to adjust some commands depending on your OS

`chmod +x *.sh`

then step by step:

1. run `./download.sh` - it uses `wget` to fetch all the data we'll need for this

2. run `./extract_tavg_us.sh` - to extract all data from csvs for US regions

3. run `./key_cols.sh` - to extract the columns with the data we need

4. run `./date_format.sh` - so we can format the dates into a format that's usable

5. `$ wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt` - fetch list of climate stations

6. `$ grep "^US" ghcnd-stations.txt > us_stations.txt` - extract US stations only

7. `$ cat us_stations.txt | tr -s ' ' > us_stations.txt.tmp; cp us_stations.txt.tmp us_stations.txt;` - making consistent

8. `$ cut -d' ' -f1,5 us_stations.txt > us_stations.txt.tmp; mv us_stations.txt.tmp us_stations.txt;` - only get station & code

9. `$ sed -i '' s/' '/,/g us_stations.txt` - change spaces to commas

10. run `./station_state.sh` - replace station codes with state

11. run `./station_state_data` - maps state abbr to station codes

12. `cat STATE_DAY_TAVG_US_20*.csv > TAVG_US_2010-2019.csv` - merge everything into one file

13. run `./timeslice.sh` - could be optimized, very slow

14. run `./dataSet.sh` - create train, test & validate data sets, can be randomized or sequential. Look @ script and un/comment out obvious lines at the top for this.

