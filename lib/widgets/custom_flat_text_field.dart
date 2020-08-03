import 'package:flutter/material.dart';
import 'package:tripcompanion/widgets/custom_text_field_base.dart';

class CustomFlatTextField extends CustomTextFieldBase {

  CustomFlatTextField({
    String hintText,
    TextInputType keyboardType,
    bool obscured,
    Function onChanged,
    TextEditingController textEditingController,
    TextInputAction action,
    FocusNode focusNode,
    Function onEditingComplete,
    bool enabled,
    int maxLines,
    Color backgroundColor,
    Color textColor
  }) : super(
          hintText: hintText,
          keyboardType: keyboardType??TextInputType.text,
          obscured: obscured??false,
          onChanged: onChanged,
          textEditingController: textEditingController,
          action: action,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          enabled: enabled,
          maxLines: maxLines??1,
          backgroundColor: backgroundColor??Colors.white,
          textColor: textColor??Colors.black
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            style: TextStyle(color: textColor),
            obscureText: super.obscured,
            keyboardType: keyboardType,
            onChanged: onChanged,
            controller: textEditingController,
            textInputAction: action,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            enabled: enabled,
            maxLines: maxLines,

          ),
        ),
      ),
    );
  }
}
