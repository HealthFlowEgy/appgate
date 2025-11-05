/**
 * @license
 * Copyright Akveo. All Rights Reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 */
export const environment = {
  production: true,
  apiUrl: 'https://api.your-domain.com/api',
  apiBaseUrl: 'https://api.your-domain.com',
  appName: 'AppsGate Admin',
  version: '1.0.0',
  
  // Firebase configuration (if used)
  firebase: {
    apiKey: '',
    authDomain: '',
    projectId: '',
    storageBucket: '',
    messagingSenderId: '',
    appId: ''
  },
  
  // Feature flags
  features: {
    enableAnalytics: true,
    enableErrorReporting: true,
    enableDebugMode: false
  }
};
