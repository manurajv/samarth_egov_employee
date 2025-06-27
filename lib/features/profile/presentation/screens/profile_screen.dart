import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/profile/detail_row.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<ProfileBloc>()..add(LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            l10n.profile,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
            onPressed: () => context.go('/dashboard'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryDarkBlue),
              onPressed: () => context.go('/profile/edit'),
            ),
          ],
        ),
        body: Container(
          color: AppColors.accentWhite,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              print('Bloc state: $state');
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                );
              }
              if (state is ProfileLoaded) {
                print('Rendering ProfileLoaded with profile: ${state.profile.fullName}');
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildProfileHeader(context, state.profile),
                          const SizedBox(height: 24),
                          _buildProfileTabs(context, state.profile),
                        ]),
                      ),
                    ),
                  ],
                );
              }
              if (state is ProfileError) {
                if (state.message.contains('Unauthorized') || state.message.contains('Missing')) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/login');
                  });
                  return const SizedBox.shrink();
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: theme.elevatedButtonTheme.style,
                        onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.1),
                border: Border.all(color: AppColors.primaryDarkBlue, width: 2),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: AppColors.primaryDarkBlue,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.designation,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    profile.department,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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

  Widget _buildProfileTabs(BuildContext context, ProfileEntity profile) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          GlassCard(
            blur: 0,
            opacity: 1.0,
            color: AppColors.lightGrey,
            child: TabBar(
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: AppColors.primaryBlue,
              ),
              labelColor: AppColors.accentWhite,
              unselectedLabelColor: AppColors.darkGrey,
              tabs: const [
                Tab(text: 'Personal'),
                Tab(text: 'Service'),
                Tab(text: 'Family'),
                Tab(text: 'Address'),
                Tab(text: 'Bank'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: TabBarView(
              children: [
                _KeepAliveTab(child: _buildPersonalTab(context, profile)),
                _KeepAliveTab(child: _buildServiceTab(context, profile)),
                _KeepAliveTab(child: _buildFamilyTab(context, profile)),
                _KeepAliveTab(child: _buildAddressTab(context, profile)),
                _KeepAliveTab(child: _buildBankTab(context, profile)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(BuildContext context, ProfileEntity profile) {
    print('Personal tab data: dob=${profile.dob}, gender=${profile.gender}');
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Employee ID',
              value: profile.employeeId,
              isImportant: true,
              icon: FontAwesomeIcons.idCard,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Date of Birth',
              value: profile.dob,
              icon: FontAwesomeIcons.cakeCandles,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Gender',
              value: profile.gender,
              icon: FontAwesomeIcons.venusMars,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Blood Group',
              value: profile.bloodGroup,
              icon: FontAwesomeIcons.droplet,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Category',
              value: profile.category,
              icon: FontAwesomeIcons.userTag,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Religion',
              value: profile.religion,
              icon: FontAwesomeIcons.pray,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Aadhar Number',
              value: profile.aadharNumber,
              icon: FontAwesomeIcons.idCard,
              iconColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Designation',
              value: profile.designation,
              isImportant: true,
              icon: FontAwesomeIcons.briefcase,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Department',
              value: profile.department,
              icon: FontAwesomeIcons.building,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Joining Date',
              value: profile.joiningDate,
              icon: FontAwesomeIcons.calendarCheck,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Current Posting',
              value: profile.currentPosting,
              icon: FontAwesomeIcons.locationDot,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Employee Type',
              value: profile.employeeType,
              icon: FontAwesomeIcons.userTie,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Pay Level',
              value: profile.payLevel,
              icon: FontAwesomeIcons.moneyBillTrendUp,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Current Basic Pay',
              value: profile.currentBasicPay,
              icon: FontAwesomeIcons.moneyBill,
              iconColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Marital Status',
              value: profile.maritalStatus,
              isImportant: true,
              icon: FontAwesomeIcons.heart,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Spouse Name',
              value: profile.spouseName,
              icon: FontAwesomeIcons.person,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Children',
              value: profile.children.toString(),
              icon: FontAwesomeIcons.children,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: "Father's Name",
              value: profile.fatherName,
              icon: FontAwesomeIcons.person,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: "Mother's Name",
              value: profile.motherName,
              icon: FontAwesomeIcons.personDress,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Emergency Contact',
              value: profile.emergencyContact,
              icon: FontAwesomeIcons.phone,
              iconColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Present Address',
              value: profile.presentAddress,
              isImportant: true,
              icon: FontAwesomeIcons.house,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Permanent Address',
              value: profile.permanentAddress,
              icon: FontAwesomeIcons.houseChimney,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Emergency Contact',
              value: profile.emergencyContact,
              icon: FontAwesomeIcons.phone,
              iconColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      blur: 0,
      opacity: 1.0,
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Bank Name',
              value: profile.bankName,
              isImportant: true,
              icon: FontAwesomeIcons.bank,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Account Number',
              value: profile.accountNumber,
              icon: FontAwesomeIcons.creditCard,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Account Type',
              value: profile.accountType,
              icon: FontAwesomeIcons.wallet,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'Branch',
              value: profile.branch,
              icon: FontAwesomeIcons.locationDot,
              iconColor: AppColors.primaryDarkBlue,
            ),
            const Divider(color: AppColors.mediumGrey),
            DetailRow(
              label: 'IFSC Code',
              value: profile.ifscCode,
              icon: FontAwesomeIcons.code,
              iconColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeepAliveTab extends StatefulWidget {
  final Widget child;

  const _KeepAliveTab({required this.child});

  @override
  _KeepAliveTabState createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}