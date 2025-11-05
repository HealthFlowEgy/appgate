#!/bin/bash

# Script to migrate Nebular select components to Angular Material
# Note: This requires manual review as selects need to be wrapped in mat-form-field
# Usage: ./migrate-selects.sh

echo "Starting Nebular select to Angular Material migration..."
echo "Note: This script performs basic replacements. Manual review is required!"
echo ""

# Find all HTML files with nb-select
find src/app/pages -name "*.html" -type f | while read file; do
    if grep -q "nb-select" "$file"; then
        echo "Processing: $file"
        
        # Create backup
        cp "$file" "$file.select.bak"
        
        # Replace nb-select with mat-select
        sed -i 's/<nb-select/<mat-select/g' "$file"
        sed -i 's/<\/nb-select>/<\/mat-select>/g' "$file"
        
        # Replace nb-option with mat-option
        sed -i 's/<nb-option/<mat-option/g' "$file"
        sed -i 's/<\/nb-option>/<\/mat-option>/g' "$file"
        
        echo "  ✓ Basic replacement done: $file"
        echo "  ⚠️  MANUAL REVIEW NEEDED: Wrap mat-select in mat-form-field"
    fi
done

echo ""
echo "Select migration complete!"
echo ""
echo "⚠️  IMPORTANT: Manual steps required:"
echo "1. Wrap each <mat-select> in <mat-form-field>"
echo "2. Move placeholder attribute to <mat-label> inside mat-form-field"
echo "3. Test all dropdowns"
echo "4. Remove backup files when done: find src/app/pages -name '*.select.bak' -delete"
