#!/bin/bash

# Script to add MaterialModule imports to all page modules
# Usage: ./add-material-imports.sh

echo "Adding MaterialModule imports to page modules..."

# Find all module files in src/app/pages
find src/app/pages -name "*.module.ts" -type f | while read file; do
    # Check if MaterialModule is already imported
    if ! grep -q "MaterialModule" "$file"; then
        echo "Updating: $file"
        
        # Create backup
        cp "$file" "$file.bak"
        
        # Add import statement after other imports
        if grep -q "import { ThemeModule }" "$file"; then
            sed -i "/import { ThemeModule }/a import { MaterialModule } from '../../@core/material/material.module';" "$file"
        fi
        
        # Add MaterialModule to imports array
        if grep -q "imports: \[" "$file"; then
            sed -i "/imports: \[/a \    MaterialModule," "$file"
        fi
        
        echo "  ✓ Updated: $file"
    else
        echo "Skipping (already has MaterialModule): $file"
    fi
done

echo ""
echo "Import updates complete!"
echo "Please review the changes and test the application."
