import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/tab_provider.dart';
import 'package:shimizu_app/features/screens/home/contents/monitoring/electrical_content.dart';
import 'package:shimizu_app/features/screens/home/contents/monitoring/water_level_content.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  late PageController _pageController;
  final List<String> _categories = ["Electrical", "Water Level", "Panel Box"];
  
  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(monitoringTabProvider);
    _pageController = PageController(initialPage: initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTabCategory = ref.watch(monitoringTabProvider);

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
                      ref.read(monitoringTabProvider.notifier).state = index;
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
                ref.read(monitoringTabProvider.notifier).state = index;
              },
              children: [
                ElectricalContent(),
                WaterLevelContent(),
                const Center(
                  child: Text(
                    "Panel Box Content",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
