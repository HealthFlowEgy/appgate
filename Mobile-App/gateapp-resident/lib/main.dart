import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gateapp_user/bloc/chat_cubit.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/pages/secondary_splash_page.dart';
import 'package:gateapp_user/pages/my_residency_page.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/toaster.dart';
import 'bloc/app_cubit.dart';
import 'bloc/fetcher_visitor_logs_cubit.dart';
import 'bloc/language_cubit.dart';
import 'config/app_theme.dart';
import 'config/localization/app_localization.dart';
import 'pages/auth_sign_in_page.dart';
import 'pages/bottom_navigation_page.dart';
import 'pages/language_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LanguageCubit()),
      BlocProvider(create: (context) => AppCubit()),
      BlocProvider(create: (context) => FetcherVisitorLogsCubit()),
      BlocProvider(create: (context) => ChatCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).initApp();
    BlocProvider.of<LanguageCubit>(context).getCurrentLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalization.getSupportedLocales(),
          locale: locale,
          theme: AppTheme.appTheme,
          home: BlocConsumer<AppCubit, AppState>(
            listener: (context, appState) {
              if (appState is Unauthenticated && appState.isProfileIssue) {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("something_wrong_profile"));
              }
              if (appState is Authenticated && appState.isProfileComplete) {
                BlocProvider.of<FetcherVisitorLogsCubit>(context)
                    .initFetchVisitorLogs(tabType: "waiting");
              }
            },
            builder: (context, appState) {
              switch (appState.runtimeType) {
                case Authenticated:
                  return (appState as Authenticated).isDemoShowLangs
                      ? const LanguagePage(fromRoot: true)
                      : appState.isProfileComplete
                          ? const BottomNavigationPage()
                          : const MyResidencyPage(fromRoot: true);
                case Unauthenticated:
                  return (appState as Unauthenticated).isDemoShowLangs
                      ? const LanguagePage(fromRoot: true)
                      : const AuthSignInPage();
                case FailureState:
                  return ErrorFinalWidget.errorWithRetry(
                    context: context,
                    message: AppLocalization.instance
                        .getLocalizationFor("network_issue"),
                    actionText:
                        AppLocalization.instance.getLocalizationFor("okay"),
                    action: () => SystemNavigator.pop(),
                  );
                default:
                  return const SecondarySplashPage();
              }
            },
          ),
          routes: PageRoutes().routes(),
        ),
      );
}
