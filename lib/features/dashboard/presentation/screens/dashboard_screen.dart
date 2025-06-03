import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<DashboardBloc>()..add(const LoadDashboard()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.dashboardTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white, // Force white text
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
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (state is DashboardLoaded) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + kToolbarHeight,
                  16,
                  size.height > 800 ? 32 : 16,
                ),
                child: Column(
                  children: [
                    _buildWelcomeHeader(context, state.employeeName),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: size.width > 600 ? 3 : 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          _DashboardItem(
                            icon: FontAwesomeIcons.userTie,
                            label: l10n.profile,
                            gradient: _createGradient(0xFF6A11CB, 0xFF2575FC),
                            onTap: () => context.go('/profile'),
                          ),
                          _DashboardItem(
                            icon: FontAwesomeIcons.calendarDays,
                            label: l10n.leaves,
                            gradient: _createGradient(0xFF11998E, 0xFF38EF7D),
                            onTap: () => context.go('/leaves'),
                          ),
                          _DashboardItem(
                            icon: FontAwesomeIcons.bookOpen,
                            label: l10n.serviceBook,
                            gradient: _createGradient(0xFFFC4A1A, 0xFFF7B733),
                            onTap: () => context.go('/service-book'),
                          ),
                          if (size.width > 600) const SizedBox.shrink(),
                          _DashboardItem(
                            icon: FontAwesomeIcons.chartLine,
                            label: l10n.appraisals,
                            gradient: _createGradient(0xFF7F00FF, 0xFFE100FF),
                            onTap: () => context.go('/appraisals'),
                          ),
                          _DashboardItem(
                            icon: FontAwesomeIcons.triangleExclamation,
                            label: l10n.grievances,
                            gradient: _createGradient(0xFFED213A, 0xFF93291E),
                            onTap: () => context.go('/grievances'),
                          ),
                          _DashboardItem(
                            icon: FontAwesomeIcons.indianRupeeSign,
                            label: l10n.salary,
                            gradient: _createGradient(0xFF00B09B, 0xFF96C93D),
                            onTap: () => context.go('/salary'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              );
            }

            return Container(); // Fallback empty container
          },
        ),
      ),
    );
  }

  LinearGradient _createGradient(int color1, int color2) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(color1).withOpacity(0.8),
        Color(color2).withOpacity(0.8),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String employeeName) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      blur: 10,
      opacity: 0.15,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: Colors.white, // Force white icon
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8), // Force white text
                    ),
                  ),
                  Text(
                    employeeName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white, // Force white text
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

}

class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Gradient gradient;

  const _DashboardItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: GlassCard(
            blur: 8,
            opacity: 0.2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: gradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onBackground.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onBackground.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        icon,
                        size: 22,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}