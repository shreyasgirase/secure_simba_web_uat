// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_app/Widgets/Style.dart';

// ignore: must_be_immutable
class CustomInputField2 extends StatelessWidget {
  final String? title;

  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator? validator;
  final onChanged;
  final maxLength;
  final value;
  final view;
  final maxLines;
  final minLines;
  var verifyButton;
  final bool? required;

  CustomInputField2(
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
      this.minLines,
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
          width: 480,
          child: TextFormField(
            readOnly: view,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            controller: controller,
            onChanged: onChanged,
            expands: false,
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
                // labelText: title,
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
        title == 'Policy Number'
            ? verifyButton
            : const SizedBox(
                height: 14,
              ),
      ],
    );
  }
}
