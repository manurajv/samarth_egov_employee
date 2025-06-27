import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
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
      create: (context) => sl.get<LeaveHistoryBloc>()
        ..add(const FetchLeaveHistory(
          email: 'manuraj.2024@iic.ac.in',
          organizationSlug: 'delhi-university',
        )),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            l10n.leaveHistoryTitle,
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
              child: BlocBuilder<LeaveHistoryBloc, LeaveHistoryState>(
                builder: (context, state) {
                  if (state is LeaveHistoryLoading) {
                    return const Center(child: LoadingIndicator(color: AppColors.primaryBlue));
                  }
                  if (state is LeaveHistoryLoaded) {
                    if (state.leaveHistory.isEmpty) {
                      return Center(
                        child: GlassCard(
                          blur: 0,
                          opacity: 1.0,
                          color: AppColors.lightGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l10n.noLeaveHistory,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.leaveHistory.length,
                      itemBuilder: (context, index) {
                        final leave = state.leaveHistory[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GlassCard(
                            blur: 0,
                            opacity: 1.0,
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        leave.leaveType,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: leave.status == 'Approved'
                                              ? AppColors.successGreen.withOpacity(0.2)
                                              : leave.status == 'Rejected'
                                              ? AppColors.errorRed.withOpacity(0.2)
                                              : AppColors.warningYellow.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: leave.status == 'Approved'
                                                ? AppColors.successGreen
                                                : leave.status == 'Rejected'
                                                ? AppColors.errorRed
                                                : AppColors.warningYellow,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          leave.status,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${l10n.fromDate}: ${DateFormat('dd MMM yyyy').format(leave.fromDate)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    '${l10n.toDate}: ${DateFormat('dd MMM yyyy').format(leave.toDate)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${l10n.reason}:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    leave.reason,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black,
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