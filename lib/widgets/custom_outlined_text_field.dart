import 'package:flutter/material.dart';
import 'package:tripcompanion/widgets/custom_text_field_base.dart';

class CustomOutlinedTextField extends CustomTextFieldBase {
  CustomOutlinedTextField(
      {String hintText,
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
      Color textColor})
      : super(
            hintText: hintText,
            keyboardType: keyboardType,
            obscured: obscured ?? false,
            onChanged: onChanged,
            textEditingController: textEditingController,
            action: action,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            enabled: enabled ?? true,
            maxLines: maxLines ?? 1,
            backgroundColor: backgroundColor ?? Colors.white,
            textColor: textColor ?? Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Color.fromARGB(20, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                offset: Offset(1, 1),
                blurRadius: 3),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextField(
            decoration: InputDecoration(
//                labelText: hintText,
              hintText: hintText,
              border: InputBorder.none,
            ),
            style: TextStyle(color: textColor),
            obscureText: obscured,
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
