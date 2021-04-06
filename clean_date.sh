#!/bin/bash

# accomodates many date formats

clean_date=$( echo $1 | sed 's/[ /:\^#]/-/g' )

echo $clean_date
