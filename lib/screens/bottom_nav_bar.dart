import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_auth/screens/diabetes_vip.dart';
import 'package:jwt_auth/screens/hypertention.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/widgets/inhert.dart';
import 'diabetes.dart';
import 'heart.dart';
import 'history.dart';
import 'settings.dart';
// Import your VIP Diabetes screen

class BottomNav extends StatefulWidget {
  final Function(String) updateDataset;
  const BottomNav({Key? key, required this.updateDataset}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _pageIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = SettingsProvider.of(context);
    final String selectedDataset = settingsProvider?.selectedDataset ?? 'Basic';

    final List<Widget> pages = [
      const HeartScreen(),
      selectedDataset == 'complex'
          ? const DiabetesVIPScreen()
          : const DiabetesScreen(),
      const HistoryPage(),
      const HypertensionScreen(),
      SettingsPage(updateDataset: widget.updateDataset),
    ];

    final List<String> titles = [
      'Heart',
      selectedDataset == 'complex' ? 'Diabetes Complex' : 'Diabetes Basic',
      'History',
      'Hypertension',
      'Settings',
    ];

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          titles[_pageIndex],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.primaryColor,
        backgroundColor: AppColors.secondaryColor,
        items: const <Widget>[
          FaIcon(
            FontAwesomeIcons.heartPulse,
            color: Colors.white,
          ),
          FaIcon(
            FontAwesomeIcons.syringe,
            color: Colors.white,
          ),
          FaIcon(
            FontAwesomeIcons.clockRotateLeft,
            color: Colors.white,
          ),
          FaIcon(
            FontAwesomeIcons.prescriptionBottle,
            color: Colors.white,
          ),
          FaIcon(
            FontAwesomeIcons.gear,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        index: _pageIndex,
      ),
    );
  }
}
