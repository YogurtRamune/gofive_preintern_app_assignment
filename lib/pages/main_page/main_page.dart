import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/pages/main_page/contact_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Widget currentPage = ContactPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _ButtonNav(
        onTap: (w) => setState(() => currentPage = w),
        contact: ContactPage(),
      ), 
      body: currentPage,
    );
  }
}

class _ButtonNav extends StatefulWidget {
  final Widget? home;
  final Widget? calendar;
  final Widget? people;
  final Widget? contact;
  final Widget? todo;
  final Widget? me;
  final void Function(Widget)? _onTap;
  const _ButtonNav({
    this.home,
    this.calendar,
    this.people,
    this.contact,
    this.todo,
    this.me,
    void Function(Widget)? onTap,
    super.key,
  }) : _onTap = onTap;

  @override
  State<_ButtonNav> createState() => _ButtonNavState();
}

class _ButtonNavState extends State<_ButtonNav> {
  int _index = 3;

  @override
  Widget build(BuildContext context) {
    void onTap([Widget? w]) => widget._onTap?.call(w ?? Placeholder());
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            onTap(widget.home);
          case 1:
            onTap(widget.calendar);
          case 2:
            onTap(widget.people);
          case 3:
            onTap(widget.contact);
          case 4:
            onTap(widget.todo);
          case 5:
            onTap(widget.me);
          case _:
            onTap();
        }
        setState(() {
          _index = index;
        });
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 10.0,
      currentIndex: _index,
      type: .fixed,
      items: [
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
          icon: Badge(label: Text("99+"), child: Icon(Icons.view_list_outlined)),
          activeIcon: Badge(
            label: Text("99+"),
            child: Icon(Icons.view_list),
          ),
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
