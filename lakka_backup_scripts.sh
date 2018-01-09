#!/bin/bash

if [ "$#" -eq  "0" ]
    then
        echo -e "\nNo lakka client ip address supplied\n\
Please supply and ip address in the following format\n\n\
\t$0 192.168.1.xxx\n"
        exit 1
fi

HOST=$1
CURRENT_DATE=$(date +'%Y-%m-%d')
OUT_FILE="lakka_backup_"$CURRENT_DATE".zip"

rm -rf "./"$OUT_FILE
rm -rf ./tmp

# Backup Playlist and Mount Scripts
if ssh root@$HOST /bin/bash <<EOF
    echo "Connected to Lakka Client at $1"
    rm -rf /tmp/lakka_backup
    mkdir -p /tmp/lakka_backup
    mkdir -p /tmp/lakka_backup/mount-scripts
    mkdir -p /tmp/lakka_backup/playlists
    cp -rp /storage/playlists/* /tmp/lakka_backup/playlists
    cp -rp /storage/.config/system.d/storage-roms-* /tmp/lakka_backup/mount-scripts
    zip /tmp/lakka_backup/$OUT_FILE /tmp/lakka_backup/mount-scripts/* /tmp/lakka_backup/playlists/*
EOF
then
    echo "Successfully copied playlists and mount-scripts"
else
    echo "Failed to copy playlists and mount-scripts"
fi

# downloading backup file
if scp root@$HOST:/tmp/lakka_backup/$OUT_FILE ./
then
    echo "Successfully dowloaded" $OUT_FILE
else
    echo "Failed to download" $OUT_FILE
fi

#downloading thumbnails
if sftp -r root@$HOST:/storage/thumbnails ./
then 
    echo "Successfully downloaded thumbnails"
else
    echo "Failed to download thumbnails"
fi
