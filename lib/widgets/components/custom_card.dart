import 'package:flutter/material.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    super.key,
    required this.children,
    this.padding,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.whitePrimary.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}