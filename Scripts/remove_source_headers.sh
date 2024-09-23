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

    # Create a backup of the original file in the same directory with .bak extension
    cp "$file" "$file.bak"

    echo "Backup created for $file as $file.bak"
    
    # Print the content before modification for debugging
    echo "---- To be deleted (before import statement) ----"
    
    # Print lines to be deleted (lines before the first import)
    awk '/^import/{exit} {print}' "$file"
    
    echo "---- Contents below import statement ----"
    
    # Print a few lines after the first import for context (5 lines after import)
    awk '/^import/{found=1} found{print; if(++count==5) exit}' "$file"
    
    # Use sed to remove all lines starting with // before the first import statement
    # The `-i ''` ensures sed modifies files in place on macOS without creating additional backups
    sed -i '' '/^import/,$!{/^\/\//d}' "$file"
    
    echo "Updated $file"
    echo "------------------------------------------"
done

echo "Header removal complete for all Swift files in $PROJECT_DIR"
