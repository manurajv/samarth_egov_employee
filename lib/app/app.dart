import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/helpers/localization_helper.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/leaves/presentation/bloc/leave_balance_bloc.dart';
import '../features/leaves/presentation/bloc/leave_bloc.dart';
import '../features/leaves/presentation/bloc/leave_form_bloc.dart';
import '../features/leaves/presentation/bloc/leave_history_bloc.dart';
import '../features/leaves/presentation/bloc/leave_status_bloc.dart';
import '../l10n/app_localizations.dart';
import 'di/injector.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl.get<LocaleProvider>(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl.get<AuthBloc>(),
              ),
              BlocProvider(
                create: (context) => sl.get<DashboardBloc>(),
              ),
              BlocProvider(
                create: (context) => sl.get<LeaveBloc>(),
              ),
              BlocProvider(
                create: (context) => sl.get<LeaveFormBloc>(),
              ),
              BlocProvider(create: (_) => sl.get<LeaveBalanceBloc>()),
              BlocProvider(create: (_) => sl.get<LeaveHistoryBloc>()),
              BlocProvider(create: (_) => sl.get<LeaveStatusBloc>()),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeProvider.locale,
              title: 'Samarth eGov',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
            ),
          );
        },
      ),
    );
  }
}