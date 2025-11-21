// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_import, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_app/Widgets/Style.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator? validator;
  final onChanged;
  final maxLength;
  final value;
  final view;
  final maxLines;

  var verifyButton;
  final bool? required;

  CustomInputField(
      {super.key,
      this.title,
      this.controller,
      this.inputFormatters,
      this.validator,
      this.onChanged,
      this.maxLength,
      this.value,
      this.view = false,
      this.maxLines,
      this.verifyButton,
      this.required});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 230,
          child: TextFormField(
            autofocus: false,
            readOnly: view,
            maxLines: maxLines,
            maxLength: maxLength,
            controller: controller,
            onChanged: view == true ? null : onChanged,
            expands: false,
            showCursor: view == true ? false : null,
            mouseCursor: view == true ? SystemMouseCursors.forbidden : null,
            style: Style.inputValueStyle(view),
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: Style.labelStyle(14),
                isCollapsed: false,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                counterText: "",
                focusedBorder: Style.focusedBorderStyle(),
                border: Style.borderStyle(view),
                label: required == true
                    ? Style.requiredFieldLabel(title!, 14)
                    : Style.notRequiredFieldLabel(title!, 14),
                hintText: view == false ? "Please enter $title" : null,
                hintStyle: Style.hintStyle()),
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: inputFormatters,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        // title == 'Policy Number'
        //     ? verifyButton
        //     : const SizedBox(
        //         height: 14,
        //       ),
      ],
    );
  }
}
