#!/bin/bash

# Phase 1: Quick Input Migration (Non-Critical Forms)
# Remove nbInput from non-critical forms only

echo "=== Input Migration Phase 1: Non-Critical Forms ==="
echo ""

# Backup first
BACKUP_DIR="backup-inputs-phase1-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r src/app $BACKUP_DIR/
echo "✓ Backup created in $BACKUP_DIR"
echo ""

# Count initial instances
INITIAL_COUNT=$(grep -r "nbInput" src/app --include="*.html" | wc -l)
echo "Initial nbInput instances: $INITIAL_COUNT"
echo ""

echo "Removing nbInput from non-critical forms..."
echo "(Excluding auth/, */save/*, */edit/*, */forms/*)"
echo ""

# Remove nbInput from non-critical forms
# Exclude critical form directories
find src/app -name "*.html" \
  -not -path "*/auth/*" \
  -not -path "*/save/*" \
  -not -path "*/edit/*" \
  -not -path "*/forms/*" \
  -type f -exec sed -i 's/ nbInput//g' {} \;

echo "✓ Phase 1 complete - nbInput removed from non-critical forms"
echo ""

# Count remaining instances
REMAINING_COUNT=$(grep -r "nbInput" src/app --include="*.html" | wc -l)
REMOVED_COUNT=$((INITIAL_COUNT - REMAINING_COUNT))

echo "Summary:"
echo "- Removed: $REMOVED_COUNT instances"
echo "- Remaining (critical forms): $REMAINING_COUNT instances"
echo ""

echo "Critical forms that need Phase 2 migration:"
echo ""
echo "Authentication forms:"
grep -r "nbInput" src/app/auth --include="*.html" -l 2>/dev/null | head -5
echo ""
echo "Save forms:"
find src/app -path "*/save/*" -name "*.html" -exec grep -l "nbInput" {} \; 2>/dev/null | head -5
echo ""
echo "Edit forms:"
find src/app -path "*/edit/*" -name "*.html" -exec grep -l "nbInput" {} \; 2>/dev/null | head -5
echo ""

echo "=== Phase 1 Complete ==="
echo ""
echo "Next: Run Phase 2 script for critical forms"
