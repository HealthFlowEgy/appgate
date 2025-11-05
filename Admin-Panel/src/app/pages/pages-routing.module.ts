import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';

import { PagesComponent } from './pages.component';
import { AuthGuard } from '../auth.guard';
import { ECommerceComponent } from './e-commerce/e-commerce.component';
import { RouteGuardService } from '../@core/utils/route-guard.service';

const routes: Routes = [{
  path: '',
  component: PagesComponent,
  children: [
    {
      path: 'dashboard',
      component: ECommerceComponent,
    },
    {
      path: 'users',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./users/users.module')
        .then(m => m.UsersModule),
    },
    {
      path: 'categories',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./categories/categories.module')
        .then(m => m.CategoriesModule),
    },
    {
      path: 'services',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./services/services.module')
        .then(m => m.ServicesModule),
    },
    {
      path: 'servicebookings',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./servicebookings/servicebookings.module')
        .then(m => m.ServicebookingsModule),
    },
    {
      path: 'banners',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./banners/banners.module')
        .then(m => m.BannersModule),
    },
    {
      path: 'coupons',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./coupons/coupons.module')
        .then(m => m.CouponsModule),
    },
    {
      path: 'providers',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./providers/providers.module')
        .then(m => m.ProvidersModule),
    },
    {
      path: 'medias',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./media/medias.module')
        .then(m => m.MediasModule),
    },
    {
      path: 'comments',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./comments/comments.module')
        .then(m => m.CommentsModule),
    },
    {
      path: 'appointments',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./appointments/appointments.module')
        .then(m => m.AppointmentsModule),
    },
    {
      path: 'plans',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./plans/plans.module')
        .then(m => m.PlansModule),
    },
    {
      path: 'transactions',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./transactions/transactions.module')
        .then(m => m.TransactionsModule),
    },
    {
      path: 'paymentmethods',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./paymentmethods/paymentmethods.module')
        .then(m => m.PaymentmethodsModule),
    },
    {
      path: 'faqs',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./faqs/faqs.module')
        .then(m => m.FaqsModule),
    },
    {
      path: 'supports',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./supports/support.module')
        .then(m => m.SupportsModule),
    },
    {
      path: 'projects',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./projects/projects.module')
        .then(m => m.ProjectsModule),
    },
    {
      path: 'buildings',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./buildings/buildings.module')
        .then(m => m.BuildingsModule),
    },
    {
      path: 'flats',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./flats/flats.module')
        .then(m => m.FlatsModule),
    },
    {
      path: 'announcements',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./announcements/announcements.module')
        .then(m => m.AnnouncementsModule),
    },
    {
      path: 'complaints',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./complaints/complaints.module')
        .then(m => m.ComplaintsModule),
    },
    {
      path: 'residents',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./residents/residents.module')
        .then(m => m.ResidentsModule),
    },
    {
      path: 'guards',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./guards/guards.module')
        .then(m => m.GuardsModule),
    },
    {
      path: 'visitorlogs',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./visitorlogs/visitorlogs.module')
        .then(m => m.VisitorlogsModule),
    },
    {
      path: 'preapprovedvehicles',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./preapprovedvehicles/preapprovedvehicles.module')
        .then(m => m.PreapprovedvehiclesModule),
    },
    {
      path: 'preapproveddailyhelp',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./preapproveddailyhelps/preapproveddailyhelps.module')
        .then(m => m.PreapproveddailyhelpsModule),
    },
    {
      path: 'amenities',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./amenities/amenities.module')
        .then(m => m.AmenitiesModule),
    },
    {
      path: 'paymentrequests',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./paymentrequests/paymentrequests.module')
        .then(m => m.PaymentrequestsModule),
    },
    {
      path: 'permissions',
      loadChildren: () => import('./permissions/permission.module')
        .then(m => m.PermissionsModule),
      canLoad: [RouteGuardService],
    },
    {
      path: 'settings',
      canLoad: [RouteGuardService],
      loadChildren: () => import('./settings/settings.module')
        .then(m => m.SettingsModule),
    },
    {
      path: '',
      redirectTo: 'dashboard',
      pathMatch: 'full',
    },
    {
      path: '**',
      redirectTo: 'dashboard',
    },
  ],
}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
    MaterialModule,
  exports: [RouterModule],
})
export class PagesRoutingModule {
}
