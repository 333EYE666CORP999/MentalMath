#!/bin/bash

# Define the project directory where all Swift files are located
PROJECT_DIR="../Numerica-iOS"

# Check if the project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Project directory not found at $PROJECT_DIR"
    exit 1
fi

# Use `find` to search for all .swift files in the project directory
find "$PROJECT_DIR" -name "*.swift" | while read -r file; do
    echo "Processing $file..."

    # Check if the file contains a header starting with //
    if ! awk 'NR==1, /^$/ {if (/^\/\//) found=1} END {exit !found}' "$file"; then
        echo "No header found in $file, skipping..."
        continue
    fi

    # Create a backup of the original file in the same directory with .bak extension
    cp "$file" "$file.bak"
    echo "Backup created for $file as $file.bak"

    # Remove only the header and the first empty line if present.
    awk '
        # Skip lines that are part of the header (lines starting with // from the first line)
        # Also, skip one empty line following the header if it exists
        /^\/\// && NR==1, /^[ \t]*$/ {next} 
        # Print the rest of the file after header and empty line
        {print}
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

    echo "Updated $file"
    echo "------------------------------------------"
done

# Delete all .bak files after processing
find "$PROJECT_DIR" -name "*.bak" -delete
echo "All .bak files have been deleted."
echo "Header removal complete for all Swift files in $PROJECT_DIR"
