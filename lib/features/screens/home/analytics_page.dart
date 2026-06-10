import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/tab_provider.dart';
import 'package:shimizu_app/features/screens/home/contents/analytics/monthly_content.dart';
import 'package:shimizu_app/features/screens/home/contents/analytics/summary_content.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  late PageController _pageController;
  final List<String> _categories = ["Monthly", "Summary", "History"];

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(analyticsTabProvider);
    _pageController = PageController(initialPage: initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTabCategory = ref.watch(analyticsTabProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: AppColors.primaryDark),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final bool isActive = activeTabCategory == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(analyticsTabProvider.notifier).state = index;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondaryDark
                            : AppColors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _categories[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: isActive 
                              ? AppColors.whitePrimary 
                              : AppColors.whiteTertiary,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                ref.read(analyticsTabProvider.notifier).state = index;
              },
              children: [
                MonthlyContent(),
                SummaryContent(),
                const Center(
                  child: Text(
                    "History Analytics",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
