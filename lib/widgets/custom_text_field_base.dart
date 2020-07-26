import 'package:flutter/material.dart';

abstract class CustomTextFieldBase extends StatelessWidget{
  final String hintText;
  final TextInputType keyboardType;
  final bool obscured;
  final bool enabled;
  final Function onChanged;
  final TextEditingController textEditingController;
  final TextInputAction action;
  final FocusNode focusNode;
  final Function onEditingComplete;
  final int maxLines;

  const CustomTextFieldBase({
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    this.obscured: false,
    this.onChanged,
    this.textEditingController,
    this.action:TextInputAction.done,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    this.maxLines
  });

  @override
  Widget build(BuildContext context);


}