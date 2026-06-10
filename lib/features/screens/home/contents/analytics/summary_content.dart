import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimizu_app/widgets/components/custom_card.dart';
import 'package:shimizu_app/widgets/components/custom_trend_chart.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class SummaryContent extends StatelessWidget {
  const SummaryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> dailyCosts = [
      750,
      1200,
      900,
      1500,
      1100,
      800,
      650,
    ];

    final List<String> dailyFullyLabels = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final List<int> pumpFrequencies = [
      2,
      4,
      3,
      5,
      3,
      2,
      1,
    ];

    final double totalWeekCost = dailyCosts.reduce((a, b) => a + b);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return SingleChildScrollView(
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
                          "This Week's Cost",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          formatter.format(totalWeekCost),
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Actual data collected from past 7 days',
                          style: GoogleFonts.roboto(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset(
                    'assets/lotties/3d_dollargreen.json',
                    width: 75,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          CustomTrendChart(
            title: "Daily Cost BreakDown",
            yAxisUnit: "Rp",
            isDaily: true,
            chartHeight: 250,
            dataValues: const [750, 1200, 900, 1500, 1100, 800, 650],
            labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            maxY: 1800,
            isOffline: false,
          ),

          const SizedBox(height: 20),

          CustomCard(
            children: [
              Text(
                "Pump Usage Frequency",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 15),
              ),

              const SizedBox(height: 5),

              Text(
                "How many times the pump activated per day",
                style: GoogleFonts.roboto(color: Colors.white60, fontSize: 13),
              ),

              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyFullyLabels.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.whitePrimary.withValues(alpha: 0.08),
                  height: 0.5,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.water_drop_outlined,
                              color: AppColors.greenPrimary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              dailyFullyLabels[index],
                              style: GoogleFonts.roboto(
                                color: AppColors.whiteSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${pumpFrequencies[index]} Times",
                              style: GoogleFonts.roboto(
                                color: AppColors.whitePrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "(${formatter.format(dailyCosts[index])})",
                              style: GoogleFonts.roboto(
                                color: AppColors.whiteQuaternary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
