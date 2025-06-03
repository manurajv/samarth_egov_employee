import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/otp_field.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with CodeAutoFill {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  Timer? _resendTimer;
  int _resendTimeout = 60;
  bool _isLoadingSignature = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _getAppSignature();
    _startResendTimer();
    listenForCode();
  }

  @override
  void dispose() {
    _disposeControllers();
    _resendTimer?.cancel();
    cancel();
    super.dispose();
  }

  void _initializeControllers() {
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  void _disposeControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
  }

  Future<void> _getAppSignature() async {
    setState(() => _isLoadingSignature = true);
    try {
      // Implement app signature retrieval if needed
    } catch (e) {
      debugPrint('Error getting app signature: $e');
    } finally {
      setState(() => _isLoadingSignature = false);
    }
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() => _resendTimeout--);
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  void _resendOTP() {
    setState(() => _resendTimeout = 60);
    _startResendTimer();
    context.read<AuthBloc>().add(ResendOTPRequested(widget.phoneNumber));
  }

  void _verifyOTP() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      context.read<AuthBloc>().add(
        VerifyOTPRequested(
          verificationId: widget.verificationId,
          otp: otp,
        ),
      );
    }
  }

  @override
  void codeUpdated() {
    final code = this.code;
    if (code != null && code.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = code[i];
        if (i == 5) {
          _focusNodes[i].unfocus();
          _verifyOTP();
        } else {
          _focusNodes[i + 1].requestFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDarkBlue.withOpacity(0.8),
                AppColors.primaryBlue.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDarkBlue,
              AppColors.primaryBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sent to ${widget.phoneNumber}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return OTPField(
                              controller: _controllers[index],
                              autoFocus: index == 0,
                              onChanged: (value) {
                                if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                                if (index == 5 && value.isNotEmpty) {
                                  _verifyOTP();
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        if (_isLoadingSignature)
                          const LoadingIndicator()
                        else
                          AppButton(
                            text: 'Verify OTP',
                            onPressed: _verifyOTP,
                            isLoading: state is AuthLoading,
                          ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive code? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            if (_resendTimeout > 0)
                              Text(
                                'Resend in $_resendTimeout',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.accentBlue,
                                ),
                              )
                            else
                              TextButton(
                                onPressed: _resendOTP,
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.accentBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}