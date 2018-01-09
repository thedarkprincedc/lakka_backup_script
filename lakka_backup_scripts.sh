#!/bin/bash

if [ "$#" -eq  "0" ]
    then
        echo -e "\nNo lakka client ip address supplied\n\
Please supply and ip address in the following format\n\n\
\t$0 192.168.1.xxx\n"
        exit 1
fi

echo -e "\n\nConnected to Lakka Client at $1"

HOST=$1
CURRENT_DATE=$(date +'%Y-%m-%d')
OUT_FILE="lakka_backup_"$CURRENT_DATE".zip"

rm -rf "./"$OUT_FILE
rm -rf ./tmp

# Backup Playlist and Mount Scripts
echo -e "Preparing playlists and mount-scripts.....\n"
ssh root@$HOST /bin/bash <<EOF
    rm -rf /tmp/lakka_backup
    mkdir -p /tmp/lakka_backup
    mkdir -p /tmp/lakka_backup/mount-scripts
    mkdir -p /tmp/lakka_backup/playlists
    cp -rp /storage/playlists/* /tmp/lakka_backup/playlists
    cp -rp /storage/.config/system.d/storage-roms-* /tmp/lakka_backup/mount-scripts
    zip /tmp/lakka_backup/$OUT_FILE /tmp/lakka_backup/mount-scripts/* /tmp/lakka_backup/playlists/*
EOF


echo -e "Backing up playlists and mount-scripts.....\n"
scp root@$HOST:/tmp/lakka_backup/$OUT_FILE ./
exit 1
echo -e "Backed up playlists and mount-scripts.....\n"
echo -e "Backing up thumbnails...."
sftp -r root@$HOST:/storage/thumbnails ./
echo -e "Backed up thumbnails...."
