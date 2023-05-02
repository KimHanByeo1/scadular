import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/model/model.dart';

class BottomWidget extends StatefulWidget {
  final StateSetter stateSetter;
  const BottomWidget({
    super.key,
    required this.stateSetter,
  });

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  late Rx<bool> iconData = false.obs;
  late Rx<bool> calendarOnOff = false.obs;
  late Rx<bool> contentOnOff = false.obs;

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
          height: MediaQuery.of(context).size.height * 0.057,
        ),
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              calendarOnOff.toggle();
              setState(() {
                if (calendarOnOff.value) {
                  getController.focusNodeObserver.value = true;
                } else {
                  getController.focusNodeObserver.value = false;
                }
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                const Icon(Icons.calendar_month),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.015,
                ),
                Obx(
                  () => calendarOnOff.value
                      // iconData 타입 수정하고
                      // return 값 '오늘', '내일', '기간 일정' 으로 변경
                      ? Text(iconData.value ? '오늘' : '내일')
                      : const Icon(Icons.keyboard_arrow_up),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
          ),
        ),
        calendarOnOff.value ? addScheduleIconList() : calendarIconList()
      ],
    );
  }

  Widget addScheduleIconList() {
    return Row(
      children: [
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              contentOnOff.toggle();
              widget.stateSetter(
                () {
                  contentOnOff.value
                      ? Model.height = 0.8
                      : Model.height = 0.583;
                },
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                Obx(
                  () => Icon(
                    contentOnOff.value
                        ? Icons.content_paste_off_outlined
                        : Icons.content_paste_go_outlined,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
        ),
        SizedBox(
          width: 100,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.background,
            ),
            child: DropdownButton(
              value: "Kingdom",
              items: const [
                DropdownMenuItem(value: "Kingdom", child: Text("Kingdom")),
                DropdownMenuItem(value: "Canada", child: Text("Canada")),
                DropdownMenuItem(value: "Russia", child: Text("Russia"))
              ],
              onChanged: (value) {
                //
              },
              icon: null,
              style: TextStyle(
                  color: context.theme.colorScheme.onBackground, fontSize: 15),
              dropdownColor: context.theme.colorScheme.background,
              isExpanded: true,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
        ),
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              //
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                Image.asset(
                  'images/next.png',
                  color: context.theme.colorScheme.onBackground,
                  width: 24,
                  height: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget calendarIconList() {
    return Row(
      children: [
        // Obx(
        //   () =>
        // ),
        textComponent('하루', 0),
        textComponent('기간', 1),
        textComponent('다중', 2),
      ],
    );
  }

  Widget textComponent(String text, int index) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selected = index;
              Model.qwe = index;
            });
          },
          style: TextButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0,
            ),
            backgroundColor: context.theme.colorScheme.surface,
            side: BorderSide(
              color: _selected == index
                  ? context.theme.colorScheme.secondary
                  : context.theme.colorScheme.secondary,
              width: _selected == index ? 2 : 0,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Dow(
            text: text,
            color: context.theme.colorScheme.onBackground,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
