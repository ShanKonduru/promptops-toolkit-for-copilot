#!/bin/bash
# Script to copy Copilot prompts to VS Code roaming profile
# Works on Linux and macOS with dynamic user profile path

# Detect OS and set the roaming profile path accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ROAMING_PATH="$HOME/Library/Application Support/Code/User/prompts"
else
    # Linux and other Unix-like systems
    ROAMING_PATH="$HOME/.config/Code/User/prompts"
fi

# Get the script directory (where this script is located)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Verify source directory has prompt files
if ! ls "$SCRIPT_DIR"/*.prompt.md 1> /dev/null 2>&1; then
    echo "❌ Error: No prompt files found in $SCRIPT_DIR"
    echo "Please ensure you're running this script from the dev-ex-engine folder."
    exit 1
fi

# Create destination folder if it doesn't exist
if [ ! -d "$ROAMING_PATH" ]; then
    echo "📁 Creating prompts directory: $ROAMING_PATH"
    mkdir -p "$ROAMING_PATH"
    if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to create prompts directory"
        exit 1
    fi
fi

# Copy all prompt files
echo "📋 Copying prompt files to: $ROAMING_PATH"
copy_count=0

for file in "$SCRIPT_DIR"/*.prompt.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "  → Copying $filename"
        cp "$file" "$ROAMING_PATH/$filename"
        if [ $? -eq 0 ]; then
            ((copy_count++))
        else
            echo "    ❌ Failed to copy $filename"
        fi
    fi
done

# Report results
echo ""
echo "✅ Success! Copied $copy_count prompt files."
echo ""
echo "📍 Destination: $ROAMING_PATH"
echo ""
echo "💡 Reload VS Code to see the prompts:"
echo "   Cmd+Shift+P → Developer: Reload Window"
echo ""
