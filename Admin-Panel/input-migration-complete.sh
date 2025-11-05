#!/bin/bash

# Complete Input Migration Script
# Removes nbInput and ensures proper styling with Bootstrap form-control class

echo "=== Complete Input Migration Script ==="
echo ""

# Backup
BACKUP_DIR="backup-inputs-complete-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r src/app $BACKUP_DIR/
echo "✓ Backup created in $BACKUP_DIR"
echo ""

# Count initial instances
INITIAL_COUNT=$(grep -r "nbInput" src/app --include="*.html" | wc -l)
echo "Initial nbInput instances: $INITIAL_COUNT"
echo ""

echo "Migrating all nbInput directives..."
echo ""

# Strategy: Remove nbInput and ensure form-control class is present
find src/app -name "*.html" -type f -exec sed -i \
  -e 's/nbInput fullWidth/class="form-control"/g' \
  -e 's/nbInput/class="form-control"/g' \
  -e 's/class="form-control" class="form-control"/class="form-control"/g' \
  {} \;

# Also handle cases where class already exists
find src/app -name "*.html" -type f -exec sed -i \
  -e 's/class="\([^"]*\)" class="form-control"/class="\1 form-control"/g' \
  -e 's/class="form-control" class="\([^"]*\)"/class="form-control \1"/g' \
  {} \;

echo "✓ Input migration complete"
echo ""

# Count remaining instances
REMAINING_COUNT=$(grep -r "nbInput" src/app --include="*.html" | wc -l)
REMOVED_COUNT=$((INITIAL_COUNT - REMAINING_COUNT))

echo "Summary:"
echo "- Initial: $INITIAL_COUNT instances"
echo "- Removed: $REMOVED_COUNT instances"
echo "- Remaining: $REMAINING_COUNT instances"
echo ""

if [ $REMAINING_COUNT -gt 0 ]; then
  echo "Files with remaining nbInput (need manual review):"
  grep -r "nbInput" src/app --include="*.html" -l
  echo ""
fi

echo "=== Migration Complete ==="
echo ""
echo "Next steps:"
echo "1. Review changed files"
echo "2. Test form functionality"
echo "3. Verify input styling"
