import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class CustomTrendChart extends StatefulWidget {
  final String title;
  final String yAxisUnit;
  final List<double> dataValues; 
  final List<String> labels; 
  final double maxY;
  final Color activeBarColor; 
  final Color inactiveBarColor; 
  final bool isDaily; 
  final double? chartHeight; 
  final bool isOffline; 

  const CustomTrendChart({
    super.key,
    required this.title,
    required this.yAxisUnit,
    required this.dataValues,
    required this.labels,
    this.maxY = 30,
    this.activeBarColor = AppColors.greenPrimary, 
    this.inactiveBarColor = AppColors.whiteQuinary, 
    this.isDaily = false,
    this.chartHeight, 
    required this.isOffline, 
  });

  @override
  State<CustomTrendChart> createState() => _CustomTrendChartState();
}

class _CustomTrendChartState extends State<CustomTrendChart> {
  final ScrollController _scrollController = ScrollController();
  late List<double> _animatedValues;

  @override
  void initState() {
    super.initState();
    
    _animatedValues = List<double>.filled(widget.dataValues.length, 0.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.isOffline) {
        setState(() {
          _animatedValues = List<double>.from(widget.dataValues);
        });
      }

      if (!widget.isDaily && _scrollController.hasClients) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double availableWidth = screenWidth - 32 - 45; 
        final double barGroupWidth = availableWidth / 5;

        int currentMonthIndex = DateTime.now().month - 1;
        double targetScrollOffset = (currentMonthIndex - 4) * barGroupWidth;

        if (targetScrollOffset < 0) {
          targetScrollOffset = 0;
        } else if (targetScrollOffset > _scrollController.position.maxScrollExtent) {
          targetScrollOffset = _scrollController.position.maxScrollExtent;
        }

        _scrollController.jumpTo(targetScrollOffset);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isOffline != widget.isOffline || oldWidget.dataValues != widget.dataValues) {
      setState(() {
        if (widget.isOffline) {
          _animatedValues = List<double>.filled(widget.dataValues.length, 0.0);
        } else {
          _animatedValues = List<double>.from(widget.dataValues);
        }
      });
    } else if (!widget.isOffline && _animatedValues.every((val) => val == 0.0) && widget.dataValues.any((val) => val > 0)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _animatedValues = List<double>.from(widget.dataValues);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calculatedInterval = (widget.maxY > 0) ? (widget.maxY ~/ 3).toDouble() : 1.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth = screenWidth - 32 - 45; 
    
    final double barGroupWidth = widget.isDaily ? (availableWidth / 7) : (availableWidth / 5);
    double chartWidth = widget.isDaily ? availableWidth : (widget.dataValues.length * barGroupWidth);

    final int activeIndex = widget.isDaily ? (DateTime.now().weekday - 1) : (DateTime.now().month - 1);

    final Color gridLineColor = widget.isOffline 
        ? AppColors.whiteQuinary.withOpacity(0.10) 
        : AppColors.whitePrimary.withOpacity(0.08);

    Widget chartContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.roboto(color: AppColors.whitePrimary, fontSize: 15),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              // 1. Sumbu Y Kiri
              SizedBox(
                width: 45,
                child: BarChart(
                  BarChartData(
                    maxY: widget.maxY > 0 ? (widget.maxY + 2) : 10,
                    minY: 0,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: calculatedInterval,
                          getTitlesWidget: (value, meta) {
                            if (widget.maxY > 0 && value > widget.maxY) {
                              return const SizedBox.shrink();
                            }

                            double roundedValue = value;
                            if (widget.maxY >= 1000) {
                              roundedValue = (value / 1000).round() * 1000;
                            }
                            
                            String displayValue = roundedValue.toInt().toString();
                            if (roundedValue >= 1000) {
                              displayValue = "${(roundedValue / 1000).toStringAsFixed(0)}k";
                            }

                            return Text(
                              "${widget.yAxisUnit} $displayValue",
                              style: GoogleFonts.roboto(
                                color: AppColors.whiteQuaternary, 
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [BarChartRodData(toY: 0, color: AppColors.transparent, width: 0)],
                      ),
                    ], 
                  ),
                ),
              ),

              Expanded(
                child: widget.isDaily
                    ? SizedBox(
                        width: chartWidth,
                        child: buildBarChart(activeIndex, calculatedInterval, gridLineColor),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: chartWidth,
                          child: buildBarChart(activeIndex, calculatedInterval, gridLineColor),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      height: widget.chartHeight, 
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.whitePrimary.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: chartContent,
    );
  }

  BarChart buildBarChart(int activeIndex, double calculatedInterval, Color gridLineColor) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.maxY > 0 ? widget.maxY : 10, 
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index >= 0 && index < widget.labels.length) {
                  final bool isActive = index == activeIndex;
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      widget.labels[index],
                      style: GoogleFonts.roboto(
                        color: isActive ? AppColors.whitePrimary : AppColors.whiteSecondary, 
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: calculatedInterval,
          getDrawingHorizontalLine: (value) {
            if (value == 0 || (widget.maxY > 0 && value >= widget.maxY - 5)) {
              return const FlLine(color: AppColors.transparent);
            }
            return FlLine(
              color: gridLineColor, 
              strokeWidth: 0.8,
              dashArray: const [5, 5],
            );
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            // Garis dasar (0) dibuat solid
            HorizontalLine(
              y: 0,
              color: gridLineColor, 
              strokeWidth: 1.0,
            ),
            HorizontalLine(
              y: widget.maxY > 0 
                  ? (widget.isDaily ? widget.maxY - 15 : widget.maxY - 350) 
                  : 10,
              color: gridLineColor, 
              strokeWidth: 0.8, 
              dashArray: const [5, 5], 
            ),
          ],
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(widget.dataValues.length, (index) {
          final bool isActive = index == activeIndex;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: _animatedValues[index], 
                color: isActive ? widget.activeBarColor : widget.inactiveBarColor,
                width: widget.isDaily ? 14 : 24, 
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 900),
      swapAnimationCurve: Curves.easeOutQuart, 
    );
  }
}