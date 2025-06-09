// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/common/app_button.dart';
// import '../../../../core/widgets/glass_card.dart';
// import '../../../../l10n/app_localizations.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
//
// class OTPScreen extends StatefulWidget {
//   final String email;
//   final String organizationSlug;
//
//   const OTPScreen({
//     super.key,
//     required this.email,
//     required this.organizationSlug,
//   });
//
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   Timer? _resendTimer;
//   int _resendTimeout = 60;
//
//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }
//
//   @override
//   void dispose() {
//     _resendTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startResendTimer() {
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendTimeout > 0) {
//         setState(() => _resendTimeout--);
//       } else {
//         _resendTimer?.cancel();
//       }
//     });
//   }
//
//   void _resendLink() {
//     setState(() => _resendTimeout = 60);
//     _startResendTimer();
//     context.read<AuthBloc>().add(
//       ResendEmailLinkRequested(
//         email: widget.email,
//         organizationSlug: widget.organizationSlug,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final l10n = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(l10n.emailLinkVerification),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.primaryDarkBlue.withOpacity(0.8),
//                 AppColors.primaryBlue.withOpacity(0.6),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppColors.primaryDarkBlue,
//               AppColors.primaryBlue,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: BlocConsumer<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//             if (state is AuthSuccess) {
//               context.go('/dashboard');
//             }
//             if (state is EmailLinkResent) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(l10n.emailLinkSent)),
//               );
//             }
//           },
//           builder: (context, state) {
//             return Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: GlassCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           l10n.checkEmail,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '${l10n.emailLinkSentTo} ${widget.email}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 32),
//                         AppButton(
//                           text: l10n.resendLink,
//                           onPressed: () {
//                             if (_resendTimeout == 0) {
//                               _resendLink();
//                             }
//                           },
//                           isLoading: state is AuthLoading,
//                         ),
//                         const SizedBox(height: 24),
//                         if (_resendTimeout > 0)
//                           Text(
//                             '${l10n.resendIn} $_resendTimeout',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: AppColors.accentBlue,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }