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

# Set the application path from the second argument (resolve to absolute path)
app_path=$(realpath "$2")

# Define the target file path
file_path="$target_dir/wljs"

# Write the required content to wljs
cat << EOF > "$file_path"
#!/bin/bash

APP_PATH="$app_path"

# URL encode function (pure bash)
urlencode() {
  local raw="\$1"
  local encoded=""
  local i char hex

  for (( i = 0; i < \${#raw}; i++ )); do
    char="\${raw:\$i:1}"
    case "\$char" in
      [a-zA-Z0-9.~_-]) encoded+="\$char" ;;
      *) printf -v hex '%%%02X' "'\$char"
         encoded+="\$hex"
         ;;
    esac
  done
  echo "\$encoded"
}

# Case 1: wljs .
if [ "\$#" -eq 1 ] && [ "\$1" = "." ]; then
    TARGET_PATH="\$(realpath ".")"
    "\$APP_PATH" "\$TARGET_PATH"

# Case 2: wljs -c some command with args
elif [ "\$1" = "-c" ]; then
    shift
    CMD_STRING="\$*"
    ENCODED=\$(urlencode "\$CMD_STRING")
    "\$APP_PATH" "urlenc_\$ENCODED"

# Case 3: wljs -v return version
elif [ "\$1" = "-v" ]; then
    echo "v.01"  

# Case 4: anything else
else
    "\$APP_PATH" "\$@"
fi
EOF

# Make the file executable
chmod +x "$file_path"

# Confirm file creation
if [ -f "$file_path" ]; then
  echo "File created at: $file_path"
else
  echo "Error: Could not create file."
fi