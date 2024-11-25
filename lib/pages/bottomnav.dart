import 'package:book_app/pages/Profile.dart';
import 'package:book_app/pages/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  final PageController _pageController = PageController();

  late List<Widget> pages;
  late Home homePage;
  late Profile profile;

  @override
  void initState() {
    homePage = Home();
    profile = Profile();
    pages = [homePage, profile];
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  void onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Color(0xFF018786),
        animationDuration: Duration(milliseconds: 300),
        onTap: onBottomNavTapped,
        items: [
          Icon(
            Icons.home_outlined,
            color: Color(0xFFF5F5F5),
          ),
          Icon(
            Icons.person_3_outlined,
            color: Color(0xFFF5F5F5),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: pages,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
