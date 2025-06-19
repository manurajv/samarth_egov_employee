import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_appbar.dart';
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
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlue,
                AppColors.secondaryBlue,
              ],
            ),
          ),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              print('Bloc state: $state');
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (state is ProfileLoaded) {
                print('Rendering ProfileLoaded with profile: ${state.profile.fullName}');
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text(
                        l10n.profile,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      floating: false,
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.go('/profile/edit'),
                        ),
                      ],
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
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.secondaryBlue,
                    ],
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidUser,
                    color: Colors.white,
                    size: 32,
                  ),
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.designation,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    profile.department,
                    style: const TextStyle(
                      color: Colors.white60,
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
            child: TabBar(
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.secondaryBlue,
                  ],
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Employee ID',
              value: profile.employeeId,
              isImportant: true,
              icon: FontAwesomeIcons.idCard,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Date of Birth',
              value: profile.dob,
              icon: FontAwesomeIcons.cakeCandles,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Gender',
              value: profile.gender,
              icon: FontAwesomeIcons.venusMars,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Blood Group',
              value: profile.bloodGroup,
              icon: FontAwesomeIcons.droplet,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Category',
              value: profile.category,
              icon: FontAwesomeIcons.userTag,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Religion',
              value: profile.religion,
              icon: FontAwesomeIcons.pray,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Aadhar Number',
              value: profile.aadharNumber,
              icon: FontAwesomeIcons.idCard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Designation',
              value: profile.designation,
              isImportant: true,
              icon: FontAwesomeIcons.briefcase,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Department',
              value: profile.department,
              icon: FontAwesomeIcons.building,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Joining Date',
              value: profile.joiningDate,
              icon: FontAwesomeIcons.calendarCheck,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Current Posting',
              value: profile.currentPosting,
              icon: FontAwesomeIcons.locationDot,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Employee Type',
              value: profile.employeeType,
              icon: FontAwesomeIcons.userTie,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Pay Level',
              value: profile.payLevel,
              icon: FontAwesomeIcons.moneyBillTrendUp,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Current Basic Pay',
              value: profile.currentBasicPay,
              icon: FontAwesomeIcons.moneyBill,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Marital Status',
              value: profile.maritalStatus,
              isImportant: true,
              icon: FontAwesomeIcons.heart,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Spouse Name',
              value: profile.spouseName,
              icon: FontAwesomeIcons.person,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Children',
              value: profile.children.toString(),
              icon: FontAwesomeIcons.children,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: "Father's Name",
              value: profile.fatherName,
              icon: FontAwesomeIcons.person,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: "Mother's Name",
              value: profile.motherName,
              icon: FontAwesomeIcons.personDress,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Emergency Contact',
              value: profile.emergencyContact,
              icon: FontAwesomeIcons.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Present Address',
              value: profile.presentAddress,
              isImportant: true,
              icon: FontAwesomeIcons.house,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Permanent Address',
              value: profile.permanentAddress,
              icon: FontAwesomeIcons.houseChimney,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Emergency Contact',
              value: profile.emergencyContact,
              icon: FontAwesomeIcons.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankTab(BuildContext context, ProfileEntity profile) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetailRow(
              label: 'Bank Name',
              value: profile.bankName,
              isImportant: true,
              icon: FontAwesomeIcons.bank,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Account Number',
              value: profile.accountNumber,
              icon: FontAwesomeIcons.creditCard,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Account Type',
              value: profile.accountType,
              icon: FontAwesomeIcons.wallet,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'Branch',
              value: profile.branch,
              icon: FontAwesomeIcons.locationDot,
            ),
            const Divider(color: Colors.white24),
            DetailRow(
              label: 'IFSC Code',
              value: profile.ifscCode,
              icon: FontAwesomeIcons.code,
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