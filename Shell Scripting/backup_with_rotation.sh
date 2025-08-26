#!/bin/bash

<< task
this is script for backup with 5 day rotation
task

function display_usage {
        echo "usage: ./backup.sh <source_path> <destination path>"
}

# $# returns the number of command-line arguments passed to the script
# here we check if no arguments were provided (equals 0)
if [ $# -eq 0 ]; then
        display_usage
fi

source_path=$1
dest_path=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')


# $? will store the result for above command if it ran successfully then 0 will be stored.
# send warning or error to /dev/null 
function store_backup {
    # zip command breakdown:
    # zip     - the command to create a zip archive
    # -r      - recursive: include all subdirectories and their contents
    # "${dest_path}/backup_${timestamp}.zip"  - the output zip file path with timestamp
    # "${source_path}"                        - the directory to be backed up
    # > /dev/null                             - redirect output messages to nowhere
    zip -r "${dest_path}/backup_${timestamp}.zip" "${source_path}" > /dev/null  
    if [ $? -eq 0 ]; then
        echo "backup generated successfully for ${timestamp}"
    fi
}

# backups[@] - array of zip files
function perform_rotation {
    
    backups=($(ls -t "${dest_path}/backup_*".zip 2>/dev/null))

    if [ ${#backups[@]} -gt 5 ]; then
        echo "performing rotation for 5 days"
        backups_to_remove=("${backups[@]:5}")

        for backup in "${backups_to_remove[@]}";
        do
            rm -rf ${backups_to_remove}
        done
    fi
}

store_backup
perform_rotation
