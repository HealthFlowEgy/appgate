# Nebular to Angular Material Component Mapping

This document provides a detailed mapping of all Nebular components currently used in the AppsGate Admin Panel to their Angular Material equivalents.

## Component Usage Analysis

Based on the codebase analysis, the following Nebular components are currently in use:

| Nebular Component | Usage Count | Priority | Angular Material Equivalent |
|-------------------|-------------|----------|----------------------------|
| `nb-card` | 92 | **HIGH** | `mat-card` |
| `nb-card-body` | 88 | **HIGH** | `mat-card-content` |
| `nb-card-header` | 63 | **HIGH** | `mat-card-header` + `mat-card-title` |
| `nb-option` | 42 | **HIGH** | `mat-option` |
| `nb-select` | 41 | **HIGH** | `mat-select` |
| `nb-icon` | 10 | MEDIUM | `mat-icon` |
| `nb-checkbox` | 5 | MEDIUM | `mat-checkbox` |
| `nb-tabset` | 3 | MEDIUM | `mat-tab-group` |
| `nb-tab` | 3 | MEDIUM | `mat-tab` |
| `nb-alert` | 2 | LOW | `mat-card` with custom styling |

## Detailed Migration Guide

### 1. Card Components (Priority: HIGH)

**Nebular:**
```html
<nb-card>
  <nb-card-header>Title</nb-card-header>
  <nb-card-body>
    Content here
  </nb-card-body>
</nb-card>
```

**Angular Material:**
```html
<mat-card>
  <mat-card-header>
    <mat-card-title>Title</mat-card-title>
  </mat-card-header>
  <mat-card-content>
    Content here
  </mat-card-content>
</mat-card>
```

**Required Module:** `MatCardModule`

**Migration Steps:**
1. Import `MatCardModule` in the module
2. Replace `<nb-card>` with `<mat-card>`
3. Replace `<nb-card-header>` with `<mat-card-header>` and wrap text in `<mat-card-title>`
4. Replace `<nb-card-body>` with `<mat-card-content>`
5. Update CSS classes if needed

### 2. Select Components (Priority: HIGH)

**Nebular:**
```html
<nb-select [(ngModel)]="selectedValue" placeholder="Select option">
  <nb-option *ngFor="let option of options" [value]="option.id">
    {{ option.name }}
  </nb-option>
</nb-select>
```

**Angular Material:**
```html
<mat-form-field>
  <mat-label>Select option</mat-label>
  <mat-select [(ngModel)]="selectedValue">
    <mat-option *ngFor="let option of options" [value]="option.id">
      {{ option.name }}
    </mat-option>
  </mat-select>
</mat-form-field>
```

**Required Modules:** `MatSelectModule`, `MatFormFieldModule`

**Migration Steps:**
1. Import `MatSelectModule` and `MatFormFieldModule`
2. Wrap `<mat-select>` in `<mat-form-field>`
3. Replace `<nb-select>` with `<mat-select>`
4. Replace `<nb-option>` with `<mat-option>`
5. Move placeholder to `<mat-label>` inside `<mat-form-field>`

### 3. Icon Components (Priority: MEDIUM)

**Nebular:**
```html
<nb-icon icon="home"></nb-icon>
```

**Angular Material:**
```html
<mat-icon>home</mat-icon>
```

**Required Module:** `MatIconModule`

**Migration Steps:**
1. Import `MatIconModule`
2. Replace `<nb-icon icon="name">` with `<mat-icon>name</mat-icon>`
3. Ensure Material Icons font is loaded in index.html

### 4. Checkbox Components (Priority: MEDIUM)

**Nebular:**
```html
<nb-checkbox [(ngModel)]="checked">Label</nb-checkbox>
```

**Angular Material:**
```html
<mat-checkbox [(ngModel)]="checked">Label</mat-checkbox>
```

**Required Module:** `MatCheckboxModule`

**Migration Steps:**
1. Import `MatCheckboxModule`
2. Replace `<nb-checkbox>` with `<mat-checkbox>`
3. Update styling if needed

### 5. Tab Components (Priority: MEDIUM)

**Nebular:**
```html
<nb-tabset>
  <nb-tab tabTitle="Tab 1">
    Content 1
  </nb-tab>
  <nb-tab tabTitle="Tab 2">
    Content 2
  </nb-tab>
</nb-tabset>
```

**Angular Material:**
```html
<mat-tab-group>
  <mat-tab label="Tab 1">
    Content 1
  </mat-tab>
  <mat-tab label="Tab 2">
    Content 2
  </mat-tab>
</mat-tab-group>
```

**Required Module:** `MatTabsModule`

**Migration Steps:**
1. Import `MatTabsModule`
2. Replace `<nb-tabset>` with `<mat-tab-group>`
3. Replace `<nb-tab>` with `<mat-tab>`
4. Replace `tabTitle` attribute with `label`

### 6. Alert Components (Priority: LOW)

**Nebular:**
```html
<nb-alert status="danger">Error message</nb-alert>
```

**Angular Material:**
```html
<mat-card class="alert alert-danger">
  <mat-card-content>Error message</mat-card-content>
</mat-card>
```

Or use `MatSnackBar` for toast-style notifications:
```typescript
this.snackBar.open('Error message', 'Close', {
  duration: 3000,
  panelClass: ['error-snackbar']
});
```

**Required Modules:** `MatCardModule` or `MatSnackBarModule`

**Migration Steps:**
1. For inline alerts, use `mat-card` with custom styling
2. For toast notifications, use `MatSnackBar`
3. Update component logic accordingly

## Layout Components (Not Yet Analyzed)

The following layout components will need to be analyzed separately:

- `nb-layout` → `mat-sidenav-container`
- `nb-sidebar` → `mat-sidenav`
- `nb-menu` → `mat-nav-list`

These are typically found in the main layout files and will be addressed in Phase 2.

## Migration Priority Order

1. **Phase 1 (Week 1):** Setup and preparation ✅
2. **Phase 2 (Week 2):** Migrate card components (92 instances)
3. **Phase 3 (Week 2-3):** Migrate select and option components (83 instances)
4. **Phase 4 (Week 3):** Migrate remaining components (icons, checkboxes, tabs, alerts)
5. **Phase 5 (Week 4):** Testing and refinement

## Required Angular Material Modules

Add these to your `app.module.ts` or create a shared Material module:

```typescript
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSnackBarModule } from '@angular/material/snack-bar';

@NgModule({
  imports: [
    MatCardModule,
    MatFormFieldModule,
    MatSelectModule,
    MatIconModule,
    MatCheckboxModule,
    MatTabsModule,
    MatSnackBarModule,
  ],
  exports: [
    MatCardModule,
    MatFormFieldModule,
    MatSelectModule,
    MatIconModule,
    MatCheckboxModule,
    MatTabsModule,
    MatSnackBarModule,
  ]
})
export class MaterialModule { }
```

## Testing Checklist

After each component migration:

- [ ] Visual inspection matches original design
- [ ] All functionality works as expected
- [ ] No console errors
- [ ] Responsive design maintained
- [ ] Accessibility features preserved
- [ ] Unit tests updated and passing

---

**Last Updated:** November 5, 2025
