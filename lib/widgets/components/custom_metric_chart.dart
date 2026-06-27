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

  List<FlSpot> get sanitizedSpots {
    return spots.map((spot) {
      double roundedY = double.parse(spot.y.toStringAsFixed(2));
      return FlSpot(spot.x, roundedY);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double yInterval = (maxY - minY) / 4;
    if (yInterval <= 0 || yInterval.isNaN || yInterval.isInfinite) {
      yInterval = 0.5; 
    }
    
    double xInterval = (maxX - minX) / 4;
    if (xInterval <= 0 || xInterval.isNaN || xInterval.isInfinite) {
      xInterval = 60000;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: AppColors.whitePrimary,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16), 
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
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
                        reservedSize: 42,
                        interval: yInterval, 
                        getTitlesWidget: (value, meta) {
                          if (value < minY || value > maxY) {
                            return const SizedBox.shrink();
                          }

                          String formattedValue = value >= 10 
                              ? value.toStringAsFixed(0) 
                              : value.toStringAsFixed(1);
                              
                          return SideTitleWidget(
                            meta: meta,
                            space: 0,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$formattedValue$yAxisUnit",
                                style: GoogleFonts.roboto(
                                  color: AppColors.whiteQuaternary, 
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
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
                          if (value < minX || value > maxX) {
                            return const SizedBox.shrink();
                          }

                          double deltaToMax = maxX - value;
                          if (value != maxX && deltaToMax < 45000) {
                            return const SizedBox.shrink(); 
                          }

                          String timeText = "";
                          if (xTitleFormatter != null) {
                            timeText = xTitleFormatter!(value);
                          } else {
                            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            final hour = date.hour.toString().padLeft(2, '0');
                            final minute = date.minute.toString().padLeft(2, '0');
                            timeText = "$hour:$minute";
                          }

                          EdgeInsets paddingPojok = const EdgeInsets.only(top: 5);
                          
                          if (deltaToMax < (xInterval * 0.2)) {
                            paddingPojok = const EdgeInsets.only(top: 5, right: 2);
                          } else if ((value - minX) < (xInterval * 0.2)) {
                            paddingPojok = const EdgeInsets.only(top: 5, left: 2);
                          }

                          return SideTitleWidget(
                            meta: meta,
                            space: 0,
                            child: Padding(
                              padding: paddingPojok,
                              child: Text(
                                timeText,
                                style: GoogleFonts.roboto(
                                  color: AppColors.whitePrimary, 
                                  fontSize: 10
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sanitizedSpots,
                      isCurved: true,
                      curveSmoothness: 0.15, 
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
            ),
          )
        ],
      ),
    );
  }
}