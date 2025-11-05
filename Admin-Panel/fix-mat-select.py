#!/usr/bin/env python3
"""
Script to fix mat-select components by wrapping them in mat-form-field
and moving placeholder attributes to mat-label.
"""

import re
import os
import sys
from pathlib import Path

def fix_mat_select_in_file(file_path):
    """Fix all mat-select components in a single file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern to match mat-select tags (including multi-line)
    # This regex captures the opening tag, attributes, and content until closing tag
    pattern = r'<mat-select([^>]*)>(.*?)</mat-select>'
    
    def replace_select(match):
        attributes = match.group(1)
        inner_content = match.group(2)
        
        # Extract placeholder if it exists
        placeholder_match = re.search(r'placeholder=["\']([^"\']*)["\']', attributes)
        placeholder_text = placeholder_match.group(1) if placeholder_match else None
        
        # Remove placeholder from attributes if found
        if placeholder_text:
            attributes = re.sub(r'\s*placeholder=["\'][^"\']*["\']', '', attributes)
        
        # Build the replacement
        result = '<mat-form-field>\n'
        if placeholder_text:
            result += f'                        <mat-label>{placeholder_text}</mat-label>\n'
        result += f'                        <mat-select{attributes}>{inner_content}</mat-select>\n'
        result += '                    </mat-form-field>'
        
        return result
    
    # Replace all mat-select occurrences
    content = re.sub(pattern, replace_select, content, flags=re.DOTALL)
    
    # Only write if content changed
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to process all HTML files."""
    base_dir = Path('src/app/pages')
    
    if not base_dir.exists():
        print(f"Error: Directory {base_dir} not found!")
        sys.exit(1)
    
    print("Fixing mat-select components...")
    print()
    
    fixed_count = 0
    total_files = 0
    
    # Find all HTML files
    for html_file in base_dir.rglob('*.html'):
        total_files += 1
        if fix_mat_select_in_file(html_file):
            print(f"✓ Fixed: {html_file}")
            fixed_count += 1
    
    print()
    print(f"Processing complete!")
    print(f"Files processed: {total_files}")
    print(f"Files modified: {fixed_count}")
    print()
    
    if fixed_count > 0:
        print("Next steps:")
        print("1. Review the changes with: git diff")
        print("2. Test the application")
        print("3. Commit the changes")

if __name__ == '__main__':
    main()
