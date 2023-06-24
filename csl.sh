#!/bin/bash

create_symbolic_links() {
    source_dir="$1"
    destination_dir="$2"

    # Get a list of all files in the source directory and its subdirectories
    files=$(find "$source_dir" -type f -printf '%P\n')

    # Loop through each file and create a symbolic link in the destination directory
    for file in $files; do
        source_path="$source_dir/$file"
        destination_path="$destination_dir/$file"

        # Create the directory tree in the destination directory if it doesn't exist
        mkdir -p "$(dirname "$destination_path")"

        # Create the symbolic link
        ln -sf "$source_path" "$destination_path"
        echo "Created symbolic link: $source_path -> $destination_path"
    done
}

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Usage: create_symbolic_links <source_directory> <destination_directory>
create_symbolic_links "$1" "$2"
