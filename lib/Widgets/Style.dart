// ignore_for_file: file_names

import "package:flutter/material.dart";

class Style {
  static RichText requiredFieldLabel(String label, int fontSize) {
    return RichText(
      text: TextSpan(text: label, style: labelStyle(fontSize), children: const [
        TextSpan(
            text: ' *',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14))
      ]),
    );
  }

  static Text notRequiredFieldLabel(String label, int fontSize) {
    return Text(
      label,
      style: labelStyle(fontSize),
    );
  }

  static TextStyle labelStyle(fontSize) {
    return TextStyle(
        fontSize: fontSize,
        color: const Color.fromRGBO(143, 19, 168, 1),
        fontWeight: FontWeight.bold,
        letterSpacing: 1);
  }

  static TextStyle hintStyle() {
    return const TextStyle(color: Colors.black54, fontSize: 12);
  }

  static TextStyle inputValueStyle(bool readOnly) {
    return TextStyle(
        fontSize: 13,
        color:
            readOnly ? const Color.fromARGB(255, 117, 113, 113) : Colors.black);
  }

  static OutlineInputBorder borderStyle(bool readOnly) {
    return OutlineInputBorder(
      borderSide: readOnly == true
          ? const BorderSide(color: Colors.blue, width: 2)
          : const BorderSide(color: Color.fromRGBO(143, 19, 168, 1), width: 2),
      borderRadius: BorderRadius.circular(6),
    );
  }

  static OutlineInputBorder focusedBorderStyle() {
    return OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color.fromRGBO(143, 19, 168, 1), width: 2),
      borderRadius: BorderRadius.circular(6),
    );
  }

  static Widget wrap(BuildContext context, {required List<Widget> children}) {
    return Wrap(
        spacing: 20,
        // runSpacing: 15,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: children
    );
  }

  static Widget background(
    BuildContext context,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      // height: double.infinity,
      // padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromRGBO(176, 34, 204, 0.2),
            Color.fromRGBO(13, 154, 189, 0.2),
          ])),
    );
  }

  static Widget formContainer(
      BuildContext context, String label, List<Widget> children) {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: const Color.fromRGBO(143, 19, 168, 1), width: 1.5)),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 35,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(143, 19, 168, 1),
                border: Border.all(
                    color: const Color.fromRGBO(143, 19, 168, 1), width: 1.5),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          ...children,
        ]));
  }

  static Widget formSubmitButton(String label, onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(130, 25, 151, 1),
                    Color.fromRGBO(14, 64, 139, 1),
                  ])),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert!"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

heightGap() {
  return const SizedBox(
    height: 10,
  );
}
