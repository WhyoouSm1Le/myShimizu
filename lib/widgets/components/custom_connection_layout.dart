import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomConnectionLayout extends StatelessWidget {
  final Widget icon;
  final String label;

  const CustomConnectionLayout({
    super.key,
    required this.icon,
    required this.label,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: icon,
            ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}