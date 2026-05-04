import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/pages/main_page/calendar_page.dart';
import 'package:flutter_preintern_app/pages/main_page/contact_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  // Pages are created once and reused — state is preserved across tab switches.
  final List<Widget> _pages = [
    Placeholder(), // home
    CalendarPage(), // calendar
    Placeholder(), // people
    ContactPage(), // contact  ← default (index 3)
    Placeholder(), // todo
    Placeholder(), // me
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _ButtonNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      // IndexedStack keeps every page alive so state isn't lost on tab switch.
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}

class _ButtonNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTap;

  const _ButtonNav({required this.currentIndex, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 10.0,
      currentIndex: currentIndex,
      type: .fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline_outlined),
          activeIcon: Icon(Icons.people),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_contact_cal_outlined),
          activeIcon: Icon(Icons.perm_contact_cal),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: Text("99+"),
            child: Icon(Icons.view_list_outlined),
          ),
          activeIcon: Badge(label: Text("99+"), child: Icon(Icons.view_list)),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "",
        ),
      ],
    );
  }
}
