#!/bin/bash

# Script to automatically migrate Nebular card components to Angular Material
# Usage: ./migrate-cards.sh

echo "Starting Nebular to Angular Material card migration..."

# Find all HTML files in src/app/pages
find src/app/pages -name "*.html" -type f | while read file; do
    # Check if file contains nb-card
    if grep -q "nb-card" "$file"; then
        echo "Migrating: $file"
        
        # Create backup
        cp "$file" "$file.bak"
        
        # Replace nb-card with mat-card
        sed -i 's/<nb-card>/<mat-card>/g' "$file"
        sed -i 's/<\/nb-card>/<\/mat-card>/g' "$file"
        
        # Replace nb-card-header with mat-card-header and wrap content in mat-card-title
        # This is a simplified replacement - manual review may be needed
        sed -i 's/<nb-card-header>/<mat-card-header>\n    <mat-card-title>/g' "$file"
        sed -i 's/<\/nb-card-header>/<\/mat-card-title>\n  <\/mat-card-header>/g' "$file"
        
        # Replace nb-card-body with mat-card-content
        sed -i 's/<nb-card-body/<mat-card-content/g' "$file"
        sed -i 's/<\/nb-card-body>/<\/mat-card-content>/g' "$file"
        
        echo "  ✓ Completed: $file"
    fi
done

echo ""
echo "Migration complete!"
echo ""
echo "Next steps:"
echo "1. Review the migrated files (backups saved as *.bak)"
echo "2. Add MaterialModule to each module's imports"
echo "3. Test the application"
echo "4. Remove backup files if everything works: find src/app/pages -name '*.bak' -delete"
