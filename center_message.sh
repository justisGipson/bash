#!/bin/bash

# center printed message in terminal

# tell us how many columns the terminal has
cols=$( tput cols )
# tell us how many lines (or rows) the terminal has
rows=$( tput lines )
# Take all the command line arguments and assign them to a single variable message
message=$@
# Find out how many characters are in the string message.
# We had to assign all the input values to the variable message
input_length=${#message}
#We need to know what 1/2 the length of the string message is in order to center it
half_input_length=$(( $input_length / 2 ))
# Calculate where to place the message for it to be centered.
middle_row=$(( $rows / 2))
middle_col=$(( ($cols / 2) - $half_input_length ))
# clear terminal
tput clear
# will place the cursor at the given row and column
tput cup $middle_row $middle_col
# will make everything printed to the screen bold
tput bold
# Now we have everything set up let's print our message
echo $@
# tput sgr0 will turn bold off and any other changes made
tput sgr0
#Place the prompt at the bottom of the screen
tput cup $( tput lines ) 0
