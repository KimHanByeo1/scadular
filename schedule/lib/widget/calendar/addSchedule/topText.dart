import 'package:flutter/material.dart';

class TopText extends StatelessWidget {
  final String result;
  const TopText(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Text(
            result == 'add' ? '일정 추가하기!!' : '일정 수정하기!!',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
