/**
 * @license
 * Copyright Akveo. All Rights Reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 */
// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,
  apiUrl: 'http://localhost:8000/api',
  apiBaseUrl: 'http://localhost:8000',
  appName: 'AppsGate Admin (Dev)',
  version: '1.0.0-dev',
  
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
    enableAnalytics: false,
    enableErrorReporting: false,
    enableDebugMode: true
  }
};
