import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimizu_app/core/providers/connection_provider.dart';
import 'package:shimizu_app/widgets/components/custom_skeletonizer.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shimizu_app/core/providers/esp_status_provider.dart';
import 'package:shimizu_app/core/providers/pump_provider.dart';
import 'package:shimizu_app/widgets/components/custom_connection_layout.dart';
import 'package:shimizu_app/widgets/components/custom_button_control.dart';
import 'package:shimizu_app/widgets/components/custom_card.dart';

class ControlPage extends ConsumerWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final internetAsync = ref.watch(internetConnectionProvider);
  final bool hasInternet = internetAsync.value ?? true;

  final espStateAsync = ref.watch(espStatusControlProvider);
  final pumpStateAsync = ref.watch(pumpControlProvider);
  final pumpNotifier = ref.read(pumpControlProvider.notifier);

  final bool isOnline = espStateAsync.value ?? false;
  final bool isRunning = pumpStateAsync.value ?? false;

  final bool isButtonLoading = pumpStateAsync.isLoading && pumpStateAsync.hasValue;

  final bool showSkeleton = espStateAsync.value == null || 
                            pumpStateAsync.value == null || 
                            !hasInternet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSkeletonizer(
            enabled: showSkeleton,
            child: CustomCard(
              children: [
                Text(
                  "Pump Status",
                  style: GoogleFonts.roboto(color: AppColors.whitePrimary, fontSize: 15),
                ),
            
                const SizedBox(height: 5),
            
                Row(
                  children: [
                    Text(
                      isRunning ? "RUNNING" : "STOPPED",
                      style: GoogleFonts.roboto(
                        color: isRunning
                            ? AppColors.greenPrimary
                            : AppColors.redPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Skeleton.leaf(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isRunning
                              ? AppColors.greenPrimary
                              : AppColors.redPrimary,
                          shape: BoxShape.circle,
                          boxShadow: showSkeleton
                              ? null
                              : [
                                  BoxShadow(
                                    color: isRunning
                                        ? AppColors.greenPrimary.withValues(alpha: 0.6)
                                        : AppColors.redPrimary.withValues(alpha: 0.6),
                                    blurRadius: 10,
                                    spreadRadius: 1.5,
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 5),
            
                Text(
                  "Last Update: 10:30:45",
                  style: GoogleFonts.roboto(
                    color: AppColors.whiteSecondary,
                    fontSize: 13,
                  ),
                ),
                Center(
                  child: Skeleton.replace(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'assets/images/black_waterpump.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            
                const SizedBox(height: 5),
            
                Row(
                  children: [
                    Expanded(
                      child: CustomButtonControl(
                        label: "START",
                        icon: Icons.play_arrow,
                        color: isRunning
                            ? AppColors.whiteTertiary
                            : AppColors.greenPrimary,
                        onPressed:
                            (isRunning || isButtonLoading || showSkeleton)
                            ? null
                            : () => pumpNotifier.togglePump(true),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomButtonControl(
                        label: "STOP",
                        icon: Icons.stop,
                        color: !isRunning
                            ? AppColors.whiteTertiary
                            : AppColors.redPrimary,
                        onPressed:
                            (!isRunning || isButtonLoading || showSkeleton)
                            ? null
                            : () => pumpNotifier.togglePump(false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          CustomSkeletonizer(
            enabled: showSkeleton,
            child: CustomCard(
              children: [
                Text(
                  "Connection Status",
                  style: GoogleFonts.roboto(
                    color: AppColors.whitePrimary, 
                    fontSize: 15
                  ),
                ),
            
                const SizedBox(height: 33),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CustomConnectionLayout(
                      icon: Icon(
                        Icons.memory_sharp,
                        color: AppColors.whitePrimary,
                        size: 60,
                      ),
                      label: "ESP32",
                    ),
                    Text(
                      "<-------",
                      style: TextStyle(
                        color: isOnline ? AppColors.whitePrimary : AppColors.whiteTertiary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Skeleton.replace(
                      width: 45,
                      height: 45,
                      child: Lottie.asset(
                        'assets/lotties/no_connection.json',
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      "------->",
                      style: TextStyle(
                        color: isOnline ? AppColors.whitePrimary : AppColors.whiteTertiary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    CustomConnectionLayout(
                      icon: Image.asset('assets/icons/firebase_logo.png'),
                      label: "Firebase",
                    ),
                  ],
                ),
            
                const SizedBox(height: 33),
            
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOnline ? Icons.check_circle : Icons.cancel,
                            color: isOnline
                                ? AppColors.greenPrimary
                                : AppColors.redPrimary,
                            size: 20,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            isOnline ? "Connected" : "Disconnected",
                            style: GoogleFonts.roboto(
                              color: isOnline
                                  ? AppColors.greenPrimary
                                  : AppColors.redPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2.5),
                      
                      Text(
                        isOnline
                            ? "Realtime data sync active"
                            : "Realtime data sync deactive",
                        style: GoogleFonts.roboto(
                          color: isOnline ? AppColors.whitePrimary : AppColors.whiteTertiary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
