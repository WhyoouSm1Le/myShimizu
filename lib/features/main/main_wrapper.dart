import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/features/screens/home/analytics_page.dart';
import 'package:shimizu_app/features/screens/home/control_page.dart';
import 'package:shimizu_app/features/screens/home/monitoring_page.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainPageState();
}

class _MainPageState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ControlPage(),
    const MonitoringPage(),
    const AnalyticsPage(),
    const Center(
      child: Text(
        "Settings Page", 
        style: TextStyle(color: AppColors.whitePrimary),
      ),
    ),
  ];

  final List<String> _titles = [
    "Control",
    "Monitoring",
    "Cost Estimation",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        leading: Icon(
          Icons.menu, 
          color: AppColors.whitePrimary
        ),
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.roboto(
            color: AppColors.whitePrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Icon(
            Icons.notifications_none, 
            color: AppColors.whitePrimary
          ),
          SizedBox(width: 20),
        ],
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.secondaryDark,
          selectedItemColor: AppColors.whitePrimary,
          unselectedItemColor: AppColors.whiteTertiary,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedLabelStyle: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.roboto(
            fontSize: 10
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0
                    ? Icons.water_drop
                    : Icons.water_drop_outlined,
              ),
              label: 'Control',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.monitor_heart
                    : Icons.monitor_heart_outlined,
              ),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2 
                    ? Icons.insert_chart 
                    : Icons.insert_chart_outlined_outlined,
              ),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 
                    ? Icons.settings 
                    : Icons.settings_outlined,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
