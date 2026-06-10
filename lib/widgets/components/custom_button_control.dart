import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class CustomButtonControl extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const CustomButtonControl({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isDisabled ? AppColors.whiteTertiary : AppColors.whitePrimary,
        size: 30,
      ),
      label: Text(
        label,
        style: GoogleFonts.roboto(
          color: isDisabled ? AppColors.whiteTertiary : AppColors.whitePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.whiteTertiary : color,
        padding: const EdgeInsets.symmetric(
          vertical: 10, 
          horizontal: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: isDisabled ? 0 : 5,
      ),
    );
  }
}