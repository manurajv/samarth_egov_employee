import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_appbar.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/leave_balance_bloc.dart';

class LeaveBalanceScreen extends StatelessWidget {
  const LeaveBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) {
        final bloc = sl.get<LeaveBalanceBloc>();
        bloc.add(const FetchLeaveBalances());
        return bloc;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppAppBar(
          title: l10n.leaveBalanceTitle,
          showBackButton: true,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.gradientStart,
                AppColors.gradientEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<LeaveBalanceBloc, LeaveBalanceState>(
                builder: (context, state) {
                  if (state is LeaveBalanceInitial || state is LeaveBalanceLoading) {
                    return const Center(child: LoadingIndicator());
                  }
                  if (state is LeaveBalanceLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.leaveBalanceTitle,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.accentWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...state.leaveBalances.map((balance) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GlassCard(
                              blur: 10,
                              opacity: 0.15,
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      balance.leaveType,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.accentWhite,
                                      ),
                                    ),
                                    Text(
                                      '${l10n.available}: ${balance.availableDays} ${l10n.days}',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.accentGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.go('/dashboard/leaves/apply');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: AppColors.accentWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(l10n.applyLeave),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.go('/dashboard/leaves/history');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: AppColors.accentWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(l10n.viewHistory),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.go('/dashboard/leaves/status');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: AppColors.accentWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(l10n.viewStatus),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is LeaveBalanceError) {
                    return Center(
                      child: Text(
                        state.error,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.accentWhite,
                        ),
                      ),
                    );
                  }
                  return const Center(child: SizedBox());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}