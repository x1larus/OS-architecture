#!/bin/bash
max_usage=0

if [ ! -d "/LOG" ]
then
  echo "Directory /LOG does not exist."
  exit 0
fi

if [ ! -d "/BACKUP" ]
then
  echo "Directory /BACKUP does not exist."
  exit 0
fi

#                    get disk usage    |   remove string "Use%"  | remove spaces and % symbol
current_usage=$(df /LOG --output=pcent | awk '!/Use%/{print $0}' | tr -d ' ' | tr -d '%')
echo "Current /LOG usage: $current_usage%"

if [ $current_usage -gt $max_usage ] # n1 -gt n2  ===  n1 > n2
then
    echo "Current /LOG usage exceeds the limit of $max_usage%"
    echo "Starting backup process..."
    list_files=$(find /LOG  -type f -printf '%T+ %p\n' | sort | head -n 10 | awk '{print $2}')
    #               |------------archive name-----------|
    tar cfvz /BACKUP/backup-$(date +"%Y-%m-%d--%H-%M-%S").tar.gz $list_files # archive data from /LOG to /BACKUP
    rm $list_files # erase all files in /LOG
    echo "Backup complete!"
fi
# archive unpack: tar xfvz {archive name}