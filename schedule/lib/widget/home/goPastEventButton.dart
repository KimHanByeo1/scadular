import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/widget/home/pastEvent.dart';

class GoPastEventButton extends StatelessWidget {
  const GoPastEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: SizedBox(
        // width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.046,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ElevatedButton(
            onPressed: () {
              StaticModel.eventDataToFetched = 'pastEvent';
              Get.to(() => const GoPastEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '지난 이벤트 보러가기',
                  style:
                      TextStyle(color: context.theme.colorScheme.onBackground),
                ),
                Expanded(
                  child: Container(),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.theme.colorScheme.onBackground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
