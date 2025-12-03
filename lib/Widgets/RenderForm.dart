import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Widgets/DropdownWidget.dart';
import 'package:secure_app/Widgets/Style.dart';

class InsuranceForm extends StatefulWidget {
  final Function getDetails;
  final String? subType;
  final String fillDetails;
  final List? fields;
  final bool isView;

  const InsuranceForm(
      {super.key,
      required this.getDetails,
      this.subType,
      this.fields,
      this.fillDetails = '',
      this.isView = false});

  @override
  _InsuranceFormState createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<InsuranceForm> {
  Map<String, dynamic> newValue = {};
  Map<String, String> dropdownValue = {};

  List<String> gender = [
    'Male',
    'Female',
  ];
  List<String> maritalStatus = [
    'Married',
    'Unmarried',
  ];
  List<String> salutation = ['Mr', 'Mrs', 'Miss'];
  bool required = true;
  final List<String> regNoType = ['State', 'BH'];
  // String? _gender;

  String? _lastSelectedRegNoType;

  @override
  void initState() {
    super.initState();
    print('render form ${widget.isView}');
    _initializeControllers();
    _lastSelectedRegNoType =
        Provider.of<AppState>(context, listen: false).selectedRegNO;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = Provider.of<AppState>(context);

    if (appState.selectedRegNO != _lastSelectedRegNoType) {
      // Use a post-frame callback to safely update the UI
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          newValue.forEach((key, controller) {
            if (key.startsWith("Block") &&
                controller is TextEditingController) {
              controller.clear();
            }
          });
          _lastSelectedRegNoType = appState.selectedRegNO;
          // Also update the parent widget that the details are now empty
          widget.getDetails(endorsementDetails());
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant InsuranceForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subType != oldWidget.subType) {
      _initializeControllers();
    }
  }

  void _initializeControllers() async {
    print("gg");

    Map? data;
    if (widget.fillDetails != '') {
      data = jsonDecode(widget.fillDetails);
    }
    print(widget.fields);
    setState(() {
      newValue.forEach((_, controller) {
        if (controller is TextEditingController) {
          controller.dispose();
        }
      });
      newValue = {};

      widget.fields!.forEach((field) {
        if (widget.fillDetails != '') {
          if (field["field_name"] == "Gender" ||
              field["field_name"] == "Courtesy Title" ||
              field["field_name"] == "Marital Status") {
            newValue[field["field_name"]] = data![field["field_name"]];
          } else {
            newValue[field["field_name"]] =
                TextEditingController(text: data![field["field_name"]]);
          }
          // if (field["field_name"] != "Gender") {
          //   newValue[field["field_name"]] =
          //       TextEditingController(text: data![field["field_name"]]);
          // } else if (field["field_name"] == "Gender") {
          //   dropdownValue[field["field_name"]] = data![field["field_name"]];
          // }
          print(field["field_name"]);
        } else {
          if (field["field_name"] == "Gender" ||
              field["field_name"] == "Courtesy Title" ||
              field["field_name"] == "Marital Status") {
            newValue[field["field_name"]] = null;
          } else {
            newValue[field["field_name"]] = TextEditingController();
          }
          // if (field["field_name"] != "Gender") {
          //   newValue[field["field_name"]] = TextEditingController();
          // } else if (field["field_name"] == "Gender") {
          //   dropdownValue[field["field_name"]] = '';
          // }
        }
      });
    });

    print(newValue);
    print(dropdownValue);
  }

  @override
  void dispose() {
    newValue.forEach((_, controller) {
      if (controller is TextEditingController) {
        controller.dispose();
      }
    });
    // dropdownValue.forEach((_, value) {});
    super.dispose();
  }

  Map<String, dynamic> endorsementDetails() {
    return <String, dynamic>{
      "new_value": jsonEncode(
        newValue.map((key, controller) {
          return MapEntry(
              key,
              controller is TextEditingController
                  ? controller.text
                  : controller);
        }),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Wrap(
      spacing: 20,
      // runSpacing: 15,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: widget.fields != null
          ? widget.fields!.map<Widget>((field) {
              final fieldName = field["field_name"].toString();
              if (fieldName.startsWith("Block") &&
                  appState.selectedRegNO == null) {
                return const SizedBox.shrink(); // This hides the widget
              }
              if(appState.selectedRegNO == "hide") {
                return const SizedBox.shrink();
              }
              if (field["field_name"] != "Gender" &&
                  field["field_name"] != "Courtesy Title" &&
                  field["field_name"] != "Marital Status") {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 230,
                      child: (appState.selectedRegNO == "Other" &&
                              (field["field_name"] == "Block 2" ||
                                  field["field_name"] == "Block 3" ||
                                  field["field_name"] == "Block 4"))
                          ? const SizedBox.shrink() // hide these fields
                          : TextFormField(
                              expands: false,
                              enabled: widget.isView == false,
                              controller: newValue[field["field_name"]],
                              onChanged: (value) {
                                widget.getDetails(endorsementDetails());
                              },
                              maxLength:
                                  field["field_name"] == 'date of birth' ||
                                          field["field_name"] == 'Date of Birth'
                                      ? 10
                                      : null,
                              style: Style.inputValueStyle(widget.isView),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                floatingLabelStyle: Style.labelStyle(14),
                                isCollapsed: false,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                // labFelText: field["field_name"],
                                label: field["field_name"] !=
                                            "Loan Account Number" &&
                                        field["field_name"] != "Address"
                                    ? Style.requiredFieldLabel(
                                        field["field_name"],
                                        field["field_name"].length > 50
                                            ? 11
                                            : 14)
                                    : Style.notRequiredFieldLabel(
                                        field["field_name"], 14),

                                hintText: widget.isView
                                    ? "N/A"
                                    : "Please enter ${field["field_name"]}",
                                hintStyle: const TextStyle(
                                    color: Colors.black54, fontSize: 12),

                                focusedBorder: Style.focusedBorderStyle(),
                                prefixIconColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return const Color.fromRGBO(
                                        143, 19, 168, 1);
                                  }
                                  return Colors.grey;
                                }),

                                border: Style.borderStyle(widget.isView),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: field["field_name"] !=
                                          "Loan Account Number" &&
                                      field["field_name"] != "Address"
                                  ? (value) {
                                      final appState = Provider.of<AppState>(
                                          context,
                                          listen: false);
                                      if (appState.selectedRegNO == "Other" &&
                                          (field["field_name"] == "Block 2" ||
                                              field["field_name"] ==
                                                  "Block 3" ||
                                              field["field_name"] ==
                                                  "Block 4")) {
                                        return null;
                                      }
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please Enter ${field["field_name"]}';
                                      }
                                      if (appState.selectedRegNO == "BH") {
                                        if (field["field_name"] == "Block 1") {
                                          if (!RegExp(r'^\d{2}$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 2 digits';
                                          }
                                        }
                                        if (field["field_name"] == "Block 2") {
                                          if ("BH" != value) {
                                            return 'Must be BH only';
                                          }
                                        }
                                        if (field["field_name"] == "Block 3") {
                                          if (!RegExp(r'^\d{4}$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 4 digits';
                                          }
                                        }
                                        if (field["field_name"] == "Block 4") {
                                          if (!RegExp(r'^[A-Z]$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 1 capital letter';
                                          }
                                        }
                                      }
                                      if (appState.selectedRegNO == "State") {
                                        if (field["field_name"] == "Block 1") {
                                          if (!RegExp(r'^[A-Z]{2}$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 2 capital letters';
                                          }
                                        }
                                        if (field["field_name"] == "Block 2") {
                                          if (!RegExp(r'^\d{2}$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 2 digits';
                                          }
                                        }
                                        if (field["field_name"] == "Block 3") {
                                          if (!RegExp(r'^[A-Z]{1,4}$')
                                              .hasMatch(value)) {
                                            return 'Min 1 and Max 4 capital letters are allowed';
                                          }
                                        }
                                        if (field["field_name"] == "Block 4") {
                                          if (!RegExp(r'^\d{4}$')
                                              .hasMatch(value)) {
                                            return 'Must be exactly 4 digits';
                                          }
                                        }
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                );
              } else if (field["field_name"] == "Gender" ||
                  field["field_name"] == "Courtesy Title" ||
                  field["field_name"] == "Marital Status") {
                return DropdownWidget(
                  items: field["field_name"] == "Gender"
                      ? gender
                      : field["field_name"] == "Courtesy Title"
                          ? salutation
                          : field["field_name"] == "Marital Status"
                              ? maritalStatus
                              : [],
                  view: widget.isView,
                  label: field["field_name"],
                  onChanged: (value) {
                    newValue[field["field_name"]] = value;
                    widget.getDetails(endorsementDetails());
                  },
                  value: newValue[field["field_name"]],
                  required: required,
                );
              }
              return Container();
            }).toList()
          : [SizedBox.shrink()],
    );
  }
}
