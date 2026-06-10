import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class CustomMetricChart extends StatelessWidget {
  final String title;
  final String yAxisUnit;
  final Color lineColor;
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final String Function(double value)? xTitleFormatter;

  const CustomMetricChart({
    super.key,
    required this.title,
    required this.yAxisUnit,
    required this.lineColor,
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    this.xTitleFormatter,
  });

  @override
  Widget build(BuildContext context) {
    double yInterval = (maxY - minY) / 4;
    if (yInterval <= 0 || yInterval.isNaN || yInterval.isInfinite) {
      yInterval = 1.0; 
    }
    
    double xInterval = (maxX - minX) / 4;
    if (xInterval <= 0 || xInterval.isNaN || xInterval.isInfinite) {
      xInterval = 60000;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.whitePrimary.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              color: AppColors.whitePrimary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: minX == maxX ? minX - 10000 : minX - (xInterval * 0.1),
                maxX: minX == maxX ? maxX + 10000 : maxX + (xInterval * 0.1),
                minY: minY == maxY ? minY - 1 : minY,
                maxY: minY == maxY ? maxY + 5 : maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: yInterval, 
                  verticalInterval: xInterval,   
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.whitePrimary.withValues(alpha: 0.05),
                    strokeWidth: 0.8,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: AppColors.whitePrimary.withValues(alpha: 0.05),
                    strokeWidth: 0.8,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: yInterval, 
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "${value.toStringAsFixed(1)} $yAxisUnit",
                          style: GoogleFonts.roboto(color: AppColors.whiteQuaternary, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: xInterval, 
                      getTitlesWidget: (value, meta) {
                        if (xTitleFormatter != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              xTitleFormatter!(value),
                              style: GoogleFonts.roboto(color: AppColors.whiteQuaternary, fontSize: 10),
                            ),
                          );
                        }

                        if (value < minX || value > maxX) {
                          return const SizedBox.shrink();
                        }
                        
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final hour = date.hour.toString().padLeft(2, '0');
                        final minute = date.minute.toString().padLeft(2, '0');
                        
                        if (value == meta.min || value == meta.max) {
                          return const Text('');
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "$hour:$minute",
                            style: GoogleFonts.roboto(color: AppColors.whitePrimary, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: lineColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          lineColor.withValues(alpha: 0.2),
                          lineColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}