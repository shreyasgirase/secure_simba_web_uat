import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:secure_app/Validations/validators.dart';
import 'package:secure_app/Widgets/DatePickerFormField.dart';
import 'package:secure_app/Widgets/DropdownWidget.dart';
import 'package:secure_app/Widgets/InputField1.dart';
import 'package:secure_app/Widgets/Style.dart';

class KycCommonFunctions {
  static Widget heigth() {
    return const SizedBox(height: 10);
  }

  static Widget kycQuestion() {
    return SizedBox(
      width: 320,
      child: Wrap(
        spacing: 2,
        children: [
          Style.requiredFieldLabel('CKYC Available?', 13),
          const Text(
            '(W.e.f 01st January 2023, CKYC ID creation is mandatory for all the policies at the time of Inception of risk for both Individual and Organization Customers) ',
            maxLines: 6,
            style: TextStyle(
              color: Color.fromRGBO(143, 19, 168, 1),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  static Widget kycRadioButton(value, onChanged1, onChanged2) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Radio(
              activeColor: const Color.fromRGBO(143, 19, 168, 1),
              autofocus: false,
              value: 'Yes',
              groupValue: value,
              onChanged: onChanged1),
          const Text('Yes'),
          const SizedBox(
            width: 30,
          ),
          Radio(
              activeColor: const Color.fromRGBO(143, 19, 168, 1),
              autofocus: false,
              value: 'No',
              groupValue: value,
              onChanged: onChanged2),
          const Text('No'),
        ],
      ),
    );
  }

  static Widget kycInputField(bool readOnly, TextEditingController controller) {
    return CustomInputField(
        required: true,
        view: readOnly,
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLength: 14,
        title: 'CKYC ID',
        validator: Validators.kycValiation);
  }

  static Widget dateField(
      BuildContext context, readOnly, String label, onChanged, date) {
    return Style.wrap(context, children: [
      DatePickerFormField(
        required: true,
        disabled: readOnly,
        labelText: label,
        onChanged: onChanged,
        date: date,
      )
    ]);
  }

  static Widget fetchButton(onPressed) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(143, 19, 168, 1),
      ),
      child: TextButton(
          onPressed: onPressed,
          child: const Text(
            'Fetch CKYC Details',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  static Widget panInputField(
    BuildContext context,
    readOnly,
    TextEditingController controller,
    onChanged,
  ) {
    return CustomInputField(
        required: true,
        view: readOnly,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        maxLength: 10,
        controller: controller,
        onChanged: onChanged,
        title: 'PAN Number',
        validator: Validators.panValidation);
  }

  static Widget aadharNumberInputField(
      readOnly, TextEditingController controller) {
    return CustomInputField(
        required: true,
        view: readOnly,
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLength: 4,
        title: 'Last 4 digits of Aadhar Number',
        validator: Validators.aadharNumberValidation);
  }

  static Widget aadharNameInputField(
    readOnly,
    TextEditingController controller,
  ) {
    return CustomInputField(
      required: true,
      view: readOnly,
      controller: controller,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
      ],
      validator: Validators.aadharNameValidation,
      onChanged: (value) {
        controller.value = TextEditingValue(
            text: value.toUpperCase(), selection: controller.selection);
      },
      title: 'Customer Full Name as per Aadhar Card',
    );
  }

  static Widget companyIdInputField(
    readOnly,
    TextEditingController controller,
  ) {
    return CustomInputField(
      required: true,
      view: readOnly,
      maxLength: 21,
      controller: controller,
      title: 'CIN',
      validator: Validators.companyIdValidation,
    );
  }

  static Widget familyDetailsNameInput(
      String label, bool readOnly, TextEditingController controller) {
    return CustomInputField(
      maxLines: 1,
      required: label == 'Middle Name' ? false : true,
      view: readOnly,
      controller: controller,
      title: label,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
      ],
      validator: label != 'Middle Name'
          ? (value) {
              return Validators.nameValidation(value, label);
            }
          : null,
    );
  }

  static Widget customDropDown(
      String label, onChanged, items, value, bool readonly) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownWidget(
            required: true,
            view: readonly,
            items: items,
            value: value,
            onChanged: onChanged,
            label: label,
          )
        ]);
  }

  static Widget ckycFetchedContainer(
    BuildContext context,
    String kycType,
    String customerName,
    String ckycID,
    String dob,
    String address,
    bool view,
  ) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromRGBO(143, 19, 168, 1), width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            children: [
              ckycFetchedDetailsRow(
                  context, 'Customer Name:', customerName, true),
              ckycFetchedDetailsRow(context, 'CKYC ID:', ckycID, true),
              ckycFetchedDetailsRow(
                  context,
                  kycType == "Other" ? 'DOI:' : 'DOB:',
                  view
                      ? dob
                      : DateFormat("yyyy-MM-dd")
                          .format(DateFormat("dd-MMM-yyyy").parse(dob))
                          .toString(),
                  kycType == "Other" ? false : true),
              kycType == 'Individual'
                  ? ckycFetchedDetailsRow(context, 'Address:', address, false)
                  : const Text('')
            ],
          ),
        ));
  }

  static Widget ckycFetchedDetailsRow(
      BuildContext context, String label, data, bool borderLine) {
    return Container(
      // height: 20,
      padding: const EdgeInsets.fromLTRB(5, 12, 0, 12),
      decoration: BoxDecoration(
          border: borderLine
              ? const Border(
                  bottom: BorderSide(
                  color: Colors.black45,
                  width: 1,
                ))
              : null),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.18,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Text(
              '$data',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static Widget noKYC(
      BuildContext context, String option, onpressedForEdit, onpressedForNext) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.black38),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              // margin: const EdgeInsets.fromLTRB(30, 300, 30, 300),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color:
                        //  Color.fromRGBO(231, 181, 229, 0.9),
                        Color.fromRGBO(15, 5, 158, 0.4),
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: Offset(
                      3.0, // Move to right 5  horizontally
                      3.0, // Move to bottom 5 Vertically
                    ),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Alert!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    heigth(),
                    Text(
                        'CKYC Information is unavailable/not fetched using entered details.Please try with $option option.',
                        maxLines: 5,
                        style: const TextStyle(
                            fontSize: 13,
                            decoration: TextDecoration.none,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                    heigth(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onpressedForEdit,
                            child: const Text('EDIT',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(15, 5, 158, 1),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: onpressedForNext,
                            child: const Text('NEXT',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(15, 5, 158, 1),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  static Widget editKYC(BuildContext context, onpressedForNo, onpressedForYes) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.black38),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(15, 5, 158, 0.4),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(
                        3.0,
                        3.0,
                      )),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Alert!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    heigth(),
                    const Text('Do you want to edit CKYC Information ?',
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 13,
                            decoration: TextDecoration.none,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                    heigth(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onpressedForNo,
                            child: const Text('No',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(15, 5, 158, 1),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: onpressedForYes,
                            child: const Text('Yes',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(15, 5, 158, 1),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
