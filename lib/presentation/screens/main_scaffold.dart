import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home/today_screen.dart';
import 'money/money_screen.dart';
import 'profile/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TodayScreen(),
    MoneyScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.listCheck),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.coins),
            label: 'Money',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.userAstronaut),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
