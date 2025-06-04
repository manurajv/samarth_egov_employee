import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_appbar.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/leave_status_bloc.dart';

class LeaveStatusScreen extends StatelessWidget {
  const LeaveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
      sl.get<LeaveStatusBloc>()..add(const FetchLeaveStatuses()),
      child: Scaffold(
        appBar: AppAppBar(
          title: l10n.leaveStatusTitle,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<LeaveStatusBloc, LeaveStatusState>(
              builder: (context, state) {
                if (state is LeaveStatusLoading) {
                  return const Center(child: LoadingIndicator());
                }

                if (state is LeaveStatusLoaded) {
                  if (state.leaveStatuses.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noPendingLeaves,
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.leaveStatuses.length,
                    itemBuilder: (context, index) {
                      final leave = state.leaveStatuses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leave.leaveType,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n.fromDate}: ${DateFormat('dd MMM yyyy').format(leave.fromDate)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  '${l10n.toDate}: ${DateFormat('dd MMM yyyy').format(leave.toDate)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n.reason}: ${leave.reason}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n.status}: ${leave.status}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.accentYellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is LeaveStatusError) {
                  return Center(
                    child: Text(
                      state.error,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
