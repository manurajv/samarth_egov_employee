import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samarth_egov_employee/core/constants/app_colors.dart';
import 'package:samarth_egov_employee/core/widgets/glass_card.dart';
import 'package:samarth_egov_employee/core/widgets/language_switcher.dart';
import 'package:samarth_egov_employee/l10n/app_localizations.dart';
import '../../../../app/di/injector.dart';
import '../../data/models/dashboard_models.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<DashboardBloc>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(const LoadDashboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: false, // Use AppTheme's white app bar
      appBar: AppBar(
        title: Text(
          l10n.dashboardTitle,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: Colors.black, // Black title text
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: const [LanguageSwitcher()],
      ),
      body: Container(
        color: AppColors.accentWhite, // Pure white background
        child: BlocSelector<DashboardBloc, DashboardState, DashboardState>(
          selector: (state) => state,
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            }

            if (state is DashboardLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeader(context, state.employeeName),
                      const SizedBox(height: 16),
                      _buildLeaveBalanceWidget(context, state.leaveBalances),
                      const SizedBox(height: 16),
                      _buildServiceBookWidget(context, state.serviceRecords),
                      const SizedBox(height: 16),
                      _buildAppraisalsWidget(context, state.appraisals),
                      const SizedBox(height: 16),
                      _buildGrievancesWidget(context, state.grievances),
                      const SizedBox(height: 16),
                      _buildSalaryWidget(context, state.salarySlips),
                      if (kDebugMode)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'API: Multiple endpoints used',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: theme.elevatedButtonTheme.style,
                      onPressed: () => context.read<DashboardBloc>().add(const LoadDashboard()),
                      child: Text(l10n.retry, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text(
                l10n.unexpectedState,
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.accentWhite, // Solid white
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.primaryBlue.withOpacity(0.7),
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.userTie, size: 20),
            label: l10n.profile,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.calendarDays, size: 20),
            label: l10n.leaves,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.bookOpen, size: 20),
            label: l10n.serviceBook,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.chartLine, size: 20),
            label: l10n.appraisals,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.triangleExclamation, size: 20),
            label: l10n.grievances,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.indianRupeeSign, size: 20),
            label: l10n.salary,
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/profile');
              break;
            case 1:
              context.go('/dashboard/leaves/balance');
              break;
            case 2:
              context.go('/service-book');
              break;
            case 3:
              context.go('/appraisals');
              break;
            case 4:
              context.go('/grievances');
              break;
            case 5:
              context.go('/salary');
              break;
          }
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String employeeName) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      blur: 0, // Disabled blur
      opacity: 1.0, // Solid background
      color: AppColors.lightGrey, // Match AppTheme.cardTheme
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue, // Blue accent
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: AppColors.accentWhite,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeTitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.black, // Black text
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    employeeName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black, // Black text
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceWidget(BuildContext context, List<LeaveBalance> leaveBalances) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go('/dashboard/leaves/balance'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.calendarDays,
                    color: AppColors.primaryDarkBlue, // Blue accent
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.leaves,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black, // Black text
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              leaveBalances.isEmpty
                  ? Text(
                l10n.noLeaveData,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black, // Black text
                  fontSize: 16,
                ),
              )
                  : Column(
                children: leaveBalances.map((leave) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          leave.leaveType,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black, // Black text
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${leave.balance} ${l10n.days}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.successGreen, // Green for positive balance
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBookWidget(BuildContext context, List<ServiceRecord> serviceRecords) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go('/service-book'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bookOpen,
                    color: AppColors.primaryDarkBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.serviceBook,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              serviceRecords.isEmpty
                  ? Text(
                l10n.noServiceRecords,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
                  : Column(
                children: serviceRecords.take(2).map((record) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record.eventType,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          record.effectiveDate,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppraisalsWidget(BuildContext context, List<Appraisal> appraisals) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pendingCount = appraisals.where((a) => a.status == 'Pending').length;
    final submittedCount = appraisals.where((a) => a.status == 'Submitted').length;

    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go('/appraisals'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.chartLine,
                    color: AppColors.primaryDarkBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.appraisals,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              appraisals.isEmpty
                  ? Text(
                l10n.noAppraisalData,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.pendingAppraisals,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$pendingCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.submittedAppraisals,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$submittedCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrievancesWidget(BuildContext context, List<Grievance> grievances) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final openCount = grievances.where((g) => g.status == 'Open').length;
    final resolvedCount = grievances.where((g) => g.status == 'Resolved').length;

    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go('/grievances'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    color: AppColors.primaryDarkBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.grievances,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              grievances.isEmpty
                  ? Text(
                l10n.noGrievanceData,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.openGrievances,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$openCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.resolvedGrievances,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$resolvedCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryWidget(BuildContext context, List<SalarySlip> salarySlips) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final latestSalary = salarySlips.isNotEmpty ? salarySlips.last : null;

    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go('/salary'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.indianRupeeSign,
                    color: AppColors.primaryDarkBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.salary,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              latestSalary == null
                  ? Text(
                l10n.noSalaryData,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.latestSalary,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${latestSalary.amount.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.month,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        latestSalary.monthYear,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}