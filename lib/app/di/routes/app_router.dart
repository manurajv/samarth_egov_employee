import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/screens/forgot_pwd_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/otp_screen.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ForgotPasswordScreen(),
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
            path: 'otp',
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                key: state.pageKey,
                child: OTPScreen(
                  verificationId: args['verificationId'],
                  phoneNumber: args['phoneNumber'],
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