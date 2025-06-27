import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/utils/helpers/localization_helper.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'di/injector.dart';
import 'di/routes/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeepLink();
    });
  }

  void _initDeepLink() {
    // Handle initial deep link
    _appLinks.getInitialLink().then((uri) {
      if (uri != null && mounted) {
        print('Initial Deep Link: $uri');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleDeepLink(uri);
        });
      }
    });

    // Handle incoming deep links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null && mounted) {
        print('Deep Link Received: $uri');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleDeepLink(uri);
        });
      }
    }, onError: (err) {
      print('Deep Link Error: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'samarth' && (uri.host == 'auth' || uri.host == 'verify') && uri.pathSegments.contains('verify')) {
      final params = uri.queryParameters;
      final email = params['email'];
      final token = params['token'];
      final organizationSlug = params['organization'];

      print('Deep Link Params: email=$email, organizationSlug=$organizationSlug, token=$token');

      if (email != null && token != null && organizationSlug != null) {
        // Use navigator key to get context
        final context = _navigatorKey.currentContext;
        print('Deep Link Valid: Triggering VerifySignInLinkRequested');
        if (context != null && mounted) {
          context.read<AuthBloc>().add(VerifySignInLinkRequested(
            email: email,
            token: token,
            organizationSlug: organizationSlug,
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        // Add other BLoCs as needed (e.g., DashboardBloc)
      ],
      child: ChangeNotifierProvider.value(
        value: sl<LocaleProvider>(),
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return MaterialApp.router(
              key: _navigatorKey,
              title: 'Samarth eGov Employee',
              theme: AppTheme.lightTheme, // Use AppTheme.lightTheme
              locale: localeProvider.locale,
              supportedLocales: const [
                Locale('en', ''),
                Locale('hi', ''),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: createRouter(),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}