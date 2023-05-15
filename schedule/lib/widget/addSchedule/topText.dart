import 'package:flutter/material.dart';
import 'package:scadule/component/preferences.dart';

class TopText extends StatelessWidget {
  const TopText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Text(
            '일정 추가하기!!',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontStyle: Preferences().loadFontValue()
                  ? FontStyle.normal
                  : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
