import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/auth_state_notifier.dart';
import 'package:shimizu_app/features/screens/home/analytics_page.dart';
import 'package:shimizu_app/features/screens/home/control_page.dart';
import 'package:shimizu_app/features/screens/home/monitoring_page.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainWrapper> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.whitePrimary), 
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.roboto(
            color: AppColors.whitePrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.whitePrimary),
            onPressed: () {},
          ),
          SizedBox(width: 20),
        ],
      ),
      body: _pages[_selectedIndex],

      drawer: Drawer(
        backgroundColor: AppColors.primaryDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.secondaryDark
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.whiteQuaternary,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 40, color: AppColors.whitePrimary)
                    : null,
              ),
              accountName: Text(
                user?.displayName ?? 'Shimizu User',
                style: GoogleFonts.roboto(
                  color: AppColors.whitePrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ), 
              accountEmail: Text(
                user?.email ?? 'No email bound',
                style: GoogleFonts.roboto(
                  color: AppColors.whiteTertiary,
                  fontSize: 13,
                ),
              )
            ),

            const SizedBox(height: 10),

            const Spacer(),

            const Divider(color: AppColors.secondaryDark, thickness: 1),

            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.redPrimary),
              title: Text(
                'Sign Out',
                style: GoogleFonts.roboto(
                  color: AppColors.whitePrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();

                await ref.read(authControllerProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

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
