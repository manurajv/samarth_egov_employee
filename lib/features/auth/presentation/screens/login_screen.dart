import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load universities after frame to reduce main-thread work
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthBloc>().state is! UniversitiesLoaded) {
        context.read<AuthBloc>().add(const GetUniversitiesRequested());
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: Text('Localization not initialized')),
      );
    }

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
              constraints: BoxConstraints(maxWidth: size.width > 600 ? 600 : double.infinity),
              child: GlassCard(
                blur: 0, // Disabled blur for performance
                opacity: 0.2,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                        if (state is! UniversitiesLoaded) {
                          context.read<AuthBloc>().add(const GetUniversitiesRequested());
                        }
                      }
                      if (state is LinkSent) {
                        context.go('/login/verify', extra: {
                          'email': state.email,
                          'organizationSlug': state.organizationSlug,
                        });
                      }
                      if (state is AuthSuccess) {
                        context.go('/dashboard');
                      }
                    },
                    builder: (context, state) {
                      return BlocSelector<AuthBloc, AuthState, Map<String, String>>(
                        selector: (state) => state is UniversitiesLoaded ? state.universities : {},
                        builder: (context, universities) {
                          final universityNames = universities.keys.toList();
                          if (kDebugMode) {
                            print('Universities: $universityNames (State: $state)');
                          }

                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
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
                                Text(
                                  l10n.loginTitle,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                DropdownSearch<String>(
                                  items: (filter, infiniteScrollProps) async {
                                    return universityNames
                                        .where((u) => u.toLowerCase().contains(filter.toLowerCase()))
                                        .toList();
                                  },
                                  selectedItem: _organizationController.text.isNotEmpty ? _organizationController.text : null,
                                  onChanged: (value) {
                                    _organizationController.text = value ?? '';
                                  },
                                  validator: (value) => value == null || value.isEmpty ? l10n.organizationRequired : null,
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: l10n.organization,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 12),
                                        child: FaIcon(
                                          FontAwesomeIcons.building,
                                          size: 18,
                                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: theme.colorScheme.onBackground.withOpacity(0.1),
                                    ),
                                  ),
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        labelText: l10n.organization,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(left: 16, right: 12),
                                          child: FaIcon(
                                            FontAwesomeIcons.building,
                                            size: 18,
                                            color: theme.colorScheme.onBackground.withOpacity(0.7),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: theme.colorScheme.onBackground.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: l10n.email,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 12),
                                      child: FaIcon(
                                        FontAwesomeIcons.envelope,
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
                                    fillColor: theme.colorScheme.onBackground.withOpacity(0.1),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.emailRequired;
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return l10n.emailInvalid;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                AppButton(
                                  text: l10n.sendLink,
                                  backgroundColor: theme.primaryColor.withOpacity(0.9),
                                  foregroundColor: theme.colorScheme.onBackground,
                                  elevation: 4,
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      final organizationName = _organizationController.text.trim();
                                      final organizationSlug = universities[organizationName] ?? '';
                                      if (organizationSlug.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Invalid organization selected.'),
                                            backgroundColor: theme.colorScheme.error,
                                          ),
                                        );
                                        return;
                                      }
                                      context.read<AuthBloc>().add(
                                        SendSignInLinkRequested(
                                          email: _emailController.text.trim(),
                                          organizationSlug: organizationSlug,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}