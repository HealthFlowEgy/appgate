#!/bin/bash

# Replace nb-icon with mat-icon
find src/app -name "*.html" -type f -exec sed -i 's/<nb-icon/<mat-icon/g' {} +
find src/app -name "*.html" -type f -exec sed -i 's/<\/nb-icon>/<\/mat-icon>/g' {} +

# Replace icon attribute with inline content for mat-icon
# This is a simple replacement - manual review may be needed for complex cases
find src/app -name "*.html" -type f -exec sed -i 's/icon="\([^"]*\)"/>\1<\/mat-icon><mat-icon style="display:none"/g' {} +

echo "Icon replacement complete"
