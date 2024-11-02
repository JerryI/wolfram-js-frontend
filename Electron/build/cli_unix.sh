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

# Write the required content to wljs
cat << EOF > "$file_path"
#!/bin/bash

APP_PATH="$app_path"
                                        
P=\$(realpath "\$@")
"\$APP_PATH" "\$P"
EOF

# Make the file executable (if needed)
chmod +x "$file_path"

# Confirm file creation
if [ -f "$file_path" ]; then
  echo "File created at: $file_path"
else
  echo "Error: Could not create file."
fi