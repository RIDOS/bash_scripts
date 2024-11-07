#!/bin/bash
#
# Log rotation.
#
# Remove all files extenstion with extension ($2)
# and before count date($1) in files path ($3).
#
# @author a.imaev | RIDOS


COUNT_DATE=$1
FILES_EXTENSION=$2
FILE_PATH=$3

help_comment=$(cat <<EOF
----------------------------------------------------
Log rotated
----------------------------------------------------

params:
    - count_date: Number of days from which files should be deleted.
    - extent:     File extension.
    - pwd:        Path to files.

example:
    bash log-rotated.bash 10 log /tmp/logs/

EOF
)

if [ $# -ne 3 ]; then
    echo "$help_comment"
    exit 1
else
    # Validate count days.
    if [[ ! "$COUNT_DATE" =~ ^[0-9]+$ ]]; then
        echo "Number of days should not be less than 0."
        exit 1
    fi

    # Validate path.
    if [ ! -e "$FILE_PATH" ]; then
        echo "This path does not exist."
        exit 1
    fi
fi

cd "$FILE_PATH"

date_now=$(date +%Y-%m-%d)
date_for=$(date -d "$date_now - $COUNT_DATE days" +%Y-%m-%d)

files=$(find . -type f -name "*.$FILES_EXTENSION" -not -newermt "$date_for")

for file in $files; do
    echo "delete: $file"
    rm "$file"
done

echo "All files on date $date_for has been deleted!"

exit 0
