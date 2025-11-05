#!/bin/bash

# Script to migrate remaining Nebular components to Angular Material
# Usage: ./migrate-remaining.sh

echo "Migrating remaining Nebular components..."
echo ""

# Find all HTML files
find src/app/pages -name "*.html" -type f | while read file; do
    modified=false
    
    # Check and migrate checkboxes
    if grep -q "nb-checkbox" "$file"; then
        cp "$file" "$file.remaining.bak" 2>/dev/null
        sed -i 's/<nb-checkbox/<mat-checkbox/g' "$file"
        sed -i 's/<\/nb-checkbox>/<\/mat-checkbox>/g' "$file"
        modified=true
    fi
    
    # Check and migrate icons
    if grep -q '<nb-icon' "$file"; then
        [ ! -f "$file.remaining.bak" ] && cp "$file" "$file.remaining.bak"
        # Convert <nb-icon icon="name"></nb-icon> to <mat-icon>name</mat-icon>
        sed -i 's/<nb-icon icon="\([^"]*\)"[^>]*><\/nb-icon>/<mat-icon>\1<\/mat-icon>/g' "$file"
        modified=true
    fi
    
    # Check and migrate tabs
    if grep -q "nb-tabset\|nb-tab" "$file"; then
        [ ! -f "$file.remaining.bak" ] && cp "$file" "$file.remaining.bak"
        sed -i 's/<nb-tabset/<mat-tab-group/g' "$file"
        sed -i 's/<\/nb-tabset>/<\/mat-tab-group>/g' "$file"
        sed -i 's/<nb-tab tabTitle="\([^"]*\)"/<mat-tab label="\1"/g' "$file"
        sed -i 's/<nb-tab/<mat-tab/g' "$file"
        sed -i 's/<\/nb-tab>/<\/mat-tab>/g' "$file"
        modified=true
    fi
    
    # Check and migrate alerts
    if grep -q "nb-alert" "$file"; then
        [ ! -f "$file.remaining.bak" ] && cp "$file" "$file.remaining.bak"
        # Note: nb-alert doesn't have a direct Material equivalent
        # Converting to mat-card with alert class for now
        sed -i 's/<nb-alert\([^>]*\)>/<div class="alert-card"\1>/g' "$file"
        sed -i 's/<\/nb-alert>/<\/div>/g' "$file"
        modified=true
    fi
    
    if [ "$modified" = true ]; then
        echo "✓ Migrated: $file"
    fi
done

echo ""
echo "Migration complete!"
echo ""
echo "Components migrated:"
echo "- nb-checkbox → mat-checkbox"
echo "- nb-icon → mat-icon"
echo "- nb-tabset → mat-tab-group"
echo "- nb-tab → mat-tab"
echo "- nb-alert → div.alert-card (custom)"
echo ""
echo "Next steps:"
echo "1. Review the changes"
echo "2. Add Material Icons font to index.html if not already present"
echo "3. Test all components"
echo "4. Remove backups: find src/app/pages -name '*.remaining.bak' -delete"
