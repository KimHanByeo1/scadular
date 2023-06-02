import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/GetX/preferences.dart';

class AddScheduleButton extends StatelessWidget {
  final Function()? onPressed;
  const AddScheduleButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.colorScheme.surfaceVariant,
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '+ 일정을 추가하세요',
                  style: TextStyle(
                    color: context.theme.colorScheme.onBackground,
                    fontStyle: Preferences().loadFontValue()
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
