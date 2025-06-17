import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.dashboardTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: const [LanguageSwitcher()],
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
        child: BlocSelector<DashboardBloc, DashboardState, DashboardState>(
          selector: (state) => state,
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (state is DashboardLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeader(context, state.employeeName),
                      const SizedBox(height: 8),
                      _buildProfileWidget(context, state.profileCompletion),
                      const SizedBox(height: 8),
                      _buildLeaveBalanceWidget(context, state.leaveBalances),
                      const SizedBox(height: 8),
                      _buildServiceBookWidget(context, state.serviceRecords),
                      const SizedBox(height: 8),
                      _buildAppraisalsWidget(context, state.appraisals),
                      const SizedBox(height: 8),
                      _buildGrievancesWidget(context, state.grievances),
                      const SizedBox(height: 8),
                      _buildSalaryWidget(context, state.salarySlips),
                      if (kDebugMode)
                        const Text(
                          'API: https://user1749627892472.requestly.tech/delhi-university/employee',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
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
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<DashboardBloc>().add(const LoadDashboard()),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text(
                l10n.unexpectedState,
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.primaryColor.withOpacity(0.9),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.userTie),
            label: l10n.profile,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.calendarDays),
            label: l10n.leaves,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.bookOpen),
            label: l10n.serviceBook,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.chartLine),
            label: l10n.appraisals,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.triangleExclamation),
            label: l10n.grievances,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.indianRupeeSign),
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
      blur: 2,
      opacity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.colorScheme.secondary],
                ),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    employeeName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildProfileWidget(BuildContext context, double profileCompletion) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/profile'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profile,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Center(
                child: CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: profileCompletion / 100,
                  center: Text(
                    '${profileCompletion.toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  progressColor: Colors.blue,
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceWidget(BuildContext context, List<LeaveBalance> leaveBalances) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/dashboard/leaves/balance'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.leaves,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: leaveBalances.isEmpty
                    ? const Center(
                  child: Text(
                    'No leave data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: leaveBalances
                        .asMap()
                        .entries
                        .map((e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.balance.toDouble(),
                          color: Colors.green,
                          width: 15,
                        ),
                      ],
                    ))
                        .toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            leaveBalances[value.toInt()].leaveType,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBookWidget(BuildContext context, List<ServiceRecord> serviceRecords) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/service-book'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.serviceBook,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              serviceRecords.isEmpty
                  ? const SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    'No service records available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
                  : SizedBox(
                height: 80,
                child: Column(
                  children: serviceRecords.take(2).map((record) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${record.eventType} - ${record.effectiveDate}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppraisalsWidget(BuildContext context, List<Appraisal> appraisals) {
    final l10n = AppLocalizations.of(context)!;
    final statusCounts = {
      'Pending': appraisals.where((a) => a.status == 'Pending').length.toDouble(),
      'Submitted': appraisals.where((a) => a.status == 'Submitted').length.toDouble(),
    };

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/appraisals'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appraisals,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: statusCounts.values.every((v) => v == 0)
                    ? const Center(
                  child: Text(
                    'No appraisal data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : PieChart(
                  PieChartData(
                    sections: statusCounts.entries
                        .where((e) => e.value > 0)
                        .map((e) => PieChartSectionData(
                      value: e.value,
                      color: e.key == 'Pending' ? Colors.red : Colors.green,
                      title: e.key,
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ))
                        .toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrievancesWidget(BuildContext context, List<Grievance> grievances) {
    final l10n = AppLocalizations.of(context)!;
    final statusCounts = {
      'Open': grievances.where((g) => g.status == 'Open').length.toDouble(),
      'Resolved': grievances.where((g) => g.status == 'Resolved').length.toDouble(),
    };
    final entries = statusCounts.entries.toList();

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/grievances'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.grievances,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: statusCounts.values.every((v) => v == 0)
                    ? const Center(
                  child: Text(
                    'No grievance data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: entries
                        .asMap()
                        .entries
                        .map((e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.value,
                          color: e.key == 0 ? Colors.red : Colors.green,
                          width: 15,
                        ),
                      ],
                    ))
                        .toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            statusCounts.keys.elementAt(value.toInt()),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryWidget(BuildContext context, List<SalarySlip> salarySlips) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      blur: 2,
      opacity: 0.2,
      child: InkWell(
        onTap: () => context.go('/salary'),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.salary,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: salarySlips.isEmpty
                    ? const Center(
                  child: Text(
                    'No salary data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: salarySlips
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value.amount))
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            salarySlips[value.toInt()].monthYear,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}