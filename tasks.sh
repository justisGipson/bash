# Search for Files Recursively To Find an Expression - "" is for expression to match:
find . -type f -exec grep -l "" {} \;

# Print the Elapsed Time of Code Execution:
#!/bin/bash

start_time=$(date +%s)

# your code here

end_time=$(date +%s)

echo "Time elapsed: $(($end_time - $start_time)) seconds"

# Search and Replace Strings in Files - This command will replace strings equal to localhost:8000 with localhost:8080 in all files:
find . -type f -exec grep -l "localhost:8000" {} \; | xargs sed -i 's/localhost:8000/localhost:8080/g'

# Delete Specific Files - This command deletes all empty files ending with .log:
find . -type f -name "*.log" -exec rm {} \;

# To delete all files older than 25 days, run this command:
find . -type f -mtime +25 -exec rm {} \;

# Execute Command on Each File if a Condition Is Met - This script loops through all files in the current directory and checks if the filename starts with a letter. If the condition is met, it executes an echo command in this example:
for file in *; do
    if [[ $file =~ ^[a-zA-Z] ]]; then
        # execute command on the file
        echo $file
    fi
done

# Download Files From a Remote Server - Use this command to download a file from a server and save it locally:
scp username@server:path/to/file destination_path

# Upload Files to a Remote Server - Copy a local directory to a remote server:
scp -r /local/dir username@server:/remote/dir

# This command uploads a local file to a server under a new filename:
scp file.txt username@server:/remote/dir/newfilename.txt

# Copy Files Between Two Remote Servers:
scp user1@server1:/dir1/file.txt user2@server2:/dir2

#  Pass an Argument to a Script - If you want to pass a command-line argument to a script, use this syntax in the script:
echo "The first argument is: $1"

# Execution:

./myscript.sh myargument

# If you need a second argument, use $2, and so on.

# Assign a Variable to a Command Result - You can use command substitution to make a variable equal to the output of another command. For example, the code below sends an email to the currently logged on user retrieved by the logname command:
recipient=`logname`
echo "Email text" |  mail -s "this is the subject" "$recipient@domain.com"
