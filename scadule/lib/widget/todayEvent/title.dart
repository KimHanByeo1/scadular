import 'package:flutter/material.dart';

class TopTitle extends StatefulWidget {
  const TopTitle({super.key});

  @override
  State<TopTitle> createState() => _TopTitleState();
}

class _TopTitleState extends State<TopTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text(
          '2023년 04월 30일',
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
