# Core Layout & Navigation Migration Plan

## Overview

This document outlines the detailed plan for migrating the AppsGate Admin Panel's core layout and navigation from Nebular to Angular Material.

## Current Architecture Analysis

### Layout Structure

The application currently uses a **Nebular-based layout** with the following components:

1. **Main Layout Component:** `OneColumnLayoutComponent`
   - Uses `<nb-layout>` as the root container
   - Contains header, sidebar, content area, and footer
   
2. **Header Component:** `HeaderComponent`
   - Contains logo, sidebar toggle, theme selector, and logout button
   - Uses `<nb-icon>`, `<nb-select>`, and `<nb-actions>`

3. **Sidebar Component:** Integrated in layout
   - Uses `<nb-sidebar>` with responsive behavior
   - Contains `<nb-menu>` for navigation

4. **Menu System:** `pages-menu.ts`
   - Uses Nebular's `NbMenuItem` interface
   - Supports nested menu items with icons
   - Includes permission-based filtering

5. **Footer Component:** `FooterComponent`
   - Simple footer with copyright information

### Key Nebular Components to Migrate

| Nebular Component | Current Usage | Angular Material Equivalent |
|-------------------|---------------|----------------------------|
| `<nb-layout>` | Root layout container | `<mat-sidenav-container>` |
| `<nb-layout-header>` | Fixed header | `<mat-toolbar>` + custom positioning |
| `<nb-sidebar>` | Collapsible sidebar | `<mat-sidenav>` |
| `<nb-layout-column>` | Main content area | `<mat-sidenav-content>` |
| `<nb-layout-footer>` | Fixed footer | Custom `<footer>` element |
| `<nb-menu>` | Navigation menu | Custom component with `<mat-nav-list>` |
| `<nb-icon>` | Icons in menu/header | `<mat-icon>` |
| `<nb-select>` | Theme selector | `<mat-select>` (already migrated) |
| `<nb-actions>` | Action buttons | `<mat-toolbar>` with buttons |

## Migration Strategy

### Phase 1: Create Material Layout Foundation

**Objective:** Build the new Angular Material layout structure without breaking existing functionality.

**Steps:**

1. Create a new `material-layout` component alongside the existing Nebular layout
2. Implement `<mat-sidenav-container>` with `<mat-sidenav>` and `<mat-sidenav-content>`
3. Add Material toolbar for header
4. Create custom footer component
5. Test the basic structure in isolation

**Files to Create:**
- `src/app/@theme/layouts/material-layout/material-layout.component.ts`
- `src/app/@theme/layouts/material-layout/material-layout.component.html`
- `src/app/@theme/layouts/material-layout/material-layout.component.scss`

### Phase 2: Migrate Navigation Menu

**Objective:** Replace `<nb-menu>` with a custom Angular Material navigation component.

**Steps:**

1. Create a new `MaterialMenuComponent` that accepts the same menu structure
2. Use `<mat-nav-list>` for the menu container
3. Use `<mat-list-item>` for menu items
4. Use `<mat-expansion-panel>` for nested menu items
5. Preserve icon support using `<mat-icon>`
6. Maintain permission-based filtering logic

**Files to Create:**
- `src/app/@theme/components/material-menu/material-menu.component.ts`
- `src/app/@theme/components/material-menu/material-menu.component.html`
- `src/app/@theme/components/material-menu/material-menu.component.scss`

**Interface Changes:**
- Replace `NbMenuItem` with a custom `MaterialMenuItem` interface (or keep compatible)
- Ensure `pages-menu.ts` works with the new menu component

### Phase 3: Migrate Header Component

**Objective:** Update the header to use Angular Material components.

**Steps:**

1. Replace `<nb-icon>` with `<mat-icon>` for the sidebar toggle
2. Update the theme selector (already using `<mat-select>`)
3. Replace `<nb-actions>` with Material toolbar buttons
4. Update styling to match Material Design guidelines

**Files to Modify:**
- `src/app/@theme/components/header/header.component.html`
- `src/app/@theme/components/header/header.component.ts`
- `src/app/@theme/components/header/header.component.scss`

### Phase 4: Update Pages Component

**Objective:** Switch from `<ngx-one-column-layout>` to the new Material layout.

**Steps:**

1. Update `pages.component.ts` to use the new `<ngx-material-layout>` component
2. Replace `<nb-menu>` with the new `<ngx-material-menu>` component
3. Test routing and navigation
4. Verify permission-based menu filtering still works

**Files to Modify:**
- `src/app/pages/pages.component.ts`

### Phase 5: Styling and Theming

**Objective:** Ensure the new layout matches the existing design and branding.

**Steps:**

1. Update the Material theme to match current colors
2. Add custom CSS for sidebar animations
3. Ensure responsive behavior on mobile devices
4. Test dark/light theme switching (if applicable)
5. Verify HealthFlow branding is preserved

**Files to Modify:**
- `src/custom-material-theme.scss`
- `src/app/@theme/styles/styles.scss`
- Layout component SCSS files

### Phase 6: Testing and Cleanup

**Objective:** Thoroughly test the new layout and remove old Nebular dependencies.

**Steps:**

1. Test all navigation paths
2. Test sidebar toggle functionality
3. Test responsive behavior on different screen sizes
4. Test theme switching
5. Verify all menu items are clickable and functional
6. Remove old Nebular layout components (after confirming everything works)
7. Update documentation

## Implementation Details

### Material Sidenav Container Structure

```html
<mat-sidenav-container class="app-container">
  <!-- Sidebar -->
  <mat-sidenav #sidenav mode="side" opened class="app-sidenav">
    <ngx-material-menu [items]="menu"></ngx-material-menu>
  </mat-sidenav>

  <!-- Main Content -->
  <mat-sidenav-content>
    <!-- Header -->
    <mat-toolbar color="primary" class="app-header">
      <button mat-icon-button (click)="sidenav.toggle()">
        <mat-icon>menu</mat-icon>
      </button>
      <span class="app-name">{{ appName }}</span>
      <span class="spacer"></span>
      <!-- Theme selector and logout button -->
    </mat-toolbar>

    <!-- Page Content -->
    <div class="content-wrapper">
      <router-outlet></router-outlet>
    </div>

    <!-- Footer -->
    <footer class="app-footer">
      <ngx-footer></ngx-footer>
    </footer>
  </mat-sidenav-content>
</mat-sidenav-container>
```

### Material Menu Component Structure

```html
<mat-nav-list>
  <ng-container *ngFor="let item of items">
    <!-- Simple menu item (no children) -->
    <a mat-list-item [routerLink]="item.link" *ngIf="!item.children">
      <mat-icon matListItemIcon>{{ item.icon }}</mat-icon>
      <span matListItemTitle>{{ item.title }}</span>
    </a>

    <!-- Expandable menu item (with children) -->
    <mat-expansion-panel *ngIf="item.children" class="menu-expansion">
      <mat-expansion-panel-header>
        <mat-panel-title>
          <mat-icon>{{ item.icon }}</mat-icon>
          <span>{{ item.title }}</span>
        </mat-panel-title>
      </mat-expansion-panel-header>
      <mat-nav-list>
        <a mat-list-item [routerLink]="child.link" *ngFor="let child of item.children">
          <span matListItemTitle>{{ child.title }}</span>
        </a>
      </mat-nav-list>
    </mat-expansion-panel>
  </ng-container>
</mat-nav-list>
```

## Responsive Behavior

### Desktop (>= 1024px)
- Sidebar always visible
- `mode="side"` with `opened="true"`

### Tablet (768px - 1023px)
- Sidebar toggleable
- `mode="over"` with `opened="false"`

### Mobile (< 768px)
- Sidebar hidden by default
- `mode="over"` with `opened="false"`
- Full-width content

## Risk Mitigation

### Potential Issues

1. **Breaking Changes:** The layout is fundamental to the app
   - **Mitigation:** Create new components alongside old ones, switch gradually
   
2. **Menu Functionality:** Permission filtering and translation might break
   - **Mitigation:** Keep the same menu data structure and logic
   
3. **Styling Inconsistencies:** Material Design looks different from Nebular
   - **Mitigation:** Add custom CSS to match existing design
   
4. **Responsive Behavior:** Sidebar behavior might not work on all devices
   - **Mitigation:** Test thoroughly on multiple screen sizes

## Testing Checklist

- [ ] Sidebar opens and closes correctly
- [ ] Menu items navigate to correct routes
- [ ] Nested menu items expand/collapse properly
- [ ] Permission-based filtering works
- [ ] Menu item translations load correctly
- [ ] Header displays correctly
- [ ] Theme selector works (if applicable)
- [ ] Logout button functions
- [ ] Footer displays correctly
- [ ] Layout is responsive on mobile
- [ ] Layout is responsive on tablet
- [ ] Layout works on desktop
- [ ] All icons display correctly
- [ ] HealthFlow branding is preserved

## Rollback Plan

If critical issues arise:

1. Revert `pages.component.ts` to use `<ngx-one-column-layout>`
2. Keep both layout systems in parallel until issues are resolved
3. Document issues for future resolution

## Timeline Estimate

- **Phase 1:** 2-3 hours (Create Material layout foundation)
- **Phase 2:** 3-4 hours (Migrate navigation menu)
- **Phase 3:** 1-2 hours (Migrate header)
- **Phase 4:** 1 hour (Update pages component)
- **Phase 5:** 2-3 hours (Styling and theming)
- **Phase 6:** 2-3 hours (Testing and cleanup)

**Total Estimated Time:** 11-16 hours

---

**Last Updated:** November 5, 2025
