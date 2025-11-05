# Nebular to Angular Material Migration Plan

## Problem Statement

The current admin panel uses **Nebular 13.0.0** with **Angular 17.1.0**. Nebular 13.x is designed for Angular 15.x, and the latest Nebular version (14.x) only supports up to Angular 16.x. This creates compatibility issues and limits access to Angular 17's features and security updates.

## Migration Options

### Option 1: Migrate to Angular Material (Recommended)

**Pros:**
- Official Angular UI library
- Excellent documentation and community support
- Full compatibility with Angular 17+
- Regular updates and long-term support
- Comprehensive component library
- Better performance

**Cons:**
- Requires significant refactoring
- Different component API
- Need to rebuild custom themes

**Estimated Effort:** 3-4 weeks

### Option 2: Downgrade to Angular 15/16

**Pros:**
- Minimal code changes
- Nebular components work as-is

**Cons:**
- Miss out on Angular 17 features
- Security vulnerabilities in older versions
- Technical debt accumulation
- Not a long-term solution

**Estimated Effort:** 1 week

### Option 3: Wait for Nebular 15+ (Not Recommended)

**Pros:**
- No migration needed

**Cons:**
- No timeline for Nebular 15 release
- Project stagnation
- Security risks

## Recommended Approach: Phased Migration to Angular Material

### Phase 1: Setup and Preparation (Week 1)

1. **Install Angular Material:**
   ```bash
   ng add @angular/material
   ```

2. **Create a component mapping document:**
   - Map each Nebular component to its Angular Material equivalent
   - Identify custom components that need rebuilding

3. **Set up theming:**
   - Define custom theme based on current Nebular theme
   - Configure colors, typography, and spacing

4. **Create a migration branch:**
   ```bash
   git checkout -b feature/angular-material-migration
   ```

### Phase 2: Core Components Migration (Week 2)

Migrate the most frequently used components first:

1. **Layout Components:**
   - `nb-layout` → `mat-sidenav-container`
   - `nb-sidebar` → `mat-sidenav`
   - `nb-menu` → `mat-nav-list`

2. **Form Components:**
   - `nb-input` → `mat-form-field` + `input`
   - `nb-select` → `mat-select`
   - `nb-checkbox` → `mat-checkbox`
   - `nb-radio` → `mat-radio-button`

3. **Button Components:**
   - `nb-button` → `mat-button` / `mat-raised-button`
   - `nb-icon-button` → `mat-icon-button`

### Phase 3: Data Display Components (Week 3)

1. **Tables:**
   - `nb-table` → `mat-table`
   - `nb-tree-grid` → `mat-tree`

2. **Cards and Lists:**
   - `nb-card` → `mat-card`
   - `nb-list` → `mat-list`

3. **Dialogs and Overlays:**
   - `nb-dialog` → `mat-dialog`
   - `nb-popover` → `mat-menu` / Custom overlay
   - `nb-tooltip` → `mat-tooltip`

### Phase 4: Advanced Components & Testing (Week 4)

1. **Charts:**
   - Keep existing chart libraries (ngx-charts, ng2-charts, echarts)
   - Update styling to match new theme

2. **Date/Time:**
   - `nb-datepicker` → `mat-datepicker`

3. **Notifications:**
   - `nb-toastr` → `mat-snack-bar`

4. **Testing:**
   - Unit test all migrated components
   - End-to-end testing of critical flows
   - Visual regression testing

## Component Mapping Reference

| Nebular Component | Angular Material Equivalent | Notes |
|-------------------|----------------------------|-------|
| `nb-layout` | `mat-sidenav-container` | Layout structure |
| `nb-sidebar` | `mat-sidenav` | Side navigation |
| `nb-menu` | `mat-nav-list` | Navigation menu |
| `nb-card` | `mat-card` | Content card |
| `nb-button` | `mat-button` | Button |
| `nb-input` | `mat-form-field` + `input` | Text input |
| `nb-select` | `mat-select` | Dropdown select |
| `nb-checkbox` | `mat-checkbox` | Checkbox |
| `nb-radio` | `mat-radio-button` | Radio button |
| `nb-datepicker` | `mat-datepicker` | Date picker |
| `nb-dialog` | `mat-dialog` | Modal dialog |
| `nb-tooltip` | `mat-tooltip` | Tooltip |
| `nb-popover` | `mat-menu` | Popover menu |
| `nb-toastr` | `mat-snack-bar` | Toast notifications |
| `nb-table` | `mat-table` | Data table |
| `nb-list` | `mat-list` | List |
| `nb-accordion` | `mat-expansion-panel` | Accordion |
| `nb-tabs` | `mat-tab-group` | Tabs |
| `nb-stepper` | `mat-stepper` | Stepper |
| `nb-progress-bar` | `mat-progress-bar` | Progress bar |
| `nb-spinner` | `mat-spinner` | Loading spinner |

## Migration Checklist

### Pre-Migration
- [ ] Backup current codebase
- [ ] Create migration branch
- [ ] Install Angular Material
- [ ] Set up custom theme
- [ ] Document current component usage

### During Migration
- [ ] Migrate layout components
- [ ] Migrate form components
- [ ] Migrate data display components
- [ ] Migrate dialog/overlay components
- [ ] Update routing and navigation
- [ ] Update services and utilities
- [ ] Update styles and theming

### Post-Migration
- [ ] Remove Nebular dependencies
- [ ] Run full test suite
- [ ] Perform visual regression testing
- [ ] Update documentation
- [ ] Deploy to staging for QA
- [ ] Performance testing
- [ ] Deploy to production

## Code Examples

### Before (Nebular):
```typescript
<nb-card>
  <nb-card-header>User Details</nb-card-header>
  <nb-card-body>
    <input nbInput placeholder="Name" [(ngModel)]="user.name">
    <button nbButton status="primary" (click)="save()">Save</button>
  </nb-card-body>
</nb-card>
```

### After (Angular Material):
```typescript
<mat-card>
  <mat-card-header>
    <mat-card-title>User Details</mat-card-title>
  </mat-card-header>
  <mat-card-content>
    <mat-form-field>
      <input matInput placeholder="Name" [(ngModel)]="user.name">
    </mat-form-field>
    <button mat-raised-button color="primary" (click)="save()">Save</button>
  </mat-card-content>
</mat-card>
```

## Risk Mitigation

1. **Parallel Development:**
   - Keep Nebular version running in production
   - Develop Angular Material version in parallel
   - Switch over only after thorough testing

2. **Feature Flags:**
   - Use feature flags to toggle between old and new components
   - Gradual rollout to users

3. **Rollback Plan:**
   - Keep Nebular dependencies until migration is complete
   - Maintain ability to rollback if critical issues arise

## Resources

- [Angular Material Documentation](https://material.angular.io/)
- [Angular Material Migration Guide](https://material.angular.io/guide/migration)
- [Material Design Guidelines](https://material.io/design)

---

**Last Updated:** November 5, 2025
