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
    
    # Use sed to remove all lines starting with // before the first import statement
    sed -i '' '/^import/,$!{/^\/\//d}' "$file"
    
    echo "Updated $file"
done

echo "Header removal complete for all Swift files in $PROJECT_DIR"

