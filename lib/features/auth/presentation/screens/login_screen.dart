import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguageSwitcher()],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.colorScheme.secondary.withOpacity(0.9),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              constraints: BoxConstraints(maxWidth: size.width > 600 ? 500 : double.infinity),
              child: GlassCard(
                blur: 15,
                opacity: 0.2,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Logo
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onBackground.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.onBackground.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.userShield,
                              size: 36,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title with subtle animation
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            l10n.loginTitle,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Employee ID Field
                        _buildTextField(
                          context,
                          controller: _employeeIdController,
                          label: l10n.employeeId,
                          icon: FontAwesomeIcons.idCard,
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.employeeIdRequired
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        _buildTextField(
                          context,
                          controller: _passwordController,
                          label: l10n.password,
                          icon: FontAwesomeIcons.lock,
                          obscureText: true,
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.passwordRequired
                              : null,
                        ),
                        const SizedBox(height: 32),

                        // Login Button with Bloc
                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                            if (state is AuthSuccess) {
                              context.go('/dashboard');
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return SizedBox(
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.onBackground,
                                  ),
                                ),
                              );
                            }
                            return AppButton(
                              text: l10n.login,
                              backgroundColor: theme.primaryColor.withOpacity(0.9),
                              foregroundColor: theme.colorScheme.onBackground,
                              elevation: 4,
                              //borderRadius: 12,
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<AuthBloc>().add(
                                    LoginRequested(
                                      _employeeIdController.text,
                                      _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Forgot Password
                        TextButton(
                          onPressed: () => context.push('/login/forgot-password'), // Updated navigation
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.onBackground.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.forgotPassword,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required IconData icon,
        bool obscureText = false,
        String? Function(String?)? validator,
      }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: theme.colorScheme.onBackground,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onBackground.withOpacity(0.8),
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: FaIcon(
            icon,
            size: 18,
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.onBackground.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }
}