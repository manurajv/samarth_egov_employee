import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injector.dart';
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            l10n.leaveStatusTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor.withOpacity(0.95),
                theme.colorScheme.secondary.withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + kToolbarHeight,
                16,
                16,
              ),
              child: BlocBuilder<LeaveStatusBloc, LeaveStatusState>(
                builder: (context, state) {
                  if (state is LeaveStatusLoading) {
                    return const Center(child: LoadingIndicator());
                  }

                  if (state is LeaveStatusLoaded) {
                    if (state.leaveStatuses.isEmpty) {
                      return Center(
                        child: GlassCard(
                          blur: 10,
                          opacity: 0.15,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l10n.noPendingLeaves,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.leaveStatuses.length,
                      itemBuilder: (context, index) {
                        final leave = state.leaveStatuses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GlassCard(
                            blur: 10,
                            opacity: 0.15,
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.orangeAccent,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          leave.status,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${l10n.fromDate}: ${DateFormat('dd MMM yyyy').format(leave.fromDate)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    '${l10n.toDate}: ${DateFormat('dd MMM yyyy').format(leave.toDate)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${l10n.reason}:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    leave.reason,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
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
                      child: GlassCard(
                        blur: 10,
                        opacity: 0.15,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.error,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
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