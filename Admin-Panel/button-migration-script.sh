#!/bin/bash

# Nebular Button to Material Button Migration Script
# This script automates the conversion of nbButton directives to Material buttons

echo "=== Nebular Button Migration Script ==="
echo ""

# Create backup
BACKUP_DIR="backup-buttons-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r src/app $BACKUP_DIR/
echo "✓ Backup created in $BACKUP_DIR"
echo ""

# Count current nbButton instances
INITIAL_COUNT=$(grep -r "nbButton" src/app --include="*.html" | wc -l)
echo "Found $INITIAL_COUNT nbButton instances"
echo ""

echo "Applying automated replacements..."

# Replace nbButton with Material button variants
find src/app -name "*.html" -type f -exec sed -i \
  -e 's/nbButton="filled"/mat-raised-button/g' \
  -e 's/nbButton="outlined"/mat-stroked-button/g' \
  -e 's/nbButton="ghost"/mat-button/g' \
  -e 's/nbButton/mat-flat-button/g' \
  -e 's/status="primary"/color="primary"/g' \
  -e 's/status="success"/color="accent"/g' \
  -e 's/status="danger"/color="warn"/g' \
  -e 's/status="info"/color="primary"/g' \
  -e 's/status="warning"/color="warn"/g' \
  -e 's/\[status\]="'\''primary'\''"/color="primary"/g' \
  -e 's/\[status\]="'\''success'\''"/color="accent"/g' \
  -e 's/\[status\]="'\''danger'\''"/color="warn"/g' \
  {} \;

echo "✓ Button directive replacements complete"
echo ""

# Count remaining instances
REMAINING_COUNT=$(grep -r "nbButton" src/app --include="*.html" | wc -l)
echo "Remaining nbButton instances: $REMAINING_COUNT"
echo ""

if [ $REMAINING_COUNT -gt 0 ]; then
  echo "Files with remaining nbButton:"
  grep -r "nbButton" src/app --include="*.html" -l
  echo ""
  echo "These files may need manual review for complex button configurations"
fi

echo "=== Button Migration Complete ==="
echo ""
echo "Next steps:"
echo "1. Review changed files"
echo "2. Test button functionality"
echo "3. Update any button-specific styles in SCSS files"
