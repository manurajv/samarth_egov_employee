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
  Timer? _timer;
  int _remainingSeconds = 600;

  @override
  void initState() {
    super.initState();
    print('LinkVerificationScreen init: email=${widget.email}, organizationSlug=${widget.organizationSlug}');
    FocusManager.instance.primaryFocus?.unfocus();
    _initDeepLinkListener();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {});
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _initDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && mounted) {
        print('Deep Link Received: $uri');
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Deep Link Error: $err');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing link: $err')),
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _appLinks.getInitialLink().then((Uri? uri) {
          if (uri != null) {
            print('Initial Deep Link: $uri');
            _handleDeepLink(uri);
          }
        });
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    final email = Uri.decodeQueryComponent(uri.queryParameters['email'] ?? '');
    final organizationSlug = Uri.decodeQueryComponent(uri.queryParameters['organization'] ?? '');
    final token = Uri.decodeQueryComponent(uri.queryParameters['token'] ?? '');
    print('Deep Link Params: email=$email, organizationSlug=$organizationSlug, token=$token');

    if (email.isEmpty || organizationSlug.isEmpty || token.isEmpty) {
      final missing = [
        if (email.isEmpty) 'email',
        if (organizationSlug.isEmpty) 'organization',
        if (token.isEmpty) 'token'
      ].join(', ');
      print('Deep Link Invalid: Missing $missing');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid verification link: Missing $missing. Please check the email again.'),
          action: SnackBarAction(
            label: 'Resend',
            onPressed: () {
              print('Resend Link from SnackBar');
              context.read<AuthBloc>().add(
                SendSignInLinkRequested(
                  email: widget.email,
                  organizationSlug: widget.organizationSlug,
                ),
              );
              setState(() {
                _remainingSeconds = 600;
                _startTimer();
              });
            },
          ),
        ),
      );
      return;
    }

    if (email != widget.email || organizationSlug != widget.organizationSlug) {
      print('Deep Link Invalid: Mismatch (expected email=${widget.email}, org=${widget.organizationSlug})');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification link: Email or organization mismatch')),
      );
      return;
    }

    print('Deep Link Valid: Triggering VerifySignInLinkRequested');
    context.read<AuthBloc>().add(
      VerifySignInLinkRequested(
        email: widget.email,
        organizationSlug: widget.organizationSlug,
        token: token,
      ),
    );
  }

  @override
  void dispose() {
    print('LinkVerificationScreen dispose');
    _linkSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _handleCancel() {
    print('Cancel pressed: Navigating to /login');
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
                blur: 0,
                opacity: 0.2,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      print('AuthBloc State: $state');
                      if (state is AuthError) {
                        print('AuthError: ${state.message}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                      if (state is AuthSuccess) {
                        print('AuthSuccess: Navigating to /dashboard');
                        context.go('/dashboard');
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
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
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.envelopeOpenText,
                                size: 36,
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
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.linkSentTo(widget.email),
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          _remainingSeconds > 0
                              ? Text(
                            l10n.verificationTimeRemaining(_formatTime(_remainingSeconds)),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          )
                              : Text(
                            l10n.verificationExpired,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
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
                            isLoading: isLoading,
                            onPressed: () {
                              print('Resend Link pressed');
                              context.read<AuthBloc>().add(
                                SendSignInLinkRequested(
                                  email: widget.email,
                                  organizationSlug: widget.organizationSlug,
                                ),
                              );
                              setState(() {
                                _remainingSeconds = 600;
                                _startTimer();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _handleCancel,
                            child: Text(
                              l10n.cancel,
                              style: const TextStyle(
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