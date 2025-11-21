// ignore_for_file: unused_import, unnecessary_import, avoid_web_libraries_in_flutter, prefer_typing_uninitialized_variables, annotate_overrides, avoid_print, avoid_init_to_null, use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:html' as html;
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Widgets/DocumentFunctions.dart';
import 'package:secure_app/Widgets/InputField2.dart';
import 'package:secure_app/Widgets/KycCommonFunctions.dart';
import 'package:secure_app/Widgets/NavBar.dart';
import 'package:secure_app/Widgets/DatePickerFormField.dart';
import 'package:secure_app/Widgets/DropdownWidget.dart';
import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
import 'package:secure_app/Widgets/PdfViewer.dart';
import 'package:secure_app/Widgets/InputContainer.dart';
import 'package:secure_app/Widgets/InputField1.dart';
import 'package:secure_app/Widgets/RadioButton.dart';
import 'package:secure_app/Widgets/isLoading.dart';
import 'package:secure_app/Widgets/Style.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Utility/dioSingleton.dart';
import 'package:secure_app/Screens/endorsementDocuments.dart';
import 'package:secure_app/Validations/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_button/timer_button.dart';

class KYCIndividual extends StatefulWidget {
  final inwardData;
  final inwardType;
  final isEdit;
  final isView;
  final edit;
  final onlinePay;
  final premiumAmount;
  final customerName;
  final customerEmail;
  final customerMobile;
  const KYCIndividual(
      {super.key,
      required this.inwardData,
      required this.inwardType,
      this.isEdit = false,
      this.isView = false,
      this.edit = false,
      this.onlinePay = false,
      this.premiumAmount,
      this.customerName,
      this.customerEmail,
      this.customerMobile});

  @override
  State<KYCIndividual> createState() => _KYCIndividualState();
}

class _KYCIndividualState extends State<KYCIndividual> {
  var productName;
  File? galleryFile;

  final picker = ImagePicker();
  String? _kycAvailable;
  String? _panAvailable;
  String? _aadharAvailable;
  String? _gender;
  String? _member;
  String? selectedValue;
  String? selectedDocument;
  String? selectedAddress;

  Map<String, List> kycDocument = {
    'customerPhoto': [''],
    'idProof': ['', ''],
    'addressProof': ['', '']
  };
  Map<String, List<bool>> kycDocumentLoader = {
    'customerPhoto': [false],
    'idProof': [false, false],
    'addressProof': [false, false]
  };

  String birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> documents = <String>[
    // 'PAN Card',
    // 'Form 60',
    // 'Form 61',
  ];
  Map<String, int> documentIds = {"id_proof": 0, "address_proof": 0};

  List<String> address = <String>[
    // 'Voter ID',
    // 'Passport',
    // 'Driving License',
    // 'Masked Aadhar'
  ];
  List<String> allDocuments = <String>[];
  String option = '';
  // var _accessToken = '';
  bool isFetched = false;
  bool isSubmitted = false;
  bool fetchKYC = true;
  bool noKYC = false;
  String salutation = 'Mr';
  TextEditingController panNumberController = TextEditingController();
  TextEditingController ckycIDController = TextEditingController();
  TextEditingController adhaarNumberController = TextEditingController();
  TextEditingController adhaarNameController = TextEditingController();
  TextEditingController salutationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idProofController = TextEditingController();
  TextEditingController addressProofController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String inputType = '';
  String inputNo = '';
  Dio dio = DioSingleton.dio;
  Map ckycData = {
    "CKYCNumber": "",
    "CKYCFullName": "",
    "CKYCDOB": "",
    "CKYCAddress": ""
  };
  final _formKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  bool editKYC = false;
  bool edit = false;
  bool isLoading = false;
  bool kyc = false;
  bool pan = false;
  bool isPan = false;
  bool isAadhar = false;
  bool aadhar = false;
  bool manual = false;
  bool fetchKyc = false;
  bool fetchPan = false;
  bool fetchAadhar = false;
  bool enableCKYC = false;
  bool enablePan = false;
  bool enableAadharNo = false;
  bool enableAadharName = false;
  bool enable2 = false;
  bool disable = false;
  bool uploading = false;
  bool required = true;
  bool isViewButton = false;
  bool loadingDoc = false;
  bool verifyOtp = false;
  bool resendOtp = true;
  bool mobileNo = false;
  var transactionId;
  String otpMessage = '';
  String verifyOtpMessage = '';
  int buttonCounter = 3;
  var onChanged;
  var onChanged2;
  var onChanged3;
  var onChanged4;
  var onChanged5;
  var onChanged6;
  var oldVersion;
  var checkKYC;
  var ckycExist;
  var paymentLink;
  final ValueNotifier<MouseCursor> _cursorNotifier =
      ValueNotifier<MouseCursor>(SystemMouseCursors.basic);

  void initState() {
    super.initState();

    print('thisss');
    print(widget.isEdit);
    print(widget.edit);

    // if (widget.edit == false && widget.isEdit) {
    //   setState(() {
    //     editKYC = false;
    //   });
    // } else if (widget.edit == false && widget.isEdit == false) {
    //   setState(() {
    //     editKYC = false;
    //   });
    // } else if (widget.isEdit || widget.edit) {
    //   setState(() {
    //     editKYC = true;
    //   });
    // }
    getVersion();
    getManualDetails();
    if (widget.isView) {
      getVersion();
      getCKYCDetails();
    }
    setState(() {
      onChanged = (value) {
        if (_kycAvailable != value) {
          resetVariable();
          // kyc = false;
          isPan = false;
          pan = false;
          isAadhar = false;
          aadhar = false;
          manual = false;
          fetchPan = false;
          fetchAadhar = false;
        }
        setState(() {
          _kycAvailable = value;
        });
        if (_kycAvailable == 'Yes') {
          setState(() {
            kyc = true;
            fetchKyc = true;
            isPan = false;
            pan = false;
            isAadhar = false;
            aadhar = false;
            manual = false;
            fetchPan = false;
            fetchAadhar = false;
            otpController = TextEditingController();
          });
        }
      };
      onChanged2 = (value) {
        if (_kycAvailable != value) {
          resetVariable();
          // kyc = false;
          kyc = false;
          fetchKyc = false;
          isPan = false;
          pan = false;
          fetchPan = false;
          isAadhar = false;
          fetchAadhar = false;
          aadhar = false;
          manual = false;
        }
        setState(() {
          _kycAvailable = value;
        });
        if (_kycAvailable == 'No') {
          setState(() {
            // _panAvailable = 'Yes';
            ckycIDController = TextEditingController();
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isAadhar = false;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          });
        }
      };
      onChanged3 = (value) {
        if (_panAvailable != value) {
          setState(() {
            _aadharAvailable = null;
            _gender = null;
            _member = null;
            birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

            adhaarNumberController = TextEditingController();
            adhaarNameController = TextEditingController();
            salutationController = TextEditingController();
            firstNameController = TextEditingController();
            middleNameController = TextEditingController();
            lastNameController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();
            // kyc = true;
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isAadhar = false;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          });
        }
        setState(() {
          _panAvailable = value;
        });
        if (_panAvailable == 'Yes') {
          setState(() {
            if (_kycAvailable == 'Yes') {
              kyc = true;
              fetchKyc = false;
            } else {
              ckycIDController = TextEditingController();
              kyc = false;
            }
            otpController = TextEditingController();
            fetchKyc = false;
            isPan = true;
            pan = true;
            fetchPan = true;
            isAadhar = false;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          });
        }
        if (_panAvailable == 'No') {
          setState(() {
            if (_kycAvailable == 'Yes') {
              kyc = true;
              fetchKyc = false;
            } else {
              ckycIDController = TextEditingController();
              kyc = false;
            }
            otpController = TextEditingController();
            panNumberController = TextEditingController();
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isAadhar = true;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          });
        }
        // if (value == 'Yes') {
        //   setState(() {
        //     _aadharAvailable = 'No';
        //     pan = true;
        //     fetchPan = true;
        //   });
        // }
        // if (value == 'No') {
        //   setState(() {
        //     _aadharAvailable = null;
        //     _gender = null;
        //     pan = false;
        //     isAadhar = true;
        //     fetchKyc = false;
        //     fetchPan = false;
        //   });
        // }
      };
      onChanged4 = (value) {
        if (_aadharAvailable != value) {
          setState(() {
            _member = null;
            birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
            adhaarNumberController = TextEditingController();
            adhaarNameController = TextEditingController();
            _gender = null;
            // ckycIDController = TextEditingController();

            salutationController = TextEditingController();
            firstNameController = TextEditingController();
            middleNameController = TextEditingController();
            lastNameController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();

            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isAadhar = true;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          });
        }
        setState(() {
          _aadharAvailable = value;
        });
        if (_aadharAvailable == 'Yes') {
          setState(() {
            if (_kycAvailable == 'Yes') {
              kyc = true;
              fetchKyc = false;
            } else {
              ckycIDController = TextEditingController();
              kyc = false;
              fetchKyc = false;
            }
            if (_panAvailable == 'Yes') {
              isPan = true;
              pan = true;
              fetchPan = false;
            } else {
              panNumberController = TextEditingController();
              isPan = true;
              pan = false;
              fetchPan = false;
            }
            otpController = TextEditingController();
            // adhaarNumberController =
            //     TextEditingController();
            // adhaarNameController =
            //     TextEditingController();
            // _gender = null;

            isAadhar = true;
            fetchAadhar = true;
            aadhar = true;
            manual = false;
          });
        }
        if (_aadharAvailable == 'No') {
          setState(() {
            if (_kycAvailable == 'Yes') {
              kyc = true;
              fetchKyc = false;
            } else {
              ckycIDController = TextEditingController();
              kyc = false;
              fetchKyc = false;
            }
            if (_panAvailable == 'Yes') {
              isPan = true;
              pan = true;
              fetchPan = false;
            } else {
              panNumberController = TextEditingController();
              isPan = true;
              pan = false;
              fetchPan = false;
            }
            otpController = TextEditingController();
            adhaarNumberController = TextEditingController();
            adhaarNameController = TextEditingController();
            _gender = null;
            isAadhar = true;
            fetchAadhar = false;
            aadhar = false;
            manual = true;
            onChanged = null;
            onChanged2 = null;
            onChanged3 = null;
            onChanged4 = null;
            onChanged5 = null;
            disable = true;
            enableCKYC = true;
            enablePan = true;
            enableAadharNo = true;
            enableAadharName = true;
          });
        }
        // if (value == 'Yes') {
        //   setState(() {
        //     aadhar = true;
        //     fetchAadhar = true;
        //   });
        // }
        // if (value == 'No') {
        //   setState(() {
        //     aadhar = false;
        //     manual = true;
        //     fetchKyc = false;
        //     fetchPan = false;
        //     fetchAadhar = false;
        //   });
        // }
      };
      onChanged5 = (value) {
        setState(() {
          _gender = value;
        });
      };
      onChanged6 = (value) {
        setState(() {
          _member = value;
        });
      };
    });
    // getToken();
    // fetchCKYC();
  }

  areKycDocumentsValid(Map<String, List<dynamic>> documents) {
    if (documents['customerPhoto']![0] == '') {
      return "Customer Photo";
    }
    if (documents['idProof']![0] == '' && documents['idProof']![1] == '') {
      return "Id Proof";
    }
    if (documents['addressProof']![0] == '' &&
        documents['addressProof']![1] == '') {
      return "Id Proof";
    }
    return '';
  }

  resetVariable() {
    setState(() {
      _panAvailable = null;
      _aadharAvailable = null;
      isPan = false;
      pan = false;
      isAadhar = false;
      aadhar = false;
      enableCKYC = false;
      enablePan = false;
      enableAadharName = false;
      enableAadharNo = false;
      manual = false;
      disable = false;
      enable2 = false;
      _gender = null;
      _member = null;
      salutation = 'Mr';
      birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      selectedValue = null;
      selectedDocument = null;
      selectedAddress = null;
      panNumberController = TextEditingController();
      ckycIDController = TextEditingController();
      adhaarNumberController = TextEditingController();
      adhaarNameController = TextEditingController();
      salutationController = TextEditingController();
      firstNameController = TextEditingController();
      middleNameController = TextEditingController();
      lastNameController = TextEditingController();
      idProofController = TextEditingController();
      addressProofController = TextEditingController();
      mobileNoController = TextEditingController();
      otpController = TextEditingController();

      isSubmitted = false;
      Map ckycData = {"CKYCNumber": "", "CKYCFullName": "", "CKYCDOB": ""};
      isFetched = false;
      manual = false;
      resendOtp = true;
      kycDocument = {
        'customerPhoto': [''],
        'idProof': ['', ''],
        'addressProof': ['', '']
      };
      setState(() {
        onChanged = (value) {
          if (_kycAvailable != value) {
            resetVariable();
            // kyc = false;
            isPan = false;
            pan = false;
            isAadhar = false;
            aadhar = false;
            manual = false;
            fetchPan = false;
            fetchAadhar = false;
          }
          setState(() {
            _kycAvailable = value;
          });
          if (_kycAvailable == 'Yes') {
            setState(() {
              kyc = true;
              fetchKyc = true;
              isPan = false;
              pan = false;
              isAadhar = false;
              aadhar = false;
              manual = false;
              fetchPan = false;
              fetchAadhar = false;
            });
          }
        };
        onChanged2 = (value) {
          if (_kycAvailable != value) {
            resetVariable();

            kyc = false;
            fetchKyc = false;
            isPan = false;
            pan = false;
            fetchPan = false;
            isAadhar = false;
            fetchAadhar = false;
            aadhar = false;
            manual = false;
          }
          setState(() {
            _kycAvailable = value;
          });
          if (_kycAvailable == 'No') {
            setState(() {
              ckycIDController = TextEditingController();
              kyc = false;
              fetchKyc = false;
              isPan = true;
              pan = false;
              fetchPan = false;
              isAadhar = false;
              fetchAadhar = false;
              aadhar = false;
              manual = false;
            });
          }
        };
        onChanged3 = (value) {
          if (_panAvailable != value) {
            setState(() {
              _aadharAvailable = null;
              _gender = null;
              _member = null;
              birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
              adhaarNumberController = TextEditingController();
              adhaarNameController = TextEditingController();
              salutationController = TextEditingController();
              firstNameController = TextEditingController();
              middleNameController = TextEditingController();
              lastNameController = TextEditingController();
              idProofController = TextEditingController();
              addressProofController = TextEditingController();
              kyc = false;
              fetchKyc = false;
              isPan = true;
              pan = false;
              fetchPan = false;
              isAadhar = false;
              fetchAadhar = false;
              aadhar = false;
              manual = false;
            });
          }
          setState(() {
            _panAvailable = value;
          });
          if (_panAvailable == 'Yes') {
            setState(() {
              if (_kycAvailable == 'Yes') {
                kyc = true;
                fetchKyc = false;
              } else {
                ckycIDController = TextEditingController();
                kyc = false;
              }
              fetchKyc = false;
              isPan = true;
              pan = true;
              fetchPan = true;
              isAadhar = false;
              fetchAadhar = false;
              aadhar = false;
              manual = false;
            });
          }
          if (_panAvailable == 'No') {
            setState(() {
              if (_kycAvailable == 'Yes') {
                kyc = true;
                fetchKyc = false;
              } else {
                ckycIDController = TextEditingController();
                kyc = false;
              }
              panNumberController = TextEditingController();
              fetchKyc = false;
              isPan = true;
              pan = false;
              fetchPan = false;
              isAadhar = true;
              fetchAadhar = false;
              aadhar = false;
              manual = false;
            });
          }
        };
        onChanged4 = (value) {
          if (_aadharAvailable != value) {
            setState(() {
              _member = null;
              birthDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
              adhaarNumberController = TextEditingController();
              adhaarNameController = TextEditingController();
              _gender = null;
              salutationController = TextEditingController();
              firstNameController = TextEditingController();
              middleNameController = TextEditingController();
              lastNameController = TextEditingController();
              idProofController = TextEditingController();
              addressProofController = TextEditingController();
              kyc = false;
              fetchKyc = false;
              isPan = true;
              pan = false;
              fetchPan = false;
              isAadhar = true;
              fetchAadhar = false;
              aadhar = false;
              manual = false;
            });
          }
          setState(() {
            _aadharAvailable = value;
          });
          if (_aadharAvailable == 'Yes') {
            setState(() {
              if (_kycAvailable == 'Yes') {
                kyc = true;
                fetchKyc = false;
              } else {
                ckycIDController = TextEditingController();
                kyc = false;
                fetchKyc = false;
              }
              if (_panAvailable == 'Yes') {
                isPan = true;
                pan = true;
                fetchPan = false;
              } else {
                panNumberController = TextEditingController();
                isPan = true;
                pan = false;
                fetchPan = false;
              }
              isAadhar = true;
              fetchAadhar = true;
              aadhar = true;
              manual = false;
            });
          }
          if (_aadharAvailable == 'No') {
            setState(() {
              if (_kycAvailable == 'Yes') {
                kyc = true;
                fetchKyc = false;
              } else {
                ckycIDController = TextEditingController();
                kyc = false;
                fetchKyc = false;
              }
              if (_panAvailable == 'Yes') {
                isPan = true;
                pan = true;
                fetchPan = false;
              } else {
                panNumberController = TextEditingController();
                isPan = true;
                pan = false;
                fetchPan = false;
              }
              adhaarNumberController = TextEditingController();
              adhaarNameController = TextEditingController();
              _gender = null;
              isAadhar = true;
              fetchAadhar = false;
              aadhar = false;
              manual = true;
              onChanged = null;
              onChanged2 = null;
              onChanged3 = null;
              onChanged4 = null;
              onChanged5 = null;
              disable = true;
              enableCKYC = true;
              enablePan = true;
              enableAadharNo = true;
              enableAadharName = true;
            });
          }
        };
        onChanged5 = (value) {
          setState(() {
            _gender = value;
          });
        };
        onChanged6 = (value) {
          setState(() {
            _member = value;
          });
        };
      });
    });
  }

  fetchCKYC() async {
    String firstName = '';
    String middleName = '';
    String lastName = '';
    var adhaarNameValue = adhaarNameController.text.split(' ');
    if (adhaarNameValue.length == 3) {
      firstName = adhaarNameValue[0];
      middleName = adhaarNameValue[1];
      lastName = adhaarNameValue[2];
    }
    if (adhaarNameValue.length == 2) {
      firstName = adhaarNameValue[0];
      middleName = adhaarNameValue[1];
    }
    if (adhaarNameValue.length == 1) {
      firstName = adhaarNameValue[0];
    }

    setState(() {
      isLoading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, dynamic> kycData = {
      "ckycData": {
        "A99RequestData": {
          "source": "secure",
          "GetRecordType": "IND",
          "InputIdType": inputType,
          "InputIdNo": inputNo,
          "DateOfBirth": birthDate,
          "MobileNumber": mobileNoController.text,
          "Pincode": "",
          "BirthYear": "",
          "Tags": "",
          "ApplicationRefNumber": "",
          "FirstName": firstName,
          "MiddleName": middleName,
          "LastName": lastName,
          "Gender": _gender?.split('')[0].toUpperCase() ?? "",
          "ResultLimit": "Latest",
          "ParentCompany": "SC775",
          "ReturnURL": "",
          "VerByPass": "N"
        }
      },
      "proposal_id": appState.proposalId
    };
    // Map<String, dynamic> kycData = {
    //   "A99RequestData": {
    //     "RequestId": "ITSECURE${DateTime.now().millisecondsSinceEpoch}",
    //     "source": "gromoinsure",
    //     "policyNumber": "",
    //     "GetRecordType": "IND",
    //     "InputIdType": inputType,
    //     "InputIdNo": inputNo,
    //     "DateOfBirth": birthDate,
    //     "MobileNumber": "",
    //     "Pincode": "",
    //     "BirthYear": "",
    //     "Tags": "",
    //     "ApplicationRefNumber": "",
    //     "FirstName": firstName,
    //     "MiddleName": middleName,
    //     "LastName": lastName,
    //     "Gender": _gender ?? '',
    //     "ResultLimit": "Latest",
    //     "photo": "",
    //     "AdditionalAction": ""
    //   }
    // };
    print(kycData);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    String result = aesCbcEncryptJson(jsonEncode(kycData));
    Map<String, dynamic> encryptedData = {'encryptedData': result};
    print(encryptedData);
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/ckycSearch',
          data: encryptedData,
          options: Options(headers: headers));

      String decryptedData = aesCbcDecryptJson(response.data);

      var data = jsonDecode(decryptedData);
      print(data);
      setState(() {
        isLoading = false;
        transactionId = data['CKYCTransactionID'];
        otpMessage = data['CKYCSuccessDescription'];
        verifyOtp = true;
        // isFetched = true;
        // ckycData = data;

        // isSubmitted = true;
        // fetchKYC = false;
        // if (_kycAvailable == 'Yes') {
        //   fetchKyc = false;
        // }
        // if (_panAvailable == 'Yes') {
        //   fetchKyc = false;
        //   fetchPan = false;
        // }
        // if (_aadharAvailable == 'Yes') {
        //   fetchKyc = false;
        //   fetchPan = false;
        //   fetchAadhar = false;
        // }
        // onChanged = null;
        // onChanged2 = null;
        // onChanged3 = null;
        // onChanged4 = null;
        // onChanged5 = null;
        // onChanged6 = null;
        // disable = true;
        // enableCKYC = true;
        // enablePan = true;
        // enableAadharNo = true;
        // enableAadharName = true;
        // enable2 = true;
        // enableMobileNo = true;
        // mobileNo = true;
        // enableMobileNo = true;
      });
    } on DioException catch (error) {
      print(error);
      print(error.response?.data);
      String decryptedData = aesCbcDecryptJson(error.response?.data);

      var data = jsonDecode(decryptedData);
      print(data);
      setState(() {
        isLoading = false;
        isFetched = false;
        noKYC = true;
        verifyOtp = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
      // if (_aadharAvailable == 'Yes') {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: const Text(
      //           "No CKYC Record found for the given Aadhar Card Details"),
      //       action: SnackBarAction(
      //         label: ' Cancel',
      //         onPressed: () {},
      //       )));
      // } else if (_panAvailable == 'Yes') {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: const Text("No CKYC Record found for this PAN Number"),
      //       action: SnackBarAction(
      //         label: ' Cancel',
      //         onPressed: () {},
      //       )));
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: const Text("No Records Found!"),
      //       action: SnackBarAction(
      //         label: ' Cancel',
      //         onPressed: () {},
      //       )));
      // }
    }
  }

  verifyOtpAndFetchDetails(String isResendOtp, String otp) async {
    print('verifying');
    String firstName = '';
    String middleName = '';
    String lastName = '';
    var adhaarNameValue = adhaarNameController.text.split(' ');
    if (adhaarNameValue.length == 3) {
      firstName = adhaarNameValue[0];
      middleName = adhaarNameValue[1];
      lastName = adhaarNameValue[2];
    }
    if (adhaarNameValue.length == 2) {
      firstName = adhaarNameValue[0];
      middleName = adhaarNameValue[1];
    }
    if (adhaarNameValue.length == 1) {
      firstName = adhaarNameValue[0];
    }

    setState(() {
      isLoading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    Map<String, dynamic> kycData = {
      "ckycData": {
        "A99RequestData": {
          "InputIdType": inputType,
          "InputIdNo": inputNo,
          "source": "secure",
          "DateOfBirth": birthDate,
          "Tags": "",
          "ParentCompany": "SC775",
          "ApplicationRefNumber": "",
          "FirstName": firstName,
          "MiddleName": middleName,
          "LastName": lastName,
          "Gender": _gender?.split('')[0].toUpperCase() ?? "",
          "GetRecordType": "IND",
          "ResultLimit": "Latest",
          "MobileNumber": mobileNoController.text,
          "Pincode": "",
          "BirthYear": "",
          "ReturnURL": "",
          "VerByPass": "N",
          "OTP": otp,
          "CKYCTransactionID": transactionId,
          "IsResendOTP": isResendOtp
        }
      },
      "proposal_id": appState.proposalId
    };
    String result = aesCbcEncryptJson(jsonEncode(kycData));
    Map<String, dynamic> encryptedData = {'encryptedData': result};
    print(encryptedData);
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/fetchCkyc',
          data: encryptedData,
          options: Options(headers: headers));

      String decryptedData = aesCbcDecryptJson(response.data);
      print(decryptedData);
      var data = jsonDecode(decryptedData);
      print(data);
      if (isResendOtp == 'false') {
        setState(() {
          isLoading = false;
          verifyOtp = false;
          isFetched = true;
          ckycData = data;
          print(ckycData);
          print(ckycData['CKYCNumber']);

          isSubmitted = true;
          fetchKYC = false;
          if (_kycAvailable == 'Yes') {
            fetchKyc = false;
          }
          if (_panAvailable == 'Yes') {
            fetchKyc = false;
            fetchPan = false;
          }
          if (_aadharAvailable == 'Yes') {
            fetchKyc = false;
            fetchPan = false;
            fetchAadhar = false;
          }
          onChanged = null;
          onChanged2 = null;
          onChanged3 = null;
          onChanged4 = null;
          onChanged5 = null;
          onChanged6 = null;
          disable = true;
          enableCKYC = true;
          enablePan = true;
          enableAadharNo = true;
          enableAadharName = true;
          enable2 = true;
          mobileNo = true;
          resendOtp = true;
        });
      } else if (isResendOtp == 'true') {
        setState(() {
          isLoading = false;
          verifyOtp = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('OTP is resent to the registered mobile number')),
        );
      }
    } on DioException catch (error) {
      print(error);
      print(error.response?.data);
      String decryptedData = aesCbcDecryptJson(error.response?.data);

      var data = jsonDecode(decryptedData);
      print(data);
      setState(() {
        verifyOtpMessage = data['message'];
        Timer(Duration(seconds: 5), () {
          setState(() {
            verifyOtpMessage = ""; // Clear the message after 5 seconds
          });
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
      setState(() {
        isLoading = false;
        isFetched = false;
        // noKYC = true;
        if (isResendOtp == 'true') {
          setState(() {
            verifyOtp = false;
          });
        } else {
          setState(() {
            if (buttonCounter > 0) {
              buttonCounter--;
            }
            print(" attempts $buttonCounter");
          });
          setState(() {
            verifyOtp = true;
          });
        }

        if (buttonCounter == 0) {
          setState(() {
            verifyOtp = false;
            otpController = TextEditingController();
            buttonCounter = 3;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  'OTP verification attempts are exhausted; please revalidate CKYC details.'),
              action: SnackBarAction(
                label: ' Cancel',
                onPressed: () {},
              )));
        }
      });
    }
  }

  Future<String> uploadCkycDocs(proposalId, html.FormData formData) async {
    final appState = Provider.of<AppState>(context, listen: false);

    String? returnString = "";
    final completer = Completer<String>();
    final request = html.HttpRequest();
    request
      ..open('POST', 'https://uatcld.sbigeneral.in/SecureApp/proposalDocument')
      ..setRequestHeader('Authorization', appState.accessToken)
      ..onLoadEnd.listen((e) {
        if (request.status == 200) {
          print("");
          completer.complete("");
        } else {
          print('Upload failed');
          completer.complete("Failed to upload documents");
        }
      })
      ..send(formData);

    returnString = await completer.future;
    return returnString;
  }

  sendCkyc(kycData, formData) async {
    setState(() {
      isLoading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      String result = aesCbcEncryptJson(
        jsonEncode({"proposal_detail_id": appState.proposalId, ...kycData}),
      );

      Map<String, dynamic> encryptedCkycData = {'encryptedData': result};

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": appState.accessToken
      };
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/postCkycDetails',
          data: encryptedCkycData,
          options: Options(headers: headers));
      print(response.data);
      // print(formData.files);

      // sendPaymentLink();
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProposalDocuments(
      //             inwardData: widget.inwardData,
      //             inwardType: widget.inwardType,
      //             isView: widget.isView,
      //             isEdit: widget.isEdit,
      //             ckycData: kycData,
      //             ckycDocuments: null)));
      if (ckycData['CKYCFullName'] != "") {
        // if (widget.onlinePay && paymentLink == null) {
        //   await sendPaymentLink(kycData);
        // } else {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProposalDocuments(
                    inwardData: widget.inwardData,
                    inwardType: widget.inwardType,
                    isView: widget.isView,
                    isEdit: widget.isEdit,
                    ckycData: kycData,
                    ckycDocuments: null))).then((value) {
          setState(() {
            editKYC = true;
          });
        });
        // }
      } else {
        String uploadDocResult =
            await uploadCkycDocs(appState.proposalId, formData);
        print(uploadDocResult);

        if (uploadDocResult == "") {
          // if (widget.onlinePay && paymentLink == null) {
          //   sendPaymentLink(kycData);
          // } else {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProposalDocuments(
                      inwardData: widget.inwardData,
                      inwardType: widget.inwardType,
                      isView: widget.isView,
                      isEdit: widget.isEdit,
                      ckycData: kycData,
                      ckycDocuments: null))).then((value) {
            setState(() {
              editKYC = true;
            });
          });
          ;
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(uploadDocResult),
              action: SnackBarAction(
                label: ' Cancel',
                onPressed: () {},
              )));
        }
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  getManualDetails() async {
    setState(() {
      isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    try {
      final response = await dio.get(
          'https://uatcld.sbigeneral.in/SecureApp/documentIdsIndividualCkyc',
          options: Options(headers: headers));
      var data = jsonDecode(response.data);
      print(data);
      setState(() {
        documents = List.from(data['id_proof']);
        address = List.from(data['address_proof']);
        allDocuments = List.from(data['documentIds']);
      });
      print('worksa');
      print(allDocuments);
      print('${allDocuments.indexOf('Masked Aadhar')}');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              "Error Fetching ID Proof and Adress Proof types. Try again!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  getVersion() async {
    print('version');
    setState(() {
      isLoading = true;
    });
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      Map<String, String> headers = {"Authorization": appState.accessToken};
      Map<String, dynamic> postData = {'proposal_id': appState.proposalId};
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/getCkycDocVersion',
          data: postData,
          options: Options(headers: headers));
      var data = jsonDecode(response.data);
      print(data);
      setState(() {
        oldVersion = data['latestDocVersion'];
        checkKYC = data['ckycAvailable'];
        ckycExist = data['ckyc_exist'];
        paymentLink = data['payment_status'];
      });

      print(data);
      print(data['ckyc_exist']);
      if (widget.isView == false) {
        if (data['ckyc_exist'] != null) {
          setState(() {
            editKYC = true;
          });
        } else {
          setState(() {
            editKYC = false;
          });
        }
      }

      if (widget.isView == false) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print("error ${err}");
    }
  }

  // sendPaymentLink(kycData) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final appState = Provider.of<AppState>(context, listen:e false);
  //     Map<String, String> headers = {"Authorization": appState.accessToken};
  //     Map<String, dynamic> postData = {
  //       "proposal_id": appState.proposalId,
  //       "customerName": widget.customerName,
  //       "customerEmail": widget.customerEmail,
  //       "customerMobileNo": widget.customerMobile,
  //       "amount": double.parse(widget.premiumAmount).toStringAsFixed(2),
  //     };
  //     final response = await dio.post(
  //         'https://uatcld.sbigeneral.in/SecureApp/payment/razorpay',
  //         data: postData,
  //         options: Options(headers: headers));
  //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     //     content: const Text(
  //     //         "A payment link has been sent to your registered number. Please process the payment to complete your endorsement request."),
  //     //     action: SnackBarAction(
  //     //       label: ' Cancel',
  //     //       onPressed: () {},
  //     //     )));
  //     var data = jsonDecode(response.data);
  //     print(data['message']);

  //     setState(() {
  //       isLoading = false;
  //     });
  //     showDialog<void>(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text(
  //               'Payment Link Sent',
  //               style: TextStyle(fontSize: 15, color: Colors.black),
  //             ),
  //             content: const Text(
  //               "A payment link has been sent to your registered number. Please process the payment to complete your endorsement request",
  //               style: TextStyle(fontSize: 12, color: Colors.black54),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('Ok'),
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => ProposalDocuments(
  //                               inwardData: widget.inwardData,
  //                               inwardType: widget.inwardType,
  //                               isView: widget.isView,
  //                               isEdit: widget.isEdit,
  //                               ckycData: kycData,
  //                               ckycDocuments: null)));
  //                 },
  //               ),
  //             ],
  //           );
  //         });

  // if (ckycData['CKYCFullName'] != null || ckycData['CKYCFullName'] != "") {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ProposalDocuments(
  //               inwardData: widget.inwardData,
  //               inwardType: widget.inwardType,
  //               isView: widget.isView,
  //               isEdit: widget.isEdit,
  //               ckycData: {},
  //               ckycDocuments: null)));
  // }
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (err) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(err);
  //   }
  // }

  Future<bool> editCkycDocuments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await uploadCkycDocuments(appState.proposalId);
      print('done edit');
      setState(() {
        isLoading = false;
      });
      return false;
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Documents not editted. Try again!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
      return true;
    }
  }

  Future<String> uploadCkycDocuments(proposalId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    // Map<String, String> headers = {"Authorization": appState.accessToken};
    html.FormData formData = html.FormData();
    double newVersion = oldVersion == 0 ? 1.0 : double.parse(oldVersion) + 0.1;
    print(newVersion);
    formData.append('proposal_id', proposalId.toString());
    formData.append('version', newVersion.toStringAsFixed(1));
    print('version : ${newVersion.toStringAsFixed(1)}');
    for (var i = 0; i < kycDocument['idProof']!.length; i++) {
      if (kycDocument['idProof']![i] != '') {
        var fileExtension =
            kycDocument['idProof']![i]['file'].name.split('.').last;
        formData.appendBlob('files', kycDocument['idProof']![i]['file'],
            '${allDocuments.indexOf(selectedDocument!) + 1}_page${i + 1}.$fileExtension');
      }
    }
    for (var i = 0; i < kycDocument['addressProof']!.length; i++) {
      if (kycDocument['addressProof']![i] != '') {
        var fileExtension =
            kycDocument['addressProof']![i]['file'].name.split('.').last;
        formData.appendBlob('files', kycDocument['addressProof']![i]['file'],
            '${allDocuments.indexOf(selectedAddress!) + 1}_page${i + 1}.$fileExtension');
      }
    }
    for (var i = 0; i < kycDocument['customerPhoto']!.length; i++) {
      if (kycDocument['customerPhoto']![i] != '') {
        var fileExtension =
            kycDocument['customerPhoto']![i]['file'].name.split('.').last;
        formData.appendBlob('files', kycDocument['customerPhoto']![i]['file'],
            '${allDocuments.indexOf('Photograph') + 1}_page${i + 1}.$fileExtension');
      }
    }

    String? returnString = null;
    final completer = Completer<String>();
    final request = html.HttpRequest();
    request
      ..open(
          'POST', 'https://uatcld.sbigeneral.in/SecureApp/updateCkycDocuments')
      ..setRequestHeader('Authorization', appState.accessToken)
      ..onLoadEnd.listen((e) {
        if (request.status == 200) {
          print("");
          completer.complete("");
        } else {
          print('Upload failed');
          completer.complete("Upload failed");
        }
      })
      ..send(formData);

    returnString = await completer.future;
    return returnString;
  }

  // editCkyc(kycData, formData, context) async {
  //   print('editedd');
  //   setState(() {
  //     isLoading = true;
  //   });
  //   print(kycData);

  //   try {
  //     final appState = Provider.of<AppState>(context, listen: false);
  //     print(appState.proposalId);

  //     String result = aesCbcEncryptJson(
  //       jsonEncode({"proposal_detail_id": appState.proposalId, ...kycData}),
  //     );

  //     Map<String, dynamic> encryptedCkycData = {'encryptedData': result};

  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       "Accept": "application/json",
  //       "Authorization": appState.accessToken
  //     };
  //     final response = await dio.post(
  //         'https://uatcld.sbigeneral.in/SecureApp/updateCkycDetails',
  //         data: encryptedCkycData,
  //         options: Options(headers: headers));
  //     //        if (ckycData['CKYCFullName'] != "") {
  //     //   if (widget.onlinePay) {
  //     //     sendPaymentLink(kycData);
  //     //   } else {
  //     //     setState(() {
  //     //       isLoading = false;
  //     //     });
  //     //     Navigator.push(
  //     //         context,
  //     //         MaterialPageRoute(
  //     //             builder: (context) => ProposalDocuments(
  //     //                 inwardData: widget.inwardData,
  //     //                 inwardType: widget.inwardType,
  //     //                 isView: widget.isView,
  //     //                 isEdit: widget.isEdit,
  //     //                 ckycData: kycData,
  //     //                 ckycDocuments: null)));
  //     //   }
  //     // } else {
  //     //   String uploadDocResult =
  //     //       await uploadCkycDocs(appState.proposalId, formData);
  //     //   print(uploadDocResult);

  //     //   if (uploadDocResult == "") {
  //     //     if (widget.onlinePay) {

  //     //       sendPaymentLink(kycData);
  //     //     } else {
  //     //       setState(() {
  //     //         isLoading = false;
  //     //       });
  //     //       Navigator.push(
  //     //           context,
  //     //           MaterialPageRoute(
  //     //               builder: (context) => ProposalDocuments(
  //     //                   inwardData: widget.inwardData,
  //     //                   inwardType: widget.inwardType,
  //     //                   isView: widget.isView,
  //     //                   isEdit: widget.isEdit,
  //     //                   ckycData: kycData,
  //     //                   ckycDocuments: null)));
  //     //     }
  //     if (ckycData['CKYCFullName'] != null || ckycData['CKYCFullName'] != "") {
  //       // sendPaymentLink();
  //       // setState(() {
  //       //   isLoading = false;
  //       // });
  //       // Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //         builder: (context) => ProposalDocuments(
  //       //             inwardData: widget.inwardData,
  //       //             inwardType: widget.inwardType,
  //       //             isView: widget.isView,
  //       //             isEdit: widget.isEdit,
  //       //             ckycData: kycData,
  //       //             ckycDocuments: null)));
  //       if (widget.onlinePay && paymentLink == null) {
  //         await sendPaymentLink(kycData);
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ProposalDocuments(
  //                     inwardData: widget.inwardData,
  //                     inwardType: widget.inwardType,
  //                     isView: widget.isView,
  //                     isEdit: widget.isEdit,
  //                     ckycData: kycData,
  //                     ckycDocuments: null))).then((value) {
  //           setState(() {
  //             editKYC = true;
  //           });
  //           // return;
  //         });
  //       }
  //     } else {
  //       bool ckycError = await editCkycDocuments();
  //       print(response.data);
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (ckycError) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: const Text("Ckyc Documents not editted!"),
  //             action: SnackBarAction(
  //               label: ' Cancel',
  //               onPressed: () {},
  //             )));
  //         return;
  //       } else {
  //         if (widget.onlinePay && paymentLink == null) {
  //           await sendPaymentLink(kycData);
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProposalDocuments(
  //                       inwardData: widget.inwardData,
  //                       inwardType: widget.inwardType,
  //                       isView: widget.isView,
  //                       isEdit: widget.isEdit,
  //                       ckycData: kycData,
  //                       ckycDocuments: formData))).then((value) {
  //             setState(() {
  //               editKYC = true;
  //             });
  //             // return;
  //           });
  //         }
  //       }
  //     }
  //   } catch (err) {
  //     print(err);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  editCkyc(kycData, formData, context) async {
    print('editedd');
    setState(() {
      isLoading = true;
    });
    print(kycData);

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      print(appState.proposalId);

      String result = aesCbcEncryptJson(
        jsonEncode({"proposal_detail_id": appState.proposalId,"user_id":appState.userId, ...kycData}),
      );

      Map<String, dynamic> encryptedCkycData = {'encryptedData': result};

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": appState.accessToken
      };
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/updateCkycDetails',
          data: encryptedCkycData,
          options: Options(headers: headers));

      if (ckycData['CKYCFullName'] != "") {
        // if (widget.onlinePay && paymentLink == null) {
        //   await sendPaymentLink(kycData);
        // } else {

        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProposalDocuments(
                    inwardData: widget.inwardData,
                    inwardType: widget.inwardType,
                    isView: widget.isView,
                    isEdit: widget.isEdit,
                    ckycData: kycData,
                    ckycDocuments: null))).then((value) {
          setState(() {
            editKYC = true;
          });
        });
        // }
      } else {
        bool ckycError = await editCkycDocuments();
        print(response.data);
        setState(() {
          isLoading = false;
        });
        if (ckycError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Ckyc Documents not editted!"),
              action: SnackBarAction(
                label: ' Cancel',
                onPressed: () {},
              )));
          return;
        } else {
          // if (widget.onlinePay && paymentLink == null) {
          //   await sendPaymentLink(kycData);
          // } else {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProposalDocuments(
                      inwardData: widget.inwardData,
                      inwardType: widget.inwardType,
                      isView: widget.isView,
                      isEdit: widget.isEdit,
                      ckycData: kycData,
                      ckycDocuments: null))).then((value) {
            setState(() {
              editKYC = true;
            });
          });
          // }
        }
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitKYC(String? ckycType, context) async {
    if (widget.isView) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProposalDocuments(
                  inwardData: {"product": productName},
                  inwardType: widget.inwardType,
                  ckycData: null,
                  ckycDocuments: null)));
      return;
    }
    Map kycData;
    Map responseCkyc;
    if (ckycType == 'Manual') {
      responseCkyc = {};

      if (_formKey.currentState!.validate()) {
        List combinedDocuments = documents + address;
        String areDocumentsValid = areKycDocumentsValid(kycDocument);
        if (areDocumentsValid == '') {
          kycData = {
            "ckyc_exist": _kycAvailable == 'Yes' ? 'Y' : 'N',
            "ckyc_num":
                ckycIDController.text == '' ? null : ckycIDController.text,
            "pan_avail": _panAvailable == 'Yes'
                ? '1'
                : _panAvailable == 'No'
                    ? '0'
                    : null,
            "aadhar_avail": _aadharAvailable == 'Yes'
                ? '1'
                : _aadharAvailable == 'No'
                    ? '0'
                    : null,
            "customer_type": "individual",
            "pan_num": panNumberController.text == ''
                ? null
                : panNumberController.text,
            "dob": DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(birthDate)),
            "aadhar_card_last_4_digit_number": adhaarNumberController.text == ''
                ? null
                : adhaarNumberController.text,
            "aadhar_card_full_name": adhaarNameController.text == ''
                ? null
                : adhaarNameController.text,
            "aadhar_card_gender": _gender,
            "aadhar_card_dob": null,
            "mobile_no": mobileNoController.text,
            "relative_type_selected": _member,
            "relative_prefix": _member == 'Spouse'
                ? salutation
                : _member == "Father's \nDetails"
                    ? 'Mr'
                    : _member == "Mother's \nDetails"
                        ? 'Mrs'
                        : '',
            "relative_first_name": firstNameController.text,
            "relative_middle_name": middleNameController.text,
            "relative_last_name": lastNameController.text,
            "doc_addr_proof_number": addressProofController.text,
            "doc_id_proof_type_selected":
                allDocuments.indexOf(selectedDocument!) + 1,
            "doc_addr_proof_type_selected":
                allDocuments.indexOf(selectedAddress!) + 1,
            "otp_transaction_id": null,
            ...responseCkyc
          };
          print(kycData);
          final appState = Provider.of<AppState>(context, listen: false);

          html.FormData formData = html.FormData();
          formData.append('proposal_id', appState.proposalId.toString());
          formData.append('doc_type', 'ckyc');

          for (var i = 0; i < kycDocument['idProof']!.length; i++) {
            if (kycDocument['idProof']![i] != '') {
              var fileExtension =
                  kycDocument['idProof']![i]['file'].name.split('.').last;
              formData.appendBlob('files', kycDocument['idProof']![i]['file'],
                  '${allDocuments.indexOf(selectedDocument!) + 1}_page${i + 1}.$fileExtension');
            }
          }
          for (var i = 0; i < kycDocument['addressProof']!.length; i++) {
            if (kycDocument['addressProof']![i] != '') {
              var fileExtension =
                  kycDocument['addressProof']![i]['file'].name.split('.').last;
              formData.appendBlob(
                  'files',
                  kycDocument['addressProof']![i]['file'],
                  '${allDocuments.indexOf(selectedAddress!) + 1}_page${i + 1}.$fileExtension');
            }
          }
          for (var i = 0; i < kycDocument['customerPhoto']!.length; i++) {
            if (kycDocument['customerPhoto']![i] != '') {
              var fileExtension =
                  kycDocument['customerPhoto']![i]['file'].name.split('.').last;
              formData.appendBlob(
                  'files',
                  kycDocument['customerPhoto']![i]['file'],
                  '${allDocuments.indexOf('Photograph') + 1}_page${i + 1}.$fileExtension');
            }
          }
          // if (widget.onlinePay && paymentLink == null) {
          //   showDialog(
          //       barrierDismissible: false,
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text(
          //             'Submit KYC and Initiate Payment',
          //             style: TextStyle(fontSize: 15, color: Colors.black),
          //           ),
          //           content: const Text(
          //             "Do you want to submit KYC and initiate payment request?",
          //             style: TextStyle(fontSize: 12, color: Colors.black54),
          //           ),
          //           actions: <Widget>[
          //             TextButton(
          //               child: const Text('Yes'),
          //               onPressed: () {
          //                 if (checkKYC == false) {
          //                   setState(() {
          //                     isLoading = true;
          //                   });
          //                   sendCkyc(kycData, formData);
          //                 } else {
          //                   editCkyc(kycData, formData, context);
          //                 }
          //                 Navigator.of(context).pop();
          //               },
          //             ),
          //             TextButton(
          //               child: const Text('No'),
          //               onPressed: () {
          //                 Navigator.of(context).pop();
          //               },
          //             ),
          //           ],
          //         );
          //       });
          // } else {
          //   if (checkKYC == false) {
          //     setState(() {
          //       isLoading = true;
          //     });
          //     sendCkyc(kycData, formData);
          //   } else {
          //     editCkyc(kycData, formData, context);
          //   }
          // }
          if (checkKYC == false) {
            setState(() {
              isLoading = true;
            });
            sendCkyc(kycData, formData);
          } else {
            editCkyc(kycData, formData, context);
          }
        } else {
          if (_member == null) {
            Style.showAlertDialog(context, "Please Select Family dDetails.");
          } else if (areDocumentsValid == 'Customer Photo') {
            Style.showAlertDialog(context, "Please upload Customer Photo.");
          } else {
            Style.showAlertDialog(context, "Upload required Documents.");
          }
        }
      } else {
        Style.showAlertDialog(context, "Please fill out all the form fields.");
      }
    } else {
      kycData = {
        "ckyc_exist": _kycAvailable == 'Yes' ? 'Y' : 'N',
        "ckyc_num": ckycIDController.text == '' ? null : ckycIDController.text,
        "pan_avail": _panAvailable == 'Yes'
            ? '1'
            : _panAvailable == 'No'
                ? '0'
                : null,
        "aadhar_avail": _aadharAvailable == 'Yes'
            ? '1'
            : _aadharAvailable == 'No'
                ? '0'
                : null,
        "customer_type": "individual",
        "pan_num":
            panNumberController.text == '' ? null : panNumberController.text,
        "dob": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(birthDate)),
        "aadhar_card_last_4_digit_number": adhaarNumberController.text == ''
            ? null
            : adhaarNumberController.text,
        "aadhar_card_full_name":
            adhaarNameController.text == '' ? null : adhaarNameController.text,
        "aadhar_card_gender": _gender,
        "aadhar_card_dob": null,
        "mobile_no": mobileNoController.text,
        "response_ckyc_num": ckycData['CKYCNumber'],
        "response_ckyc_dob": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MMM-yyyy").parse(ckycData['CKYCDOB'])),
        "response_ckyc_customer_name": ckycData['CKYCFullName'],
        "res_ckyc_address": ckycData['CKYCAddress'],
        "relative_type_selected": _member,
        "otp_transaction_id": transactionId,
        "relative_prefix": _member == 'Spouse'
            ? salutation
            : _member == "Father's \nDetails"
                ? 'Mr'
                : _member == "Mother's \nDetails"
                    ? 'Mrs'
                    : '',
      };
      print(kycData);
      FormData formData = FormData();
      // if (widget.onlinePay && paymentLink == null) {
      //   showDialog(
      //       barrierDismissible: false,
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text(
      //             'Submit KYC and Initiate Payment',
      //             style: TextStyle(fontSize: 15, color: Colors.black),
      //           ),
      //           content: const Text(
      //             "Do you want to submit KYC and initiate payment request?",
      //             style: TextStyle(fontSize: 12, color: Colors.black54),
      //           ),
      //           actions: <Widget>[
      //             TextButton(
      //               child: const Text('Yes'),
      //               onPressed: () {
      //                 if (checkKYC == false) {
      //                   sendCkyc(kycData, formData);
      //                 } else {
      //                   editCkyc(kycData, formData, context);
      //                 }
      //                 Navigator.of(context).pop();
      //               },
      //             ),
      //             TextButton(
      //               child: const Text('No'),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //             ),
      //           ],
      //         );
      //       });
      // } else {
      //   if (checkKYC == false) {
      //     sendCkyc(kycData, formData);
      //   } else {
      //     editCkyc(kycData, formData, context);
      //   }
      // }
      if (checkKYC == false) {
        sendCkyc(kycData, formData);
      } else {
        editCkyc(kycData, formData, context);
      }
    }
  }

  getCKYCDetails() async {
    print("asdasd");
    setState(() {
      isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      var proposalId = appState.proposalId;
      Map<String, dynamic> postData = {"proposal_id": proposalId};

      String result = aesCbcEncryptJson(jsonEncode(postData));
      Map<String, dynamic> encryptedData = {'encryptedData': result};

      print(postData);
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": appState.accessToken
      };

      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/ckycDetails',
          options: Options(headers: headers),
          data: encryptedData);
      // var data = jsonDecode(response.data);
      String decryptedData = aesCbcDecryptJson(response.data);

      var data = jsonDecode(decryptedData);
      // var data = const JsonDecoder().convert(jsonMap);
      await getVersion();
      await getManualDetails();
      setState(() {
        productName = widget.inwardData['product'];
      });
      print(data);
      if (ckycExist != null) {
        setState(() {
          birthDate = data['dob'];
          mobileNoController.text = data['mobile_no'];
          _kycAvailable = data['ckyc_num'] != null ? "Yes" : 'No';
          if (data['ckyc_num'] != null) {
            kyc = true;
            fetchKyc = false;
            ckycIDController.text = data['ckyc_num'] ?? '';
          }
        });
        setState(() {
          if (data['pan_avail'] == null) {
            setState(() {
              isPan = false;
              pan = false;
              fetchPan = false;
            });
          } else {
            _panAvailable = data['pan_avail'] == '1' ? "Yes" : 'No';
            if (data['pan_avail'] == '1') {
              isPan = true;
              pan = true;
              fetchPan = false;
              panNumberController.text = data['pan_num'] ?? '';
            } else {
              isPan = true;
              pan = false;
              fetchPan = false;
            }
          }
        });
        setState(() {
          if (data['aadhar_avail'] == null) {
            setState(() {
              isAadhar = false;
              aadhar = false;
              fetchAadhar = false;
            });
          } else {
            _aadharAvailable = data['aadhar_avail'] == '1' ? "Yes" : 'No';
            if (data['aadhar_avail'] == '1') {
              setState(() {
                isAadhar = true;
                aadhar = true;
                fetchAadhar = false;
                adhaarNameController.text = data['aadhar_card_full_name'] ?? '';
                adhaarNumberController.text =
                    data['aadhar_card_last_4_digit_number'] ?? '';
                _gender = data['aadhar_card_gender'];
              });
            } else {
              setState(() {
                isAadhar = true;
                aadhar = false;
                fetchAadhar = false;
              });
            }
          }
          if (data['relative_type_selected'] != null) {
            // isAadhar = true;
            // // aadhar = false;
            // fetchAadhar = false;
            manual = true;
            _member = toBeginningOfSentenceCase(data['relative_type_selected']);
            salutationController.text = data['relative_prefix'] ?? '';
            firstNameController.text = data['relative_first_name'] ?? '';
            middleNameController.text = data['relative_middle_name'] ?? '';

            lastNameController.text = data['relative_last_name'] ?? '';
            idProofController.text = data['doc_id_proof_number'] ?? '';
            addressProofController.text = data['doc_addr_proof_number'] ?? '';
            selectedDocument =
                allDocuments[data["doc_id_proof_type_selected"] - 1];
            selectedAddress =
                allDocuments[data["doc_addr_proof_type_selected"] - 1];
          } else if (data['response_ckyc_num'] != null) {
            isFetched = true;
            ckycData["CKYCNumber"] = data['response_ckyc_num'] ?? '';
            ckycData["CKYCFullName"] =
                data['response_ckyc_customer_name'] ?? '';
            ckycData["CKYCDOB"] = data['response_ckyc_dob'];
            ckycData["CKYCAddress"] = data['res_ckyc_address'];
            // DateFormat("yyyy-MM-dd").format(
            //     DateFormat("dd-MM-yyyy").parse(data['response_ckyc_dob']));
            isSubmitted = true;
            isLoading = false;
          }
          onChanged = null;
          onChanged2 = null;
          onChanged3 = null;
          onChanged4 = null;
          onChanged5 = null;
          onChanged6 = null;
          disable = true;
          enableCKYC = true;
          enablePan = true;
          enableAadharNo = true;
          enableAadharName = true;
          enable2 = true;
        });
        if (data['relative_type_selected'] != null) {
          setState(() {
            documentIds['id_proof'] = data["doc_id_proof_type_selected"];
            documentIds['address_proof'] = data["doc_addr_proof_type_selected"];
          });
          if (data["doc_id_proof_type_selected"] != null) {
            setState(() {
              isLoading = true;
            });
            await getDocuments(
                data["doc_id_proof_type_selected"],
                data["doc_addr_proof_type_selected"],
                data["doc_addr_proof_number"].toString());
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          disable = true;
          onChanged = null;
          onChanged2 = null;
          isLoading = false;
          isViewButton = true;
        });
      }
      // setState(() {
      //   productName = widget.inwardData['product'];
      //   birthDate = data['dob'];
      //   // DateFormat("yyyy-MM-dd")
      //   //     .format(DateFormat("dd-MM-yyyy").parse(data['dob']));
      //   _kycAvailable = data['ckyc_num'] != null ? "Yes" : 'No';
      //   if (data['ckyc_num'] != null) {
      //     kyc = true;
      //     fetchKyc = false;
      //     ckycIDController.text = data['ckyc_num'] ?? '';
      //   }
      // });
      // setState(() {
      //   _panAvailable = data['pan_avail'] == '1' ? "Yes" : 'No';
      //   if (data['pan_avail'] == '1') {
      //     isPan = true;
      //     pan = true;
      //     fetchPan = false;
      //     panNumberController.text = data['pan_num'] ?? '';
      //   } else {
      //     isPan = true;
      //     pan = false;
      //     fetchPan = false;
      //   }
      // });
      // setState(() {
      //   _aadharAvailable = data['aadhar_avail'] == '1' ? "Yes" : 'No';
      //   if (data['aadhar_avail'] == '1') {
      //     isAadhar = true;
      //     aadhar = true;
      //     fetchAadhar = false;
      //     adhaarNameController.text = data['aadhar_card_full_name'] ?? '';
      //     adhaarNumberController.text =
      //         data['aadhar_card_last_4_digit_number'] ?? '';
      //     _gender = data['aadhar_card_gender'];
      //   }
      //   if (data['relative_type_selected'] != null) {
      //     isAadhar = true;
      //     aadhar = false;
      //     fetchAadhar = false;
      //     manual = true;
      //     _member = toBeginningOfSentenceCase(data['relative_type_selected']);
      //     salutationController.text = data['relative_prefix'] ?? '';
      //     firstNameController.text = data['relative_first_name'] ?? '';
      //     middleNameController.text = data['relative_middle_name'] ?? '';
      //     lastNameController.text = data['relative_last_name'] ?? '';
      //     idProofController.text = data['doc_id_proof_number'] ?? '';
      //     addressProofController.text = data['doc_addr_proof_number'] ?? '';
      //   }
      //   if (data['response_ckyc_num'] != null) {
      //     isFetched = true;
      //     ckycData["CKYCNumber"] = data['response_ckyc_num'] ?? '';
      //     ckycData["CKYCFullName"] = data['response_ckyc_customer_name'] ?? '';
      //     ckycData["CKYCDOB"] = data['response_ckyc_dob'];
      //     // DateFormat("yyyy-MM-dd").format(
      //     //     DateFormat("dd-MM-yyyy").parse(data['response_ckyc_dob']));
      //     isSubmitted = true;
      //     isLoading = false;
      //   }
      //   onChanged = null;
      //   onChanged2 = null;
      //   onChanged3 = null;
      //   onChanged4 = null;
      //   onChanged5 = null;
      //   onChanged6 = null;
      //   disable = true;
      //   enableCKYC = true;
      //   enablePan = true;
      //   enableAadharNo = true;
      //   enableAadharName = true;
      //   enable2 = true;
      // });
      // if (data['relative_type_selected'] != null) {
      //   setState(() {
      //     documentIds['id_proof'] = data["doc_id_proof_type_selected"];
      //     documentIds['address_proof'] = data["doc_addr_proof_type_selected"];
      //     if (data["doc_id_proof_type_selected"] == null) {
      //       setState(() {
      //         isLoading = false;
      //       });
      //     } else {
      //       setState(() {
      //         isLoading = true;
      //       });
      //       getDocuments(data["doc_addr_proof_number"].toString());
      //     }
      //   });
      //   print(data["doc_id_proof_type_selected"]);
      // }
      // setState(() {
      //   isLoading = false;
      // });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Technical Error!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  fetchFilePath(String filename) async {
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {"Authorization": appState.accessToken};

    var proposalId = appState.proposalId;

    try {
      final response = await dio.get(
        'https://uatcld.sbigeneral.in/SecureApp/proposalDocument/$proposalId/$filename',
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );

      String? contentType = response.headers.value('content-type');

      final fileBytes = response.data as List<int>;

      final fileBlob = html.Blob([Uint8List.fromList(fileBytes)], contentType);

      final fileUrl = html.Url.createObjectUrlFromBlob(fileBlob);

      return {"url": fileUrl, "fileType": contentType, "file_name": filename};
    } catch (e) {
      return null;
    }
  }

  getDocuments(selectedDocumentId, selectedAdressId, addressProof) async {
    setState(() {
      isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      var proposalId = appState.proposalId;
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/proposalDocuments',
          data: {'proposal_id': proposalId, 'doc_type': 'ckyc'},
          options: Options(headers: headers));
      var data = List.from(jsonDecode(response.data));
      // var combinedDropdownList = allDocuments;
      print(data);
      for (var i = 0; i < data.length; i++) {
        var documentId = int.parse(data[i]['initial_file_name']);
        String fileName = data[i]['file_name'].split('.')[0];
        print(documentId);
        if (documentId <= documents.length) {
          // selectedDocument = combinedDropdownList[documentIds['id_proof']! - 1];
          kycDocument['idProof']![int.parse(fileName[fileName.length - 1]) -
              1] = await fetchFilePath(data[i]['file_name']);
          setState(() {});
        } else if (documentId == (allDocuments.indexOf('Photograph') + 1)) {
          // print('issue');
          kycDocument['customerPhoto']![0] =
              await fetchFilePath(data[i]['file_name']);
          setState(() {});
        } else {
          // selectedAddress =
          //     combinedDropdownList[documentIds['address_proof']! - 1];
          kycDocument['addressProof']![
                  int.parse(fileName[fileName.length - 1]) - 1] =
              await fetchFilePath(data[i]['file_name']);
          addressProofController.text = addressProof;
          print('here it is');
          print(addressProof);
          setState(() {});
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error! Failed to fetch documents')));
    }
  }

  // fetchCKYC() async {
  //   Map<String, dynamic> post = {};

  // Map<String, dynamic> postData = {
  //   "encryptedData": result,
  //   "key": key,
  //   "base64IV": base64iv,
  // };

  // Map<String, dynamic> headers = {
  //   'Content-Type': 'application/json; charset=UTF-8',
  //   "Accept": "application/json",
  //   "X-IBM-Client-Id": "03d37cba-bb30-42ef-a7b5-90eff137e085",
  //   "X-IBM-Client-Secret":
  //       "aE0fW4iF6sJ0dF0vR5qT1jO3oL3bK5gI6lL1mF2vP1jF4yH3hE",
  //   "Authorization": 'Bearer ${_accessToken}'
  // };
  // try {
  //   final response = await dio.post(
  //       'https://devapi.sbigeneral.in/ept/v1/portalCkycV',
  //       data: postData,
  //       options: Options(headers: headers));
  //   var decryptedData = aesCbcDecryptJson(response.data, key, base64iv);
  //   final Map<String, dynamic> data = jsonDecode(decryptedData);
  // } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MouseRegion(
      cursor:
          loadingDoc ? SystemMouseCursors.progress : SystemMouseCursors.basic,
      child: Stack(
        children: [
          Scaffold(
              appBar: NavBar.appBar(),
              body: Stack(
                children: [
                  Style.background(context),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        NavBar.header(
                          context,
                          'Previous',
                          () {
                            Navigator.pop(context);
                          },
                        ),
                        Form(
                          key: _formKey,
                          child: Style.formContainer(
                              context,
                              widget.isView || widget.isEdit
                                  ? 'KYC Module (Inward No: ${appState.proposalId}) :'
                                  : 'KYC Module:',
                              [
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(children: [
                                      CustomInputContainer(children: [
                                        heightGap(),
                                        Style.wrap(context, children: [
                                          KycCommonFunctions.kycQuestion(),
                                          KycCommonFunctions.kycRadioButton(
                                              _kycAvailable,
                                              onChanged,
                                              onChanged2),
                                          kyc
                                              ? KycCommonFunctions
                                                  .kycInputField(enableCKYC,
                                                      ckycIDController)
                                              : const SizedBox.shrink(),
                                        ]),
                                        Style.wrap(context, children: [
                                          KycCommonFunctions.dateField(
                                              context, disable, 'Date of Birth',
                                              (DateTime? value) {
                                            setState(() {
                                              birthDate = DateFormat(
                                                      'dd-MM-yyyy')
                                                  .format(value as DateTime);
                                            });
                                          }, birthDate),
                                          CustomInputField(
                                              required: true,
                                              title: 'Mobile Number',
                                              view: enable2,
                                              controller: mobileNoController,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 10,
                                              validator: Validators
                                                  .phoneNumberValidation)
                                        ])
                                      ]),
                                      heightGap(),
                                      isViewButton
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Color.fromRGBO(
                                                    11, 133, 163, 1),
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProposalDocuments(
                                                                  isView: widget
                                                                      .isView,
                                                                  isEdit: widget
                                                                      .isEdit,
                                                                  inwardData: widget
                                                                      .inwardData,
                                                                  inwardType: widget
                                                                      .inwardType,
                                                                  ckycData:
                                                                      null,
                                                                  ckycDocuments:
                                                                      null,
                                                                )));
                                                  },
                                                  child: const Text(
                                                    'Next',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            )
                                          : Container(),
                                      fetchKyc
                                          ? KycCommonFunctions.fetchButton(
                                              () {
                                                print('done');
                                                if (_kycAvailable != null &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  setState(() {
                                                    inputType = 'Z';
                                                    inputNo =
                                                        ckycIDController.text;
                                                    option = 'PAN Number';
                                                  });
                                                  fetchCKYC();
                                                } else {
                                                  Style.showAlertDialog(context,
                                                      'Please enter valid details.');
                                                }
                                              },
                                            )
                                          : Container(),
                                      isPan
                                          ? CustomInputContainer(children: [
                                              heightGap(),
                                              Style.wrap(context, children: [
                                                RadioButton.customRadio(
                                                    context,
                                                    'Do you have PAN?',
                                                    _panAvailable,
                                                    onChanged3),
                                                pan
                                                    ? KycCommonFunctions
                                                        .panInputField(
                                                        context,
                                                        enablePan,
                                                        panNumberController,
                                                        (value) {
                                                          panNumberController
                                                                  .value =
                                                              TextEditingValue(
                                                                  text: value
                                                                      .toUpperCase(),
                                                                  selection:
                                                                      panNumberController
                                                                          .selection);
                                                        },
                                                      )
                                                    : const SizedBox.shrink(),
                                              ]),
                                              heightGap()
                                            ])
                                          : Container(),
                                      heightGap(),
                                      fetchPan
                                          ? KycCommonFunctions.fetchButton(
                                              () {
                                                print('done');
                                                if (_panAvailable != null &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  setState(() {
                                                    inputType = 'C';
                                                    inputNo =
                                                        panNumberController
                                                            .text;
                                                    option = 'Aadhar Number';
                                                  });
                                                  fetchCKYC();
                                                } else {
                                                  Style.showAlertDialog(context,
                                                      'Please enter valid details.');
                                                }
                                              },
                                            )
                                          : Container(),
                                      heightGap(),
                                      isAadhar
                                          ? CustomInputContainer(children: [
                                              heightGap(),
                                              Style.wrap(
                                                context,
                                                children: [
                                                  RadioButton.customRadio(
                                                      context,
                                                      'Do you have Aadhar?',
                                                      _aadharAvailable,
                                                      onChanged4),
                                                  aadhar
                                                      ? SizedBox(
                                                          width: 600,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Style.wrap(
                                                                context,
                                                                children: [
                                                                  KycCommonFunctions
                                                                      .aadharNumberInputField(
                                                                          enableAadharNo,
                                                                          adhaarNumberController),
                                                                  KycCommonFunctions
                                                                      .aadharNameInputField(
                                                                          enableAadharName,
                                                                          adhaarNameController),
                                                                ],
                                                              ),
                                                              RadioButton
                                                                  .customRadio2(
                                                                      context,
                                                                      'Gender:',
                                                                      _gender,
                                                                      onChanged5,
                                                                      'Male',
                                                                      'Female',
                                                                      'Transgender'),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              heightGap(),
                                            ])
                                          : Container(),
                                      heightGap(),
                                      fetchAadhar
                                          ? KycCommonFunctions.fetchButton(() {
                                              print('done');
                                              if (_aadharAvailable != null &&
                                                  _gender != null &&
                                                  _formKey.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  inputType = 'E';
                                                  inputNo =
                                                      adhaarNumberController
                                                          .text;
                                                  option = 'Document Upload';
                                                });
                                                fetchCKYC();
                                              } else {
                                                Style.showAlertDialog(context,
                                                    'Please enter valid details.');
                                              }
                                            })
                                          : Container(),
                                      manual
                                          ? CustomInputContainer(
                                              children: [
                                                Wrap(
                                                  spacing: 20,
                                                  runSpacing: 15,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    RadioButton.customRadio2(
                                                        context,
                                                        'Family Details:',
                                                        _member,
                                                        onChanged6,
                                                        'Spouse',
                                                        "Father",
                                                        "Mother"),
                                                    if (_member == 'Spouse' ||
                                                        _member == "Father" ||
                                                        _member == "Mother")
                                                      Wrap(
                                                        spacing: 20,
                                                        runSpacing: 15,
                                                        alignment:
                                                            WrapAlignment.start,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        children: [
                                                          DropdownWidget(
                                                            view: enable2,
                                                            label: 'Salutation',
                                                            items: [
                                                              'Mr',
                                                              'Mrs'
                                                            ],
                                                            value: _member ==
                                                                    'Spouse'
                                                                ? salutation
                                                                : _member ==
                                                                        "Father"
                                                                    ? 'Mr'
                                                                    : _member ==
                                                                            "Mother"
                                                                        ? 'Mrs'
                                                                        : '',
                                                            onChanged:
                                                                _member ==
                                                                        'Spouse'
                                                                    ? (val) {
                                                                        setState(
                                                                            () {
                                                                          print(
                                                                              val);
                                                                          salutation =
                                                                              val;
                                                                        });
                                                                      }
                                                                    : null,
                                                          ),
                                                          _nameDetails(),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                                heightGap(),
                                                Style.requiredFieldLabel(
                                                    'CKYC Documents:', 13),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    heightGap(),
                                                    // const Text(
                                                    //   'Proof of Identity: ',
                                                    //   style: TextStyle(
                                                    //       color: Color.fromRGBO(
                                                    //           143, 19, 168, 1),
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight.bold),
                                                    // ),
                                                    _ckycDocuments(),
                                                    heightGap(),
                                                    // const Text(
                                                    //   'Proof of Address: ',
                                                    //   style: TextStyle(
                                                    //       color: Color.fromRGBO(
                                                    //           143, 19, 168, 1),
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight.bold),
                                                    // ),
                                                    _addressProof(),
                                                    heightGap(),
                                                    selectedAddress != null
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Style.requiredFieldLabel(
                                                                  'Customer Photo:',
                                                                  12),
                                                              heightGap(),
                                                              _uploadDocument(
                                                                  'Upload\nCustomer\nPhoto',
                                                                  0,
                                                                  'customerPhoto')
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                heightGap(),
                                                Style.formSubmitButton(
                                                    widget.isView
                                                        ? 'Next'
                                                        : 'Next', () {
                                                  if (loadingDoc == false) {
                                                    if (widget.isView) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProposalDocuments(
                                                                      inwardData: {
                                                                        "product":
                                                                            productName
                                                                      },
                                                                      inwardType:
                                                                          widget
                                                                              .inwardType,
                                                                      isView: widget
                                                                          .isView,
                                                                      isEdit: widget
                                                                          .isEdit,
                                                                      ckycData:
                                                                          null,
                                                                      ckycDocuments:
                                                                          null)));
                                                    } else {
                                                      _submitKYC(
                                                          'Manual', context);
                                                    }
                                                  }
                                                }),
                                              ],
                                            )
                                          : Container(),
                                      heightGap(),
                                      isFetched
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                KycCommonFunctions
                                                    .ckycFetchedContainer(
                                                        context,
                                                        'Individual',
                                                        ckycData[
                                                            'CKYCFullName'],
                                                        ckycData['CKYCNumber']
                                                            .toString(),
                                                        ckycData['CKYCDOB'],
                                                        ckycData['CKYCAddress'],
                                                        widget.isView),
                                                heightGap(),
                                                isSubmitted
                                                    ? Style.formSubmitButton(
                                                        widget.isView
                                                            ? 'Next'
                                                            : 'Next', () {
                                                        if (loadingDoc ==
                                                            false) {
                                                          if (widget.isView) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProposalDocuments(
                                                                            inwardData: {
                                                                              "product": productName
                                                                            },
                                                                            inwardType: widget
                                                                                .inwardType,
                                                                            isView: widget
                                                                                .isView,
                                                                            isEdit: widget
                                                                                .isEdit,
                                                                            ckycData:
                                                                                null,
                                                                            ckycDocuments:
                                                                                null)));
                                                          } else {
                                                            _submitKYC(
                                                                'Not Manual',
                                                                context);
                                                          }
                                                        }
                                                      })
                                                    : Container()
                                              ],
                                            )
                                          : Container(),
                                    ])),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  verifyOtp
                      ? Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                              ),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // width: 450,
                                  // height:
                                  //     250,
                                  margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.27,
                                    MediaQuery.of(context).size.height * 0.22,
                                    MediaQuery.of(context).size.width * 0.27,
                                    MediaQuery.of(context).size.height * 0.22,
                                  ),
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
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Form(
                                        key: otpFormKey,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('OTP Verification!',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              heightGap(),
                                              const Text(
                                                  "Please enter the 6-Digit OTP sent to the customer's registered number.",
                                                  maxLines: 5,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      decoration:
                                                          TextDecoration.none,
                                                      // fontWeight: FontWeight.w600,
                                                      color: Colors.black54)),
                                              heightGap(),
                                              heightGap(),
                                              CustomInputField(
                                                required: true,
                                                controller: otpController,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                maxLength: 6,
                                                title: 'Enter 6-Digit OTP',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please Enter the Enter 6-Digit OTP';
                                                  } else if (int.parse(value) ==
                                                      0) {
                                                    return 'Please Enter valid Enter 6-Digit OTP';
                                                  } else if (value.length < 6) {
                                                    return 'Please enter 6-Digit OTP';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              heightGap(),
                                              buttonCounter > 0
                                                  ? Style.formSubmitButton(
                                                      'Verify OTP', () {
                                                      if (otpFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        // setState(() {
                                                        //   verifyOtp = false;
                                                        // });
                                                        // fetchCKYC();
                                                        verifyOtpAndFetchDetails(
                                                            "false",
                                                            otpController.text);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Please enter valid details!')),
                                                        );
                                                      }
                                                    })
                                                  : Container(),
                                              heightGap(),
                                              resendOtp
                                                  ? Center(
                                                      child: Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Didn't receive an otp? ",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          TimerButton(
                                                            label: "Resend OTP",
                                                            timeOutInSeconds:
                                                                90,
                                                            resetTimerOnPressed:
                                                                true,
                                                            onPressed: () {
                                                              // resentOTP();
                                                              setState(() {
                                                                resendOtp =
                                                                    false;
                                                              });
                                                              verifyOtpAndFetchDetails(
                                                                  "true", '');
                                                            },
                                                            buttonType:
                                                                ButtonType
                                                                    .textButton,
                                                            disabledColor:
                                                                Colors.white,
                                                            color: Colors
                                                                .transparent,
                                                            activeTextStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        12),
                                                            disabledTextStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                        "OTP is resent to the registered mobile number.",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    16,
                                                                    13,
                                                                    168),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                              heightGap(),
                                              verifyOtpMessage.isNotEmpty
                                                  ? Center(
                                                      child: Text(
                                                        verifyOtpMessage,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : Container()
                                            ]),
                                      ),
                                      Positioned(
                                        top: -15,
                                        right: -30,
                                        child: TextButton(
                                            clipBehavior: Clip.none,
                                            onPressed: () {
                                              setState(() {
                                                verifyOtp = false;
                                                resendOtp = true;
                                                otpController =
                                                    TextEditingController();
                                                buttonCounter = 3;
                                              });
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 211, 42, 30),
                                                      width: 2)),
                                              child: const Center(
                                                child: Text('X',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 211, 42, 30),
                                                    )),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              )),
          noKYC
              ? KycCommonFunctions.noKYC(
                  context,
                  option,
                  () {
                    setState(() {
                      noKYC = false;
                      if (_aadharAvailable == 'Yes') {
                        setState(() {
                          _aadharAvailable = 'Yes';
                          if (_kycAvailable == 'Yes') {
                            kyc = true;
                            fetchKyc = false;
                          } else {
                            kyc = false;
                          }
                          fetchKyc = false;
                          if (_panAvailable == 'Yes') {
                            isPan = true;
                            pan = true;
                            fetchPan = false;
                          } else {
                            // isPan = false;
                            pan = false;
                          }
                          fetchKyc = false;
                          fetchPan = false;
                          isAadhar = true;
                          aadhar = true;
                          fetchAadhar = true;
                          manual = false;
                        });
                      } else if (_panAvailable == 'Yes') {
                        print('next aadhar');
                        setState(() {
                          if (_kycAvailable == 'Yes') {
                            kyc = true;
                            fetchKyc = false;
                          } else {
                            kyc = false;
                          }
                          fetchKyc = false;
                          _panAvailable = 'Yes';
                          isPan = true;
                          pan = true;
                          fetchPan = true;
                          isAadhar = false;
                          aadhar = false;
                          fetchAadhar = false;
                          manual = false;
                        });
                      } else if (_kycAvailable == 'Yes') {
                        setState(() {
                          kyc = true;
                          fetchKyc = true;
                          isPan = false;
                          pan = false;
                          fetchPan = false;
                          isAadhar = false;
                          fetchAadhar = false;
                          aadhar = false;
                          manual = false;
                        });
                      }
                    });
                  },
                  () {
                    // getVersion();
                    setState(() {
                      noKYC = false;
                    });
                    if (_aadharAvailable == 'Yes') {
                      setState(() {
                        onChanged = null;
                        onChanged2 = null;
                        onChanged3 = null;
                        onChanged4 = null;
                        onChanged5 = null;
                        disable = true;
                        enableAadharName = true;
                        enableAadharNo = true;
                        if (_kycAvailable == 'Yes') {
                          kyc = true;
                          fetchKyc = false;
                          enableCKYC = true;
                        }
                        fetchKyc = false;
                        if (_panAvailable == 'Yes') {
                          isPan = true;
                          pan = true;
                          fetchPan = false;
                          enablePan = true;
                        }
                        fetchPan = false;
                        isAadhar = true;
                        aadhar = true;
                        fetchAadhar = false;
                        manual = true;
                      });
                    } else if (_panAvailable == 'Yes') {
                      print('next aadhar');
                      setState(() {
                        _aadharAvailable = 'Yes';
                        if (_kycAvailable == 'Yes') {
                          kyc = true;
                          fetchKyc = false;
                          enableCKYC = true;
                          disable = true;
                        } else {
                          kyc = false;
                        }
                        fetchKyc = false;
                        onChanged = null;
                        onChanged2 = null;
                        onChanged3 = null;
                        enablePan = true;
                        isPan = true;
                        pan = true;
                        fetchPan = false;
                        isAadhar = true;
                        aadhar = true;
                        fetchAadhar = true;
                        manual = false;
                      });
                    } else if (_kycAvailable == 'Yes') {
                      setState(() {
                        kyc = true;
                        fetchKyc = false;
                        onChanged = null;
                        onChanged2 = null;
                        enableCKYC = true;
                        disable = true;
                        _panAvailable = 'Yes';
                        isPan = true;
                        pan = true;
                        fetchPan = true;
                        isAadhar = false;
                        fetchAadhar = false;
                        aadhar = false;
                        manual = false;
                      });
                    }
                  },
                )
              : Container(),
          editKYC
              ? KycCommonFunctions.editKYC(
                  context,
                  () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProposalDocuments(
                                  inwardData: widget.inwardData,
                                  inwardType: widget.inwardType,
                                  ckycData: null,
                                  ckycDocuments: null,
                                  isEdit: widget.isEdit,
                                  isView: widget.isView,
                                ))).then((value) {
                      setState(() {
                        editKYC = true;
                      });
                    });
                  },
                  () async {
                    print("gggggggggggg");
                    // await getVersion();
                    setState(() {
                      _kycAvailable = null;
                      resetVariable();
                      editKYC = false;
                      // edit = true;
                    });
                  },
                )
              : Container(),
          isLoading
              ? const LoadingPage(
                  label: "Loading",
                )
              : Container()
        ],
      ),
    );
  }

  _nameDetails() {
    return Style.wrap(
      context,
      children: [
        KycCommonFunctions.familyDetailsNameInput(
            'First Name', enable2, firstNameController),
        KycCommonFunctions.familyDetailsNameInput(
            'Middle Name', enable2, middleNameController),
        KycCommonFunctions.familyDetailsNameInput(
            'Last Name', enable2, lastNameController),
      ],
    );
  }

  _ckycDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KycCommonFunctions.customDropDown('Proof of Identity:', (value) {
          setState(() {
            if (selectedDocument != value) {
              selectedDocument = value;
              setState(() {
                idProofController = TextEditingController();
                kycDocument['idProof'] = ['', ''];
              });
            }
          });
        }, documents, selectedDocument, enable2),
        selectedDocument != null
            ? Wrap(
                spacing: 20,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _uploadDocument('Upload\nID\nProof', 0, 'idProof'),
                  _uploadDocument('Upload\nID\nProof', 1, 'idProof')
                ],
              )
            : Container(),
        heightGap()
      ],
    );
  }

  _addressProof() {
    if (selectedAddress == 'Masked Aadhar' &&
        adhaarNumberController.text != '' &&
        widget.isView == false &&
        addressProofController.text == '') {
      setState(() {
        addressProofController.text = adhaarNumberController.text;
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 15,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            KycCommonFunctions.customDropDown('Proof of Address:', (value) {
              if (selectedAddress != value) {
                setState(() {
                  addressProofController = TextEditingController();
                  kycDocument['addressProof'] = ['', ''];
                });
              }
              setState(() {
                selectedAddress = value;
              });
            }, address, selectedAddress, enable2),
            if (selectedAddress == 'Voter Id')
              CustomInputField(
                required: true,
                view: enable2,
                maxLength: 10,
                controller: addressProofController,
                title: 'Voter Id',
                validator: Validators.voterIdValidator,
                onChanged: (value) {
                  addressProofController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: addressProofController.selection);
                },
              ),
            if (selectedAddress == 'Passport')
              CustomInputField(
                required: true,
                view: enable2,
                maxLength: 8,
                controller: addressProofController,
                title: 'Passport Number',
                validator: Validators.passportIdValidator,
                onChanged: (value) {
                  addressProofController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: addressProofController.selection);
                },
              ),
            if (selectedAddress == 'Driving License')
              CustomInputField(
                required: true,
                view: enable2,
                maxLength: 15,
                controller: addressProofController,
                title: 'Driving License',
                validator: Validators.drivingLicenseValidator,
                onChanged: (value) {
                  addressProofController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: addressProofController.selection);
                },
              ),
            if (selectedAddress == 'Masked Aadhar')
              CustomInputField(
                required: true,
                view: enable2,
                maxLength: 4,
                controller: addressProofController,
                title: 'Last 4-Digit of Aadhar Card',
                validator: Validators.aadhaarLast4DigitsValidator,
                onChanged: (value) {
                  // addressProofController.value = TextEditingValue(
                  //     text: value.toUpperCase(),
                  //     selection: addressProofController.selection);
                },
              ),
            if (selectedAddress == 'Voter Id' && widget.isView == false)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Style.notRequiredFieldLabel(
                    'Voter Id (Please upload first \nand last page of the Voter ID)',
                    10),
              ),
            if (selectedAddress == 'Masked Aadhar' && widget.isView == false)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Style.notRequiredFieldLabel(
                    'Masked Aadhar Card (Please upload front \nand back side of the Aadhar Card)',
                    10),
              ),
          ],
        ),
        selectedAddress != null
            ? Wrap(
                spacing: 20,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _uploadDocument('Upload\nAddress\nProof', 0, 'addressProof'),
                  _uploadDocument('Upload\nAddress\nProof', 1, 'addressProof'),
                ],
              )
            : Container(),
      ],
    );
  }

  _uploadDocument(String label, int index, String type) {
    if (widget.isView && kycDocument[type]![index] == '') {
      return Container();
    }
    return DocumentCommonFunctions.uploadDocument(
      context,
      index,
      type,
      kycDocument[type]![index],
      widget.isView,
      widget.isEdit,
      () {
        if (widget.isView == false) {
          _pickFile(type, index);
        }
      },
      () {
        if (kycDocument[type]![index] != null &&
            kycDocument[type]![index].isNotEmpty) {
          html.Url.revokeObjectUrl(kycDocument[type]![index]['url']);
        }
        setState(() {
          kycDocument[type]![index] = '';
        });
      },
      kycDocumentLoader,
    );
  }

  Future<void> _pickFile(String type, int index) async {
    try {
      html.FileUploadInputElement inputElement = html.FileUploadInputElement();
      inputElement.multiple = false;
      inputElement.accept = '.pdf,.jpg,.jpeg,.png';

      inputElement.click();

      inputElement.onChange.listen((e) async {
        print((e.target as html.FileUploadInputElement).files);
        final files = inputElement.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final fileSize = file.size;
          final fileType = file.type;

          if ((fileType == 'application/pdf' && fileSize > 2 * 1024 * 1024)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File size exceeds 2mb')),
            );

            return;
          }
          // _cursorNotifier.value = SystemMouseCursors.progress;
          setState(() {
            loadingDoc = true;
          });
          Uint8List? compressedData;
          if (fileType.startsWith('image/') && fileSize > 3 * 1024 * 1024) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);
            await reader.onLoadEnd.first;

            final originalData = reader.result as Uint8List;
            final image = img.decodeImage(originalData);
            if (image != null) {
              final resizedImage = img.copyResize(image, width: 800);
              compressedData =
                  Uint8List.fromList(img.encodeJpg(resizedImage, quality: 70));
            }
          }

          final reader = html.FileReader();

          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) {
            final file = files[0];
            final fileName = files[0].name;
            final fileType = files[0].type;

            final blob = html.Blob(
                [compressedData ?? reader.result as List<int>], fileType);
            final url = html.Url.createObjectUrlFromBlob(blob);

            setState(() {
              if (kycDocument[type]![index] != null &&
                  kycDocument[type]![index].isNotEmpty) {
                html.Url.revokeObjectUrl(kycDocument[type]![index]);
              }
              kycDocument[type]![index] = {
                "url": url,
                "fileType": fileType,
                "file_name": fileName,
                "file": file
              };
              print(documents);
              // if (widget.isEdit) {
              //   edittedDocuments[type]![index] = {
              //     "url": url,
              //     "fileType": fileType,
              //     "file_name": fileName,
              //     "file": file,
              //   };
              // }
            });
            setState(() {
              loadingDoc = false;
            });
            // setState(() {
            //   documentsLoader[type]![index] = false;
            // });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No document selected')),
          );
        }
      });
      inputElement.onTouchCancel.listen((e) {
        setState(() {
          loadingDoc = false;
        });
        // setState(() {
        //   documentsLoader[type]![index] = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No document selected')),
        );
        return;
      });
    } catch (e) {
      setState(() {
        loadingDoc = false;
      });
      print(e);
    }
  }

  // Future<void> _pickFile(String type, int index) async {
  //   setState(() {
  //     kycDocumentLoader[type]![index] = true;
  //   });
  //   html.FileUploadInputElement inputElement = html.FileUploadInputElement();
  //   inputElement.multiple = false;
  //   inputElement.accept = '.pdf,.jpg,.jpeg,.png';

  //   inputElement.click();

  //   inputElement.onChange.listen((e) {
  //     final files = inputElement.files;
  //     if (files != null && files.isNotEmpty) {

  //       final reader = html.FileReader();
  //       reader.readAsArrayBuffer(files[0]);
  //       reader.onLoadEnd.listen((e) {
  //         final fileName = files[0].name;
  //         final file = files[0];
  //         final fileType = files[0].type;

  //         final blob = html.Blob([reader.result as List<int>], fileType);
  //         final url = html.Url.createObjectUrlFromBlob(blob);

  //         setState(() {
  //           if (kycDocument[type]![index] != null &&
  //               kycDocument[type]![index].isNotEmpty) {
  //             html.Url.revokeObjectUrl(kycDocument[type]![index]);
  //           }
  //           kycDocument[type]![index] = {
  //             "url": url,
  //             "fileType": fileType,
  //             "file": file,
  //             "file_name": fileName,
  //           };
  //         });
  //         setState(() {
  //           kycDocumentLoader[type]![index] = false;
  //         });
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No document selected')),
  //       );
  //     }
  //   });
  // }
}
