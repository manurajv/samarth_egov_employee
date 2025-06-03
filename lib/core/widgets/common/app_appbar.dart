import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppAppBar extends StatelessWidget {
final String title;
final List<Widget>? actions;
final bool showBackButton;
final Widget? leading;
final double elevation;

const AppAppBar({
super.key,
required this.title,
this.actions,
this.showBackButton = true,
this.leading,
this.elevation = 0,
});

@override
Widget build(BuildContext context) {
return SliverAppBar(
title: Text(
title,
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
backgroundColor: Colors.transparent,
elevation: elevation,
pinned: true, // Keeps the app bar visible when scrolling
automaticallyImplyLeading: showBackButton,
leading: leading,
actions: actions,
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
);
}
}