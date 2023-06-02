import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/TextField.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/model/insert_data_model.dart';

class TitleTextField extends StatefulWidget {
  final String title;
  const TitleTextField(this.title, {Key? key}) : super(key: key);

  @override
  State<TitleTextField> createState() => TitleTextFieldState();
}

class TitleTextFieldState extends State<TitleTextField> {
  late TextEditingController titleController;
  late FocusNode _focusNode;

  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        getController.focusNodeObserver.value = true;
      } else {
        getController.focusNodeObserver.value = false;
      }
    });
    titleController.text = widget.title;
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
      child: MyTextfield(
        onChanged: (result) {
          InsertDataModel.title = result.trim();
        },
        maxLines: 1,
        controller: titleController,
        autofocus: true,
        focusNode: _focusNode,
        labelText: '일정을 입력하세요.',
      ),
    );
  }
}
