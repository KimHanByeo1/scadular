import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/TextField.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/model/insert_data_model.dart';

class ContentTextField extends StatefulWidget {
  final String content;
  const ContentTextField(this.content, {Key? key}) : super(key: key);

  @override
  State<ContentTextField> createState() => _ContentTextFieldState();
}

class _ContentTextFieldState extends State<ContentTextField> {
  late TextEditingController contentController;
  late FocusNode _focusNode;

  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        getController.focusNodeObserver2.value = true;
      } else {
        getController.focusNodeObserver2.value = false;
      }
    });
    contentController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
      child: MyTextfield(
        onChanged: (result) {
          InsertDataModel.content = result.trim();
        },
        maxLines: 3,
        controller: contentController,
        autofocus: false,
        focusNode: _focusNode,
        labelText: '메모를 입력하세요.',
      ),
    );
  }
}
