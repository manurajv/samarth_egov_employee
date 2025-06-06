import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/otp_screen.dart';
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
        builder: (context, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: 'otp',
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                key: state.pageKey,
                child: OTPScreen(
                  verificationId: args['verificationId'],
                  email: args['email'],
                  organizationSlug: args['organizationSlug'], // Updated key
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
              child: const Scaffold(), // Replace with EditProfileScreen()
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
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}