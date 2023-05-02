import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/controller/controller.dart';

class MiddleTextField extends StatefulWidget {
  const MiddleTextField({super.key});

  @override
  State<MiddleTextField> createState() => MiddleTextFieldState();
}

class MiddleTextFieldState extends State<MiddleTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    ever(getController.focusNodeObserver, (bool value) {
      if (value) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              color: context.theme.colorScheme.onBackground,
            ),
            decoration: InputDecoration(
              labelText: '일정을 입력하세요.',
              labelStyle: TextStyle(
                color: context.theme.colorScheme.onBackground,
              ),
              filled: true,
              fillColor: context.theme.colorScheme.surface,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.colorScheme.onBackground,
                ),
              ),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: context.theme.colorScheme.onBackground, // 커서 색상
            onSubmitted: (value) {},
          ),
        ],
      ),
    );
  }
}
