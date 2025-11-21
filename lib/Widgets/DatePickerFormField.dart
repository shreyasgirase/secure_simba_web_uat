// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:secure_app/Widgets/Style.dart';

// ignore: must_be_immutable
class DatePickerFormField extends StatefulWidget {
  final String labelText;
  final String date;
  final bool disabled;
  final bool? required;
  bool backdate;

  final Function(DateTime?) onChanged;

  DatePickerFormField(
      {Key? key,
      required this.labelText,
      required this.date,
      required this.onChanged,
      this.disabled = false,
      this.backdate = false,
      this.required})
      : super(key: key ?? ObjectKey(DateTime.now()));

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   if (widget.disabled) return; // Do nothing if disabled

  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       widget.onChanged(_selectedDate);
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.disabled) return; // Do nothing if disabled

    final DateTime firstDate = DateTime.now().subtract(const Duration(days: 6));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.backdate == true ? firstDate : DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.onChanged(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 230,
          child: InkWell(
            onTap: widget.disabled ? null : () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                isCollapsed: false,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
                // labelText: widget.labelText,
                label: widget.required == true
                    ? Style.requiredFieldLabel(widget.labelText, 14)
                    : Style.notRequiredFieldLabel(widget.labelText, 14),

                floatingLabelStyle: Style.labelStyle(14),
                border: Style.borderStyle(widget.disabled),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.date,
                      style: Style.inputValueStyle(widget.disabled)),
                  Icon(
                    Icons.calendar_today,
                    size: 15,
                    color: widget.disabled
                        ? Colors.grey
                        : const Color.fromRGBO(143, 19, 168, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}
