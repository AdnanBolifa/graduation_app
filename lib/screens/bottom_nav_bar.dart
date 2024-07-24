import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jwt_auth/screens/diabetes.dart';
import 'package:jwt_auth/screens/heart.dart';
import 'package:jwt_auth/screens/history.dart';
import 'package:jwt_auth/screens/hypertention.dart';
import 'package:jwt_auth/screens/settings.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _pageIndex = 2;
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _pages = [
    const HeartScreen(),
    const DiabetesScreen(),
    const HistoryPage(),
    const HypertensionScreen(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    'Heart',
    'Diabetes',
    'History',
    'Hypertension',
    'Settings',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          _titles[_pageIndex],
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
        children: _pages,
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
