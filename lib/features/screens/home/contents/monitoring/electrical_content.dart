import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/connection_provider.dart';
import 'package:shimizu_app/core/providers/energy_provider.dart';
import 'package:shimizu_app/core/providers/energy_history_provider.dart';
import 'package:shimizu_app/widgets/components/custom_skeletonizer.dart';
import 'package:shimizu_app/widgets/components/custom_metric_card.dart';
import 'package:shimizu_app/widgets/components/custom_metric_chart.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class ElectricalContent extends ConsumerStatefulWidget {
  const ElectricalContent({super.key});

  @override
  ConsumerState<ElectricalContent> createState() => _ElectricalTabState();
}

class _ElectricalTabState extends ConsumerState<ElectricalContent> {
  bool _isRetrying = false;

  Future<void> _refreshData() async {
    ref.invalidate(internetConnectionProvider);
    ref.invalidate(realtimeEnergyProvider);
    await ref.read(energyHistoryProvider.notifier).refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    final internetAsync = ref.watch(internetConnectionProvider);
    final realtimeAsync = ref.watch(realtimeEnergyProvider);
    final historyAsync = ref.watch(energyHistoryProvider);

    final bool hasInternet = internetAsync.value ?? true;
    final historyData = historyAsync.value ?? [];
    final realtimeData = realtimeAsync.value;

    final bool isTechnicalError = hasInternet && 
        !historyAsync.isLoading &&
        historyAsync.hasError &&
        !_isRetrying;

    final bool showChartSkeleton = historyAsync.isLoading ||
        !hasInternet ||
        _isRetrying ||
        (historyAsync.hasValue && historyAsync.value!.isEmpty);

    final bool showRealtimeSkeleton = realtimeAsync.value == null || !hasInternet || _isRetrying;

    final String voltage = realtimeData?.voltage.toStringAsFixed(1) ?? "0.0";
    final String current = realtimeData?.current.toStringAsFixed(2) ?? "0.0";
    final String power = realtimeData?.power.toStringAsFixed(0) ?? "0";
    final String energy = realtimeData?.energy.toStringAsFixed(2) ?? "0.0";

    double minX = 0;
    double maxX = 3;
    
    double minYVolt = 180, maxYVolt = 250;
    double minYCurrent = 0, maxYCurrent = 2.0;
    double minYPower = 0, maxYPower = 500;
    double maxYEnergy = 1.0;

    List<FlSpot> voltageSpots = const [FlSpot(0, 180), FlSpot(1, 180), FlSpot(2, 180), FlSpot(3, 180)];
    List<FlSpot> currentSpots = const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0)];
    List<FlSpot> powerSpots   = const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0)];
    List<FlSpot> energySpots  = const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0)];

    if (!showChartSkeleton && historyData.isNotEmpty) {
      minX = (historyData.first.time?.millisecondsSinceEpoch ?? 0).toDouble();
      maxX = (historyData.last.time?.millisecondsSinceEpoch ?? 1).toDouble();

      voltageSpots = historyData.map((e) => FlSpot((e.time?.millisecondsSinceEpoch ?? 0).toDouble(), e.voltage)).toList();
      currentSpots = historyData.map((e) => FlSpot((e.time?.millisecondsSinceEpoch ?? 0).toDouble(), e.current)).toList();
      powerSpots = historyData.map((e) => FlSpot((e.time?.millisecondsSinceEpoch ?? 0).toDouble(), e.power)).toList();
      energySpots = historyData.map((e) => FlSpot((e.time?.millisecondsSinceEpoch ?? 0).toDouble(), e.energy)).toList();

      double maxV = historyData.map((e) => e.voltage).reduce((a, b) => a > b ? a : b);
      double minV = historyData.map((e) => e.voltage).reduce((a, b) => a < b ? a : b);
      
      double calculatedMinV = ((minV - 2) / 10).floor() * 10.0;
      double calculatedMaxV = ((maxV + 2) / 10).ceil() * 10.0;
      
      if (calculatedMaxV - calculatedMinV < 20) {
        calculatedMinV = calculatedMinV - 10;
        calculatedMaxV = calculatedMaxV + 10;
      }

      minYVolt = calculatedMinV.clamp(0, 240);
      maxYVolt = calculatedMaxV.clamp(210, 260);

      double maxA = historyData.map((e) => e.current).reduce((a, b) => a > b ? a : b);
      double calculatedMaxA = (maxA < 0.2) ? 1.0 : ((maxA + 0.3) / 0.4).ceil() * 0.4;
      maxYCurrent = calculatedMaxA;

      double maxW = historyData.map((e) => e.power).reduce((a, b) => a > b ? a : b);
      double calculatedMaxW = (maxW < 10) ? 300 : ((maxW + 50) / 40).ceil() * 40.0;
      maxYPower = calculatedMaxW;

      double maxE = historyData.map((e) => e.energy).reduce((a, b) => a > b ? a : b);
      maxYEnergy = maxE < 0.1 ? 0.4 : ((maxE + 0.1) / 0.4).ceil() * 0.4;
    }

    final Color offlineLineColor = AppColors.whiteQuaternary.withOpacity(0.10);

    return RefreshIndicator(
      onRefresh: _refreshData,
      backgroundColor: AppColors.secondaryDark,
      color: AppColors.whitePrimary,
      edgeOffset: 10,
      child: SingleChildScrollView(
        physics: (isTechnicalError || _isRetrying)
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                CustomSkeletonizer(
                  enabled: showRealtimeSkeleton,
                  child: CustomMetricCard(
                    title: "Voltage", value: voltage, unit: "V",
                    icon: const Icon(Icons.flash_on, color: Colors.blue, size: 25),
                  ),
                ),
                CustomSkeletonizer(
                  enabled: showRealtimeSkeleton,
                  child: CustomMetricCard(
                    title: "Current", value: current, unit: "A",
                    icon: const Icon(Icons.show_chart, color: Colors.green, size: 25),
                  ),
                ),
                CustomSkeletonizer(
                  enabled: showRealtimeSkeleton,
                  child: CustomMetricCard(
                    title: "Power", value: power, unit: "W",
                    icon: const Icon(Icons.power_settings_new, color: Colors.orange, size: 25),
                  ),
                ),
                CustomSkeletonizer(
                  enabled: showRealtimeSkeleton,
                  child: CustomMetricCard(
                    title: "Energy", value: energy, unit: "kWh",
                    icon: const Icon(Icons.battery_charging_full, color: Colors.lightGreen, size: 25),
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            if (isTechnicalError)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(
                      "Sorry, there's a technical error",
                      style: GoogleFonts.roboto(
                        color: AppColors.whitePrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Failed to get data history",
                      style: GoogleFonts.roboto(
                        color: AppColors.whiteQuaternary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isRetrying
                          ? null
                          : () async {
                              setState(() {
                                _isRetrying = true; 
                              });

                              await _refreshData();

                              await Future.delayed(const Duration(seconds: 3));

                              if (mounted) {
                                setState(() {
                                  _isRetrying = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.whitePrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        side: BorderSide(
                          color: AppColors.whiteQuaternary.withOpacity(0.4), 
                          width: 1
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isRetrying
                            ? const SizedBox(
                                key: ValueKey('loading'),
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: AppColors.whitePrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Try Again",
                                key: const ValueKey('text'),
                                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  CustomSkeletonizer(
                    enabled: showChartSkeleton,
                    child: CustomMetricChart(
                      title: "History Chart (Voltage)",
                      yAxisUnit: "V",
                      lineColor: showChartSkeleton ? offlineLineColor : Colors.cyan,
                      spots: voltageSpots,
                      minX: minX, maxX: maxX,
                      minY: minYVolt, maxY: maxYVolt,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomSkeletonizer(
                    enabled: showChartSkeleton,
                    child: CustomMetricChart(
                      title: "History Chart (Current)",
                      yAxisUnit: "A",
                      lineColor: showChartSkeleton ? offlineLineColor : Colors.green,
                      spots: currentSpots,
                      minX: minX, maxX: maxX,
                      minY: minYCurrent, maxY: maxYCurrent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomSkeletonizer(
                    enabled: showChartSkeleton,
                    child: CustomMetricChart(
                      title: "History Chart (Power)",
                      yAxisUnit: "W",
                      lineColor: showChartSkeleton ? offlineLineColor : Colors.orange,
                      spots: powerSpots,
                      minX: minX, maxX: maxX,
                      minY: minYPower, maxY: maxYPower,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomSkeletonizer(
                    enabled: showChartSkeleton,
                    child: CustomMetricChart(
                      title: "History Chart (Energy)",
                      yAxisUnit: "kWh",
                      lineColor: showChartSkeleton ? offlineLineColor : Colors.lightGreen,
                      spots: energySpots,
                      minX: minX, maxX: maxX,
                      minY: 0, maxY: maxYEnergy,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}