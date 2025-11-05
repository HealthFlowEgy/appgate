import { NbMenuItem } from '@nebular/theme';

export const MENU_ITEMS: NbMenuItem[] = [
  {
    title: 'MENU.DASHBOARD',
    icon: 'activity-outline',
    link: '/pages/dashboard',
    data: { key: 'dashboard' }
  },
  {
    title: 'MENU.USERS',
    icon: 'person-outline',
    data: { key: 'users' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/users/add',
        data: { key: 'users/add' }
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/users/list',
        data: { key: 'users/list' }
      },
    ],
  },
  {
    title: 'MENU.CATEGORIES',
    icon: 'list-outline',
    data: { key: 'categories' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/categories/add',
        data: { key: 'categories/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/categories/list',
        data: { key: 'categories/list' },
      },
    ],
  },
  {
    title: 'MENU.SERVICES',
    icon: 'list-outline',
    data: { key: 'services' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/services/add',
        data: { key: 'services' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/services/list',
        data: { key: 'services/list' },
      },
    ],
  },
  {
    title: 'MENU.SERVICEBOOKINGS',
    icon: 'list-outline',
    data: { key: 'servicebookings' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/servicebookings/list',
        data: { key: 'servicebookings/list' },
      },
    ],
  },
  {
    title: 'MENU.PROJECTS',
    icon: 'list-outline',
    data: { key: 'projects' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/projects/add',
        data: { key: 'projects/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/projects/list',
        data: { key: 'projects/list' },
      },
    ],
  },
  {
    title: 'MENU.BUILDINGS',
    icon: 'list-outline',
    data: { key: 'buildings' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/buildings/add',
        data: { key: 'buildings/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/buildings/list',
        data: { key: 'buildings/list' },
      },
    ],
  },
  {
    title: 'MENU.FLATS',
    icon: 'list-outline',
    data: { key: 'flats' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/flats/add',
        data: { key: 'flats/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/flats/list',
        data: { key: 'flats/list' },
      },
    ],
  },
  {
    title: 'MENU.ANNOUNCEMENTS',
    icon: 'list-outline',
    data: { key: 'announcements' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/announcements/add',
        data: { key: 'announcements/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/announcements/list',
        data: { key: 'announcements/list' },
      },
    ],
  },
  {
    title: 'MENU.COMPLAINTS',
    icon: 'list-outline',
    data: { key: 'complaints' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/complaints/list',
        data: { key: 'complaints/list' },
      },
    ],
  },
  {
    title: 'MENU.COMPLAINTTYPES',
    icon: 'list-outline',
    data: { key: 'complainttypes' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/services/add',
        queryParams: {scope: 'complaint_type'},
        data: { key: 'services/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/services/complainttypes/list',
        data: { key: 'complainttypes/list' },
      },
    ],
  },
  {
    title: 'MENU.RESIDENTS',
    icon: 'list-outline',
    data: { key: 'residents' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/residents/add',
        data: { key: 'residents/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/residents/list',
        data: { key: 'residents/list' },
      },
    ],
  },
  {
    title: 'MENU.GUARDS',
    icon: 'list-outline',
    data: { key: 'guards' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/guards/add',
        data: { key: 'guards/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/guards/list',
        data: { key: 'guards/list' },
      },
    ],
  },
  {
    title: 'MENU.VISITORLOG',
    icon: 'list-outline',
    data: { key: 'visitorlogs' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/visitorlogs/list',
        data: { key: 'visitorlogs/list' },
      },
    ],
  },
  {
    title: 'MENU.PREAPPROVEDVEHICLES',
    icon: 'list-outline',
    data: { key: 'preapprovedvehicles' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/preapprovedvehicles/list',
        data: { key: 'preapprovedvehicles/list' },
      },
    ],
  },
  {
    title: 'MENU.PREAPPROVEDDAILYHELP',
    icon: 'list-outline',
    data: { key: 'preapproveddailyhelp' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/preapproveddailyhelp/list',
        data: { key: 'preapproveddailyhelp/list' },
      },
    ],
  },
  {
    title: 'MENU.AMENITIES',
    icon: 'list-outline',
    data: { key: 'amenities' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/amenities/add',
        data: { key: 'amenities/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/amenities/list',
        data: { key: 'amenities/list' },
      },
    ],
  },
  // {
  //   title: 'MENU.BANNERS',
  //   icon: 'flag-outline',
  //   children: [
  //     {
  //       title: 'MENU.ADD_NEW',
  //       link: '/pages/banners/add',
  //     },
  //     {
  //       title: 'MENU.VIEW_ALL',
  //       link: '/pages/banners/list',
  //     },
  //   ],
  // },
  {
    title: 'MENU.COMMENTS',
    icon: 'flag-outline',
    data: { key: 'comments' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/comments/list',
        data: { key: 'comments/list' },
      },
    ],
  },
  {
    title: 'MENU.MEDIA',
    icon: 'flag-outline',
    data: { key: 'medias' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/medias/add',
        data: { key: 'medias/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/medias/list',
        data: { key: 'medias/list' },
      },
    ],
  },
  {
    title: 'MENU.APPOINTMENTS',
    icon: 'calendar-outline',
    data: { key: 'appointments' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/appointments/list',
        data: { key: 'appointments/list' },
      },
    ],
  },
  {
    title: 'MENU.TRANSACTIONS',
    icon: 'layers-outline',
    data: { key: 'transactions' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/transactions/list',
        data: { key: 'transactions/list' },
      },
    ],
  },
  {
    title: 'MENU.PAYMENT_REQUESTS',
    icon: 'credit-card-outline',
    data: { key: 'paymentrequests' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/paymentrequests/add',
        data: { key: 'paymentrequests/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/paymentrequests/list',
        data: { key: 'paymentrequests/list' },
      },
    ],
  },
  {
    title: 'MENU.PAYMENT_METHODS',
    icon: 'credit-card-outline',
    data: { key: 'paymentmethods' },
    children: [
      {
        title: 'MENU.ADD_NEW',
        link: '/pages/paymentmethods/add',
        data: { key: 'paymentmethods/add' },
      },
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/paymentmethods/list',
        data: { key: 'paymentmethods/list' },
      },
    ],
  },
  // {
  //   title: 'MENU.FAQS',
  //   icon: 'question-mark-circle-outline',
  //   data: { key: 'faqs' },
  //   children: [
  //     {
  //       title: 'MENU.ADD_NEW',
  //       link: '/pages/faqs/add',
  //       data: { key: 'faqs/add' },
  //     },
  //     {
  //       title: 'MENU.VIEW_ALL',
  //       link: '/pages/faqs/list',
  //       data: { key: 'faqs/list' },
  //     },
  //   ],
  // },
  {
    title: 'MENU.SUPPORT',
    icon: 'phone-call-outline',
    data: { key: 'supports' },
    children: [
      {
        title: 'MENU.VIEW_ALL',
        link: '/pages/supports/list',
        data: { key: 'supports/list' },
      },
    ],
  },
  {
    title: 'Admin Permissions',
    icon: 'list-outline',
    data: { key: 'permissions' },
    children: [
      {
        title: 'Add New',
        link: '/pages/permissions/add',
        data: { key: 'permissions/add' },
      },
      {
        title: 'View All',
        link: '/pages/permissions/list',
        data: { key: 'permissions/list' },
      },
    ]
  },
  {
    title: 'MENU.SETTINGS',
    icon: 'settings-outline',
    data: { key: 'settings' },
    children: [
      {
        title: 'MENU.APPLICATION',
        link: '/pages/settings/edit',
        data: { key: 'settings/edit' },
      },
      {
        title: 'MENU.SYSTEM',
        link: '/pages/settings/system',
        data: { key: 'settings/system' },
      }
    ],
  },
];
