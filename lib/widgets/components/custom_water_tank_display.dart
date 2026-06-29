import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class CustomWaterTankDisplay extends StatelessWidget {
  final double percentage;
  final double width;
  final double height;

  const CustomWaterTankDisplay({
    super.key,
    required this.percentage,
    this.width = 180,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: percentage),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        builder: (context, animatedValue, child) {
          return SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: _CylinderTankPainter(percentage: animatedValue),
            ),
          );
        },
      ),
    );
  }
}

class _CylinderTankPainter extends CustomPainter {
  final double percentage;
  _CylinderTankPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double offsetTop = h * 0.12;    
    final double tankHeight = h * 0.82;   
    final double rx = w * 0.45;           
    final double ry = h * 0.04;           

    final double leftX = w * 0.05;
    final double rightX = w * 0.95;

    final tankOutlinePaint = Paint()
      ..color = AppColors.whitePrimary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final glassGlowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.whitePrimary.withOpacity(0.02),
          AppColors.whitePrimary.withOpacity(0.06),
          AppColors.whitePrimary.withOpacity(0.01),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTRB(leftX, offsetTop, rightX, offsetTop + tankHeight))
      ..style = PaintingStyle.fill;

    if (percentage > 0) {
      final fillPercentage = (percentage.clamp(0.0, 100.0) / 100.0);
      final double waterTopY = (offsetTop + tankHeight) - (tankHeight * fillPercentage);

      final waterPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.blue.shade800.withOpacity(0.70),
            Colors.blue.shade400.withOpacity(0.75),
            Colors.blue.shade900.withOpacity(0.75),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromLTRB(leftX, waterTopY, rightX, offsetTop + tankHeight))
        ..style = PaintingStyle.fill;

      final waterSurfacePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade300.withOpacity(0.9),
            Colors.blue.shade600.withOpacity(0.85),
          ],
        ).createShader(Rect.fromLTRB(leftX, waterTopY - ry, rightX, waterTopY + ry))
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromLTRB(leftX, offsetTop + tankHeight - ry, rightX, offsetTop + tankHeight + ry),
        waterPaint,
      );

      canvas.drawRect(
        Rect.fromLTRB(leftX, waterTopY, rightX, offsetTop + tankHeight),
        waterPaint,
      );

      canvas.drawOval(
        Rect.fromLTRB(leftX, waterTopY - ry, rightX, waterTopY + ry),
        waterSurfacePaint,
      );
    }

    canvas.drawRect(Rect.fromLTRB(leftX, offsetTop, rightX, offsetTop + tankHeight), glassGlowPaint);
    canvas.drawLine(Offset(leftX, offsetTop), Offset(leftX, offsetTop + tankHeight), tankOutlinePaint);
    canvas.drawLine(Offset(rightX, offsetTop), Offset(rightX, offsetTop + tankHeight), tankOutlinePaint);
    canvas.drawOval(Rect.fromLTRB(leftX, offsetTop + tankHeight - ry, rightX, offsetTop + tankHeight + ry), tankOutlinePaint);
    canvas.drawOval(Rect.fromLTRB(leftX, offsetTop - ry, rightX, offsetTop + ry), tankOutlinePaint);

    final capPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTRB(w * 0.35, offsetTop - ry - 6, w * 0.65, offsetTop - ry), glassGlowPaint);
    canvas.drawRect(Rect.fromLTRB(w * 0.35, offsetTop - ry - 6, w * 0.65, offsetTop - ry), capPaint);

    final textPaint = TextPainter(textDirection: TextDirection.ltr);
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 1.0;

    final List<String> scaleLabels = ["100%", "75%", "50%", "25%", "0%"];
    for (int i = 0; i < scaleLabels.length; i++) {
      double ratio = i / (scaleLabels.length - 1);
      double yNode = offsetTop + (tankHeight * ratio);

      canvas.drawLine(Offset(rightX, yNode), Offset(rightX + 8, yNode), tankOutlinePaint);
      canvas.drawLine(Offset(leftX, yNode), Offset(rightX, yNode), linePaint);

      textPaint.text = TextSpan(
        text: scaleLabels[i],
        style: GoogleFonts.roboto(
          color: AppColors.whitePrimary, 
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(rightX + 14, yNode - 6));
    }
  }

  @override
  bool shouldRepaint(covariant _CylinderTankPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}