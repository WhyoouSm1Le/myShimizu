import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimizu_app/core/providers/connection_provider.dart';
import 'package:shimizu_app/core/providers/cost_estimation_provider.dart';
import 'package:shimizu_app/widgets/components/custom_card.dart';
import 'package:shimizu_app/widgets/components/custom_cost_detail.dart';
import 'package:shimizu_app/widgets/components/custom_trend_chart.dart';
import 'package:shimizu_app/widgets/components/custom_skeletonizer.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MonthlyContent extends ConsumerStatefulWidget {
  const MonthlyContent({super.key});

  @override
  ConsumerState<MonthlyContent> createState() => _MonthlyTabState();
}

class _MonthlyTabState extends ConsumerState<MonthlyContent> {
  bool _isRetrying = false;

  Future<void> _refreshData() async {

    ref.invalidate(internetConnectionProvider);
    await ref.read(costEstimationProvider.notifier).retryPrediction();
  }

  @override
  Widget build(BuildContext context) {
    final internetAsync = ref.watch(internetConnectionProvider);
    final estimationAsync = ref.watch(costEstimationProvider);

    final bool hasInternet = internetAsync.value ?? true;
    final estimationData = estimationAsync.value;

    final bool isTechnicalError = hasInternet && 
        !estimationAsync.isLoading && 
        estimationAsync.hasError &&
        !_isRetrying;

    final bool showPageSkeleton = estimationAsync.isLoading || 
        !hasInternet ||
        _isRetrying ||
        (estimationData == null);

    final double estimatedCostApi = estimationData?.estimatedCost.toDouble() ?? 88888.0;
    final double estimatedKwhApi = estimationData?.estimatedKwh ?? 88.88;
    final int predictionDays = estimationData?.predictionDays ?? 30;
    final String aiMessage = estimationData?.message ?? 'Analyzing water pump consumption';

    final double costPerKwh = (estimationData != null && estimationData.estimatedKwh > 0)
        ? estimationData.estimatedCost / estimationData.estimatedKwh
        : 1444.70;

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    List<double> dummyCosts = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    if (!showPageSkeleton) {
      dummyCosts = [
        18500, 24000, 15000, 29000, 21679, estimatedCostApi, 
        26500, 19000, 24500, 28000, 19500, 31000
      ];
    }

    final List<String> dummyMonths = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    if (isTechnicalError) {
      return Container(
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
              "Failed to get cost estimation",
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
                    )
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refreshData,
      backgroundColor: AppColors.secondaryDark,
      color: AppColors.whitePrimary,
      edgeOffset: 10,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      "Failed to get data estimation",
                      style: GoogleFonts.roboto(
                        color: AppColors.whiteQuaternary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _refreshData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.whitePrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        side: BorderSide(color: AppColors.whiteQuaternary.withOpacity(0.4), width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Try Again",
                        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            else
              CustomSkeletonizer(
                enabled: showPageSkeleton,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomCard(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center, 
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                  Text(
                                    "Estimated Cost (This Month)",
                                    style: GoogleFonts.roboto(color: AppColors.whitePrimary, fontSize: 15),
                                  ),
                                  const SizedBox(height: 5), 
                                  Text(
                                    formatter.format(estimatedCostApi),
                                    style: GoogleFonts.roboto(color: AppColors.whitePrimary, fontWeight: FontWeight.w500, fontSize: 40),
                                  ),
                                  const SizedBox(height: 5), 
                                  Text(
                                    aiMessage,
                                    style: GoogleFonts.roboto(fontSize: 13, color: AppColors.whiteSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Skeleton.replace(
                              width: 75, height: 75,
                              child: Lottie.asset('assets/lotties/3d_dollar.json', width: 75, height: 75, fit: BoxFit.contain),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Divider(color: AppColors.whitePrimary.withOpacity(0.08), height: 0.5, thickness: 0.5),
                        ),
                        Column(
                          children: [
                            CustomCostDetail(label: "Energy Consumption", value: "${estimatedKwhApi.toStringAsFixed(2)} kWh"),
                            CustomCostDetail(label: "Cost Per kWh", value: formatter.format(costPerKwh)),
                            CustomCostDetail(label: "Calculation", value: "${estimatedKwhApi.toStringAsFixed(2)} kWh x ${formatter.format(costPerKwh)}"),
                            CustomCostDetail(label: "Period", value: "1 – $predictionDays Days Prediction"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 293, 
                      child: CustomTrendChart(
                        title: "Cost Trend",
                        yAxisUnit: "Rp",
                        isDaily: false,
                        dataValues: dummyCosts,
                        labels: dummyMonths,
                        maxY: 35000, 
                        isOffline: !hasInternet,
                      ),
                    ),
                  ],
                ),
              ),
              
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}