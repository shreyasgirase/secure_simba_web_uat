// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:secure_app/Widgets/Style.dart';

class RadioButton {
  static Widget customRadio(
      BuildContext context, String label, mode, onChanged) {
    return Wrap(
        spacing: 20,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
              width: 320,
              height: 40,
              child: Style.requiredFieldLabel(label, 13)),
          SizedBox(
            width: 250,
            child: Row(
              children: [
                Radio(
                  activeColor: const Color.fromRGBO(143, 19, 168, 1),
                  value: 'Yes',
                  autofocus: false,
                  groupValue: mode,
                  onChanged: onChanged,
                ),
                const Text('Yes'),
                const SizedBox(
                  width: 30,
                ),
                Radio(
                  activeColor: const Color.fromRGBO(143, 19, 168, 1),
                  value: 'No',
                  autofocus: false,
                  groupValue: mode,
                  onChanged: onChanged,
                ),
                const Text('No'),
              ],
            ),
          ),
        ]);
  }

  static Widget customRadio2(BuildContext context, String label, mode,
      onChanged, String option1, String option2, String option3) {
    return Wrap(
        spacing: 20,
        runSpacing: 5,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 60,
            child: Center(child: Style.requiredFieldLabel(label, 13)),
          ),
          SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  activeColor: const Color.fromRGBO(143, 19, 168, 1),
                  value: option1,
                  autofocus: false,
                  groupValue: mode,
                  onChanged: onChanged,
                ),
                Text(option1),
                // const SizedBox(
                //   width: 50,
                // ),
                Radio(
                  activeColor: const Color.fromRGBO(143, 19, 168, 1),
                  value: option2,
                  autofocus: false,
                  groupValue: mode,
                  onChanged: onChanged,
                ),
                Text(option2),
                // const SizedBox(
                //   width: 50,
                // ),
                Radio(
                  activeColor: const Color.fromRGBO(143, 19, 168, 1),
                  value: option3,
                  autofocus: false,
                  groupValue: mode,
                  onChanged: onChanged,
                ),
                Text(option3),
              ],
            ),
          ),
        ]);
  }
}
