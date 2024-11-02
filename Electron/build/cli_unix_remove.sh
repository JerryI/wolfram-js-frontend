#!/bin/bash

# Check if both arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Insufficient arguments provided."
  echo "Usage: $0 <directory_path> <app_path>"
  exit 1
fi

# Resolve the absolute path of the provided directory
target_dir=$(realpath "$1")

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
  echo "Error: Directory '$target_dir' does not exist."
  exit 1
fi

# Set the application path from the second argument
app_path="$2"

# Define the target file path
file_path="$target_dir/wljs"

rm -f "$file_path"
