// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, file_names, library_private_types_in_public_api

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:secure_app/Widgets/Style.dart';

// ignore: must_be_immutable
class DropdownWidget extends StatefulWidget {
  final List<String> items;
  final value;
  final onChanged;
  final String label;
  final bool? required;

  final bool view;

  DropdownWidget(
      {required this.items,
      this.value = '',
      this.onChanged,
      this.label = '',
      this.view = false,
      this.required});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 230,
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              isCollapsed: false,
              isDense: true,
              label: widget.required == true
                  ? Style.requiredFieldLabel(widget.label, 14)
                  : Style.notRequiredFieldLabel(widget.label, 14),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 8),
              focusColor: const Color.fromRGBO(143, 19, 168, 1),
              focusedBorder: Style.focusedBorderStyle(),
              border: Style.borderStyle(widget.view),
            ),
            hint: widget.view == false
                ? Text(
                    "Please select ${widget.label}",
                    style: Style.hintStyle(),
                  )
                : null,
            items: widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item,
                    maxLines: 3, style: Style.inputValueStyle(widget.view)),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return '  Please Select ${widget.label}';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: widget.view == false ? widget.onChanged : null,
            onSaved: (value) {},
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            value: widget.value,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}

class DropdownWidget2 extends StatefulWidget {
  final List<String> items;
  final value;
  final onChanged;
  final String label;
  final bool? required;

  final bool view;

  DropdownWidget2(
      {required this.items,
      this.value = '',
      this.onChanged,
      this.label = '',
      this.view = false,
      this.required});

  @override
  _DropdownWidget2State createState() => _DropdownWidget2State();
}

class _DropdownWidget2State extends State<DropdownWidget2> {
  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 480,
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              isCollapsed: false,
              isDense: true,
              label: widget.required == true
                  ? Style.requiredFieldLabel(widget.label, 14)
                  : Style.notRequiredFieldLabel(widget.label, 14),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 8),
              focusColor: const Color.fromRGBO(143, 19, 168, 1),
              focusedBorder: Style.focusedBorderStyle(),
              border: Style.borderStyle(widget.view),
            ),
            hint: widget.view == false
                ? Text(
                    "Please select ${widget.label}",
                    style: Style.hintStyle(),
                  )
                : null,
            items: widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item,
                    maxLines: 3, style: Style.inputValueStyle(widget.view)),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return '  Please Select ${widget.label}';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: widget.view == false ? widget.onChanged : null,
            onSaved: (value) {},
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            value: widget.value,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}
