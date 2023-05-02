import 'package:flutter/material.dart';
import 'package:scadule/view/home.dart';
import 'package:scadule/view/calendar.dart';
import 'package:get/get.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  var _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.theme.colorScheme.background,
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            Home(),
            Calendar(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: context.theme.colorScheme.background,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0 ? 'images/home2.png' : 'images/home.png',
              width: 24,
              height: 24,
              color: context.theme.colorScheme.outline,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.calendar_month_sharp
                  : Icons.calendar_month_outlined,
              color: context.theme.colorScheme.outline,
            ),
            label: 'calendar',
          ),
        ],
      ),
    );
  }
}
