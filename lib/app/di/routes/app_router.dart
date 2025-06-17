import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/screens/link_verification_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/leaves/presentation/screens/leave_apply_screen.dart';
import '../../../features/leaves/presentation/screens/leave_balance_screen.dart';
import '../../../features/leaves/presentation/screens/leave_history_screen.dart';
import '../../../features/leaves/presentation/screens/leave_status_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'verify',
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>? ?? {};
              return CustomTransitionPage(
                key: state.pageKey,
                child: LinkVerificationScreen(
                  email: args['email'] as String? ?? '',
                  organizationSlug: args['organizationSlug'] as String? ?? '',
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: 'leaves',
            builder: (context, state) => const LeaveBalanceScreen(),
            routes: [
              GoRoute(
                path: 'apply',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const LeaveApplyScreen(),
                  fullscreenDialog: true,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
              GoRoute(
                path: 'balance',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const LeaveBalanceScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
              GoRoute(
                path: 'history',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const LeaveHistoryScreen(),
                  fullscreenDialog: true,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
              GoRoute(
                path: 'status',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const LeaveStatusScreen(),
                  fullscreenDialog: true,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const Scaffold(body: Center(child: Text('Edit Profile Screen'))),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/service-book',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Center(child: Text('Service Book Screen'))),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/appraisals',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Center(child: Text('Appraisals Screen'))),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/grievances',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Center(child: Text('Grievances Screen'))),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/salary',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Center(child: Text('Salary Screen'))),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}