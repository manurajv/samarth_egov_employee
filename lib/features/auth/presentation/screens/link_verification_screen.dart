import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class LinkVerificationScreen extends StatefulWidget {
  final String email;
  final String organizationSlug;

  const LinkVerificationScreen({
    super.key,
    required this.email,
    required this.organizationSlug,
  });

  @override
  State<LinkVerificationScreen> createState() => _LinkVerificationScreenState();
}

class _LinkVerificationScreenState extends State<LinkVerificationScreen> {
  StreamSubscription? _linkSubscription;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    // Listen for incoming deep links
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing link: $err')),
      );
    });

    // Check initial link
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    final email = uri.queryParameters['email'];
    final organizationSlug = uri.queryParameters['organization'];
    if (email == widget.email && organizationSlug == widget.organizationSlug) {
      context.read<AuthBloc>().add(
        VerifySignInLinkRequested(
          email: widget.email,
          organizationSlug: widget.organizationSlug,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid verification link')),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _handleCancel() {
    // Reset the auth bloc when going back to login
    context.read<AuthBloc>().add(GetUniversitiesRequested());
    context.go('/login');
  }

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
              constraints: BoxConstraints(maxWidth: size.width > 600 ? 600 : double.infinity),
              child: GlassCard(
                blur: 15,
                opacity: 0.2,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                      if (state is AuthSuccess) {
                        context.go('/dashboard');
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                FontAwesomeIcons.envelopeOpenText,
                                size: 36,
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                              l10n.linkVerificationTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.linkSentTo(widget.email),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.checkEmailInstructions,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          AppButton(
                            text: l10n.resendLink,
                            backgroundColor: theme.primaryColor.withOpacity(0.9),
                            foregroundColor: theme.colorScheme.onBackground,
                            elevation: 4,
                            isLoading: state is AuthLoading && state is! AuthSuccess,
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                SendSignInLinkRequested(
                                  email: widget.email,
                                  organizationSlug: widget.organizationSlug,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => _handleCancel(),
                            child: Text(
                              l10n.cancel,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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