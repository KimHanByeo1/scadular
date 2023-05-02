import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/view/preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        title: Text(
          'My App',
          style: TextStyle(
            color: context.theme.colorScheme.outline,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const Preferences());
            },
          ),
        ],
      ),
      body: Container(
        color: context.theme.colorScheme.background,
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
