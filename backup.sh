#!/bin/bash

usage() {
    echo "Usage: $0 -s [source_directory1 source_directory2 ...] -d destination_directory"
    exit 1
}

if [ "$#" -lt 3 ]; then
    usage
fi

source_dirs=()
dest_dir=""

while [[ "$#" -gt 0 ]]; do
    if [[ "$1" == "-s" ]]; then
        shift
        while [[ "$#" -gt 0 && "$1" != -* ]]; do
            source_dirs+=("$1")
            shift
        done
        elif [[ "$1" == "-d" ]]; then
        shift
        dest_dir="$1"
        shift
    else
        usage
    fi
done

if [ -z "$dest_dir" ]; then
    usage
fi

if [ ! -d "$dest_dir" ]; then
    echo "Destination directory does not exist. Creating directory."
    mkdir -p "$dest_dir"
fi

abs_dest_dir="$(cd "$(dirname "$dest_dir")" && pwd)/$(basename "$dest_dir")"

for dir in "${source_dirs[@]}"; do
    if [ -d "$dir" ]; then
        abs_dir="$(cd "$(dirname "$dir")" && pwd)/$(basename "$dir")"
        
        if [ "$abs_dir" = "$abs_dest_dir" ]; then
            echo "Warning: Source directory "$abs_dir" is the same as destination directory. Skipping."
            continue
        fi
        basename=$(basename "$dir")
        timestamp=$(date +"%Y%m%d%H%M%S")
        tar_file="${dest_dir}/${basename}_${timestamp}.tar.gz"
        tar -czf "$tar_file" -C "$(dirname "$dir")" "$basename"
        file_size=$(du -h --apparent-size $tar_file)
        echo "Backup of "$abs_dir" completed: "
        echo "Size="$file_size" "
        echo
        echo "Backup of "$abs_dir": "$(date)"" >> backup_log.txt >> "${dest_dir}"/backup_log.txt
        echo "Size="$file_size" " >> backup_log.txt
        echo >> backup_log.txt
        
    else
        echo "Warning: $dir is not a directory or does not exist"
    fi
done

echo "All backups are completed."