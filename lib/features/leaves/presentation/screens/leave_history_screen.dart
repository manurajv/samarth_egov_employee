import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_appbar.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/leave_history_bloc.dart';

class LeaveHistoryScreen extends StatelessWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl.get<LeaveHistoryBloc>()..add(const FetchLeaveHistory()),
      child: Scaffold(
        appBar: AppAppBar(
          title: l10n.leaveHistoryTitle,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<LeaveHistoryBloc, LeaveHistoryState>(
              builder: (context, state) {
                if (state is LeaveHistoryLoading) {
                  return const Center(child: LoadingIndicator());
                }
                if (state is LeaveHistoryLoaded) {
                  return ListView.builder(
                    itemCount: state.leaveHistory.length,
                    itemBuilder: (context, index) {
                      final leave = state.leaveHistory[index];
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
                                    color: leave.status == 'Approved'
                                        ? AppColors.accentGreen
                                        : leave.status == 'Rejected'
                                        ? AppColors.accentRed
                                        : Colors.white,
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
                if (state is LeaveHistoryError) {
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