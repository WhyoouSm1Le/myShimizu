import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimizu_app/core/providers/connection_provider.dart';
import 'package:shimizu_app/core/providers/water_level_provider.dart';
import 'package:shimizu_app/widgets/components/custom_card.dart';
import 'package:shimizu_app/widgets/components/custom_skeletonizer.dart';
import 'package:shimizu_app/widgets/components/custom_water_tank_display.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WaterLevelContent extends ConsumerWidget {
  const WaterLevelContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetAsync = ref.watch(internetConnectionProvider);
    final waterLevelAsync = ref.watch(realtimeWaterLevelProvider);

    final bool hasInternet = internetAsync.value ?? true;
    final bool showSkeleton = waterLevelAsync.isLoading || !hasInternet;
    final waterData = waterLevelAsync.value;

    final double percentage = waterData?.percentage ?? 0.0;
    final double waterHeight = waterData?.waterHeight ?? 0.0;
    final double volumeLiters = waterData?.volumeLiters ?? 0.0;
    final double currentDistance = waterData?.currentDistance ?? 0.0;
    final String status = waterData?.status ?? "Normal";

    String lastUpdate = "--:--:--";
    if (waterData != null && waterData.timestamp > 0) {
      final date = DateTime.fromMillisecondsSinceEpoch(waterData.timestamp);
      lastUpdate = DateFormat('HH:mm:ss').format(date);
    }

    Color statusColor = Colors.green;
    if (status.toLowerCase().contains('low') ||
        status.toLowerCase().contains('empty')) {
      statusColor = Colors.redAccent;
    } else if (status.toLowerCase().contains('full')) {
      statusColor = Colors.blueAccent;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomSkeletonizer(
                    enabled: showSkeleton,
                    child: CustomCard(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Water Level",
                                  style: GoogleFonts.roboto(
                                    color: AppColors.whitePrimary,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${percentage.toStringAsFixed(0)}%",
                                  style: GoogleFonts.roboto(
                                    color: Colors.blue,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: GoogleFonts.roboto(
                                    color: statusColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.opacity,
                              color: Colors.blue,
                              size: 35,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Skeleton.replace(
                            width: showSkeleton ? double.infinity : 180,
                            height: 220,
                            child: CustomWaterTankDisplay(
                              percentage: percentage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  Expanded(
                    child: CustomSkeletonizer(
                      enabled: showSkeleton,
                      child: CustomCard(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Level Status",
                                style: GoogleFonts.roboto(
                                  color: AppColors.whitePrimary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
              
                          _buildTelemetryRow(
                            "Water Height",
                            "${waterHeight.toStringAsFixed(1)} cm",
                          ),
                          Divider(
                            color: AppColors.whitePrimary.withOpacity(0.08),
                            height: 20,
                            thickness: 0.5,
                          ),
                          _buildTelemetryRow(
                            "Remaining Volume",
                            "${volumeLiters.toStringAsFixed(0)} Liters",
                          ),
                          Divider(
                            color: AppColors.whitePrimary.withOpacity(0.08),
                            height: 20,
                            thickness: 0.5,
                          ),
                          _buildTelemetryRow(
                            "Sensor Distance",
                            "${currentDistance.toStringAsFixed(1)} cm",
                          ),
                          Divider(
                            color: AppColors.whitePrimary.withOpacity(0.08),
                            height: 20,
                            thickness: 0.5,
                          ),
                          _buildTelemetryRow("Last Update", lastUpdate),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTelemetryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: AppColors.whiteSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            color: AppColors.whitePrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
