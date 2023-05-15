import 'package:flutter/material.dart';
import 'package:scadule/view/home.dart';
import 'package:scadule/view/calendar.dart';
import 'package:get/get.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          Home(),
          Calendar(),
        ],
      ),
      bottomNavigationBar: Container(
        color: context.theme.colorScheme.background,
        child: TabBar(
          indicatorColor: context.theme.colorScheme.background,
          labelPadding: const EdgeInsets.symmetric(vertical: 18),
          controller: controller,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          tabs: [
            Tab(
              icon: Image.asset(
                _selectedIndex == 0 ? 'images/home2.png' : 'images/home.png',
                width: 24,
                height: 24,
                color: context.theme.colorScheme.outline,
              ),
              // label: 'home',
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.calendar_month_sharp
                    : Icons.calendar_month_outlined,
                color: context.theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
