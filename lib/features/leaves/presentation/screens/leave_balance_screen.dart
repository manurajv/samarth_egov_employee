import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_button.dart';
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
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) {
        final bloc = sl.get<LeaveBalanceBloc>();
        bloc.add(const FetchLeaveBalances(
          email: 'manuraj.2024@iic.ac.in',
          organizationSlug: 'delhi-university',
        ));
        return bloc;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            l10n.leaveBalanceTitle,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: AppColors.primaryDarkBlue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          color: AppColors.accentWhite,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<LeaveBalanceBloc, LeaveBalanceState>(
                builder: (context, state) {
                  if (state is LeaveBalanceInitial || state is LeaveBalanceLoading) {
                    return const Center(child: LoadingIndicator(color: AppColors.primaryBlue));
                  }
                  if (state is LeaveBalanceLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...state.leaveBalances.map((balance) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GlassCard(
                                    blur: 0,
                                    opacity: 1.0,
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            balance.leaveType,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${l10n.available}: ${balance.availed} ${l10n.days}',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: AppColors.successGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              AppButton(
                                text: l10n.applyLeave,
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.accentWhite,
                                onPressed: () {
                                  context.go('/dashboard/leaves/apply');
                                },
                              ),
                              AppButton(
                                text: l10n.viewHistory,
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.accentWhite,
                                onPressed: () {
                                  context.go('/dashboard/leaves/history');
                                },
                              ),
                              AppButton(
                                text: l10n.viewStatus,
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.accentWhite,
                                onPressed: () {
                                  context.go('/dashboard/leaves/status');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is LeaveBalanceError) {
                    return Center(
                      child: GlassCard(
                        blur: 0,
                        opacity: 1.0,
                        color: AppColors.lightGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.error,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}