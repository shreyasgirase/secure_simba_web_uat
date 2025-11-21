class Validators {
  static String? voterIdValidator(value) {
    final regex = RegExp(r'^[A-Z]{3}[0-9]{7}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your Voter ID';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid ID number';
    }
    return null;
  }

  static String? passportIdValidator(value) {
    final regex = RegExp(r'^[A-Z][0-9]{7}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your Passport ID';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid ID number';
    }
    return null;
  }

  static String? drivingLicenseValidator(value) {
    final regex = RegExp(r'^[A-Z]{2}\d{13}');
    if (value == null || value.isEmpty) {
      return 'Please enter your Driving License number';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid Driving License number';
    }
    return null;
  }

  static String? aadhaarLast4DigitsValidator(value) {
    final regex = RegExp(r'^[0-9]{4}$');
    if (value == null || value.isEmpty) {
      return 'Please enter the last 4 digits of your Aadhaar';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid Aadhar number';
    }
    return null;
  }

  static String? emailValidator(value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? phoneNumberValidator(value) {
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? kycValiation(value) {
    if (value!.isEmpty) {
      return 'Please Enter the CKYC ID';
    } else if (int.parse(value) == 0) {
      return 'Please Enter valid CKYC ID';
    } else if (value.length < 14) {
      return 'Please Enter 14-Digit CKYC ID';
    }
    final singleDigitRegex = RegExp(
        r'^(?!.*(0{14}|1{14}|2{14}|3{14}|4{14}|5{14}|6{14}|7{14}|8{14}|9{14})).*$');
    if (!singleDigitRegex.hasMatch(value)) {
      return 'Please Enter valid CKYC';
    }
    return null;
  }

  static String? panValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter PAN Number';
    }
    final alphanumericRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Please enter a valid PAN Number';
    }
    if (value == '0') {
      return 'Please enter a valid PAN Number';
    }
    return null;
  }

  static String? aadharNumberValidation(value) {
    if (value!.isEmpty) {
      return 'Please Enter the Aadhar Card Number';
    } else if (int.parse(value) == 0) {
      return 'Please Enter valid Aadhar Card Number';
    } else if (value.length < 4) {
      return ' Last 4 digits is required';
    }
    return null;
  }

  static String? aadharNameValidation(value) {
    if (value!.isEmpty) {
      return 'Please Enter the Customer Full Name';
    } else if (value.trim() != value) {
      return 'Please Enter Valid Name';
    }
    return null;
  }

  static String? companyIdValidation(value) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    if (value!.isEmpty) {
      return 'Please Enter the CIN';
    } else if (value.length != 21) {
      return 'Please Enter 21-Digit CIN';
    } else if (!alphanumeric.hasMatch(value)) {
      return 'Only alphanumeric characters are allowed';
    }
    return null;
  }

  static String? registrationNumberValidation(value) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9(){}\[\]\\]+$');

    if (value == null || value.isEmpty) {
      return 'Registration number is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid Registration number';
    }
    return null;
  }

  static String? otherDocsValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Other document name is required';
    }
    if (!RegExp(r'^(?!\s+$).*$').hasMatch(value)) {
      return 'Please enter valid document name.';
    }
    return null;
  }

  static String? nameValidation(value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter Valid $label';
    } else if (value.trim() != value) {
      return 'Please Enter Valid Name';
    }
    return null;
  }

  static String? formValidation(value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please Enter $label';
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9-]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Please Enter $label';
    }
    if (value == '0') {
      return 'Please Enter Valid $label’ ';
    }
    return null;
  }

  static String? remarkValidation(value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please Enter remark';
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9-\[\]\(\)_@. \s\S]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Please Enter valid remark';
    }
    if (value == '0') {
      return 'Please Enter valid remark’ ';
    }
    return null;
  }

  static String? policyNumberValidation(value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please Enter $label';
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9-]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Please Enter $label';
    }
    return null;
  }

  static String? phoneNumberValidation(value) {
    if (value!.isEmpty) {
      return 'Please Enter the Mobile Number';
    } else if (int.parse(value) == 0) {
      return 'Please Enter valid Mobile Number';
    } else if (value.length < 10) {
      return 'Please Enter valid 10-Digit Mobile Number';
    }
    return null;
  }
}
