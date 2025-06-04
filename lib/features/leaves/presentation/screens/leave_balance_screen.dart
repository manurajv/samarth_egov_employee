import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
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
        bloc.add(const FetchLeaveBalances());
        return bloc;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            l10n.leaveBalanceTitle,
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
              child: BlocBuilder<LeaveBalanceBloc, LeaveBalanceState>(
                builder: (context, state) {
                  if (state is LeaveBalanceInitial || state is LeaveBalanceLoading) {
                    return const Center(child: LoadingIndicator());
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
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${l10n.available}: ${balance.availableDays} ${l10n.days}',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.greenAccent,
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
                                //width: size.width > 600 ? null : double.infinity,
                                backgroundColor: theme.primaryColor.withOpacity(0.9),
                                foregroundColor: Colors.white,
                                onPressed: () {
                                  context.go('/dashboard/leaves/apply');
                                },
                              ),
                              AppButton(
                                text: l10n.viewHistory,
                                //width: size.width > 600 ? null : double.infinity,
                                backgroundColor: theme.primaryColor.withOpacity(0.9),
                                foregroundColor: Colors.white,
                                onPressed: () {
                                  context.go('/dashboard/leaves/history');
                                },
                              ),
                              AppButton(
                                text: l10n.viewStatus,
                                //width: size.width > 600 ? null : double.infinity,
                                backgroundColor: theme.primaryColor.withOpacity(0.9),
                                foregroundColor: Colors.white,
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