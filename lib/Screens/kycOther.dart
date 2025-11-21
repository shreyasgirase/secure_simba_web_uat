// ignore_for_file: prefer_typing_uninitialized_variables, avoid_web_libraries_in_flutter, unnecessary_import, avoid_print, use_build_context_synchronously, avoid_init_to_null, await_only_futures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Validations/validators.dart';
import 'package:secure_app/Widgets/DocumentFunctions.dart';
import 'package:secure_app/Widgets/KycCommonFunctions.dart';
import 'package:secure_app/Widgets/NavBar.dart';
import 'package:secure_app/Widgets/DropdownWidget.dart';
import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
import 'package:secure_app/Widgets/InputContainer.dart';
import 'package:secure_app/Widgets/InputField1.dart';
import 'package:secure_app/Widgets/RadioButton.dart';
import 'package:secure_app/Widgets/isLoading.dart';
import 'package:secure_app/Widgets/Style.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Utility/dioSingleton.dart';
import 'package:secure_app/Screens/endorsementDocuments.dart';

class KYCOther extends StatefulWidget {
  final isEdit;
  final isView;
  final inwardData;
  final inwardType;
  final edit;
  final onlinePay;
  final premiumAmount;
  final customerName;
  final customerEmail;
  final customerMobile;
  const KYCOther(
      {super.key,
      this.isEdit = false,
      this.isView = false,
      this.inwardData,
      this.inwardType,
      this.edit = false,
      this.onlinePay = false,
      this.premiumAmount,
      this.customerName,
      this.customerEmail,
      this.customerMobile});

  @override
  State<KYCOther> createState() => _KYCOtherState();
}

class _KYCOtherState extends State<KYCOther> {
  var productName;
  String? _kycAvailable;
  String? _panAvailable;
  String? _cinAvailable;
  String? selectedValue;
  String? selectedDocument;
  String? selectedIdentity;
  String? selectedIdentity2;
  String? selectedIdentity3;
  String? selectedIdentity4;
  String? selectedIdentity5;
  String? selectedIdentity6;
  String? selectedIdentity7;
  String? selectedAddress;
  String incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final controller1 = TextEditingController();
  var oldVersion;
  var checkKYC;
  var ckycExist;
  var paymentLink;
  TextEditingController panNumberController = TextEditingController();
  bool isFetched = false;
  Map labelling = {
    "pan_form60": 'Select Documents',
    "id_proof": 'Proof of Identity',
    "address_proof": 'Proof of Address'
  };
  Map<String, String?> selectedCategories = {
    "pan_form60": null,
    "id_proof": null,
    "address_proof": null,
  };
  Map<String, List> ckycDocuments = {
    "pan_form60": [''],
    "id_proof": [''],
    "address_proof": ['']
  };

  Map<String, List> ckycDocumentsLoaders = {
    "pan_form60": [false],
    "id_proof": [false],
    "address_proof": [false]
  };
  Map<String, List> edittedDocuments = {
    "pan_form60": [''],
    "id_proof": [''],
    "address_proof": ['']
  };

  Map<String, List> oldFileNames = {
    "pan_form60": [null],
    "id_proof": [null],
    "address_proof": [null]
  };
  Map<String, int?> documentIds = {
    "pan_form60": null,
    "id_proof": null,
    "address_proof": null
  };
  List<String> rejectionList = [
    'Registration Certificate',
    'Certificate of Incorporation/Formation'
  ];
  String option = '';
  bool noKYC = false;
  bool editKYC = false;
  bool edit = false;
  bool isSubmitted = false;
  bool fetchKYC = true;
  bool uploading = false;
  List<String> entity = <String>[];
  List<String> documents = <String>[
    'PAN Card',
    'Form 60',
  ];

  List<String> identity2 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Registration Certificate',
    'Partnership Deed'
  ];

  List<String> identity3 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Registration Certificate',
  ];

  List<String> identity4 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Certificate of Incorporation/Formation',
    'Registration Certificate',
    'Memorandum and Articles of Association',
    'Board Resolution'
  ];
  List<String> identity5 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Registration Certificate',
    'Partnership Deed',
    'Trust Deed',
    'Board Resolution'
  ];
  List<String> identity6 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Registration Certificate',
    'Trust Deed',
    'Board Resolution'
  ];

  List<String> identity7 = <String>[
    'OVD in respect of person authorized to transact',
    'Power of Atterney granted to Manager',
    'Registration Certificate',
    'Board Resolution'
  ];
  List<String> address1 = <String>['Registration Certificate', 'Others'];
  List<String> address2 = <String>[
    'Certificate of Incorporation/Formation',
    'Registration Certificate',
    'Others'
  ];
  File? galleryFile;
  final picker = ImagePicker();
  Dio dio = DioSingleton.dio;
  TextEditingController ckycIDController = TextEditingController();
  TextEditingController companyIDController = TextEditingController();
  TextEditingController idProofController = TextEditingController();
  TextEditingController addressProofController = TextEditingController();
  // Map ckycData = {};
  bool isLoading = false;
  Map ckycData = {"CKYCNumber": "", "CKYCFullName": "", "CKYCDOB": ""};
  List ckycEntities = [];
  List entityDropdownData = [];
  final _formKey = GlobalKey<FormState>();
  String inputType = '';
  String inputNo = '';
  var entityID;
  bool kyc = false;
  bool pan = false;
  bool isPan = false;
  bool isCIN = false;
  bool cin = false;
  bool manual = false;
  bool fetchKyc = false;
  bool fetchPan = false;
  bool fetchCIN = false;
  bool enableCKYC = false;
  bool enablePan = false;
  bool enableCIN = false;
  bool enable2 = false;
  bool disable = false;
  bool isViewButton = false;
  bool loadingDoc = false;
  final ValueNotifier<MouseCursor> _cursorNotifier =
      ValueNotifier<MouseCursor>(SystemMouseCursors.basic);

  var onChanged;
  var onChanged2;
  var onChanged3;
  var onChanged4;

  getCkycEntities() async {
    print('done');
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
          'https://uatcld.sbigeneral.in/SecureApp/ckycEntity',
          options: Options(headers: headers));
      var entityData = jsonDecode(response.data);
      print(entityData);

      setState(() {
        ckycEntities = entityData;
        entity = ckycEntities.map<String>((e) => e['entity_type']).toList();
      });
      setState(() {
        isLoading = false;
      });
      if (widget.isView) {
        await getVersion;
        await getCKYCDetails();
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  getCategoryDropdowns(ckycEntityId) async {
    // setState(() {
    //   isLoading = true;
    // });

    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    Map postData = {"ckyc_entity_type_id": ckycEntityId};
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/document-types',
          data: postData,
          options: Options(headers: headers));
      var data = jsonDecode(response.data);
      setState(() {
        entityDropdownData = data['categories'];
        // isLoading = false;
        print(entityDropdownData);
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("online pay ${widget.onlinePay}");

    getVersion();
    getCkycEntities();

    setState(() {
      onChanged = (value) {
        if (_kycAvailable != value) {
          resetVariable();
          // kyc = false;
          isPan = false;
          pan = false;
          isCIN = false;
          cin = false;
          manual = false;
          fetchPan = false;
          fetchCIN = false;
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
            isCIN = false;
            cin = false;
            manual = false;
            fetchPan = false;
            fetchCIN = false;
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
          isCIN = false;
          fetchCIN = false;
          cin = false;
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
            isCIN = false;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
      };
      onChanged3 = (value) {
        if (_panAvailable != value) {
          setState(() {
            _cinAvailable = null;
            selectedValue = null;
            selectedDocument = null;
            selectedCategories = {
              "pan_form60": null,
              "id_proof": null,
              "address_proof": null,
            };
            selectedIdentity = null;
            selectedIdentity2 = null;
            selectedIdentity3 = null;
            selectedIdentity4 = null;
            selectedIdentity5 = null;
            selectedIdentity6 = null;
            selectedIdentity7 = null;
            selectedAddress = null;
            // ckycIDController = TextEditingController();
            companyIDController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();
            incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isCIN = false;
            fetchCIN = false;
            cin = false;
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
            isCIN = false;
            fetchCIN = false;
            cin = false;
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
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
        // if (value == 'Yes') {
        //   setState(() {
        //     _cinAvailable = 'No';
        //     pan = true;
        //     fetchPan = true;
        //   });
        // }
        // if (value == 'No') {
        //   setState(() {
        //     _cinAvailable = null;
        //     _gender = null;
        //     pan = false;
        //     isAadhar = true;
        //     fetchKyc = false;
        //     fetchPan = false;
        //   });
        // }
      };
      onChanged4 = (value) {
        if (_cinAvailable != value) {
          setState(() {
            _cinAvailable = null;
            selectedValue = null;
            selectedDocument = null;
            selectedIdentity = null;
            selectedIdentity2 = null;
            selectedIdentity3 = null;
            selectedIdentity4 = null;
            selectedIdentity5 = null;
            selectedIdentity6 = null;
            selectedIdentity7 = null;
            selectedAddress = null;
            selectedCategories = {
              "pan_form60": null,
              "id_proof": null,
              "address_proof": null,
            };
            // ckycIDController = TextEditingController();
            companyIDController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();
            incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
        setState(() {
          _cinAvailable = value;
        });
        if (_cinAvailable == 'Yes') {
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

            isCIN = true;
            fetchCIN = true;
            cin = true;
            manual = false;
          });
        }
        if (_cinAvailable == 'No') {
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
            companyIDController = TextEditingController();
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = true;
            onChanged = null;
            onChanged2 = null;
            onChanged3 = null;
            onChanged4 = null;
            disable = true;
            enableCKYC = true;
            enablePan = true;
            enableCIN = true;
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
    });
    // getToken();
    // fetchCKYC();
  }

  getCKYCDetails() async {
    print("asdasd");
    setState(() {
      isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);

    var proposalId = appState.proposalId;
    Map<String, dynamic> postData = {"proposal_id": proposalId};

    print(postData);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    String result = aesCbcEncryptJson(jsonEncode(postData));
    Map<String, dynamic> encryptedData = {'encryptedData': result};
    print(encryptedData);

    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/ckycDetails',
          options: Options(headers: headers),
          data: encryptedData);
      // var data = jsonDecode(response.data);
      String decryptedData = aesCbcDecryptJson(response.data);
      print(decryptedData);
      var data = jsonDecode(decryptedData);
      // var data = const JsonDecoder().convert(jsonMap);
      // var data = jsonDecode(decryptedData);
      await getVersion();
      setState(() {
        productName = widget.inwardData['product'];
      });
      print('here it is');
      print(ckycExist);
      if (ckycExist != null) {
        print('here');
        setState(() {
          incorporationDate = data['dob'];
          _kycAvailable = data['ckyc_num'] != null ? "Yes" : 'No';
          if (data['ckyc_num'] != null) {
            kyc = true;
            fetchKyc = false;
            ckycIDController.text = data['ckyc_num'] ?? '';
          }
        });
        setState(() {
          if (data['pan_avail'] == null) {
            isPan = false;
            pan = false;
            fetchPan = false;
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
          if (data['cin_avail'] == null) {
            isCIN = false;
            cin = false;
            fetchCIN = false;
          } else {
            _cinAvailable = data['cin_avail'] == '1' ? "Yes" : 'No';
            if (data['cin_avail'] == '1') {
              isCIN = true;
              cin = true;
              fetchCIN = false;
              companyIDController.text = data['cin'] ?? '';
            } else {
              isCIN = true;
              cin = false;
              fetchCIN = false;
            }
          }

          if (data["ckyc_entity_type_id"] != null) {
            isCIN = true;
            cin = false;
            fetchCIN = false;
            manual = true;
            selectedValue = entity[data["ckyc_entity_type_id"] - 1];
          } else if (data['response_ckyc_num'] != null) {
            isFetched = true;
            ckycData["CKYCNumber"] = data['response_ckyc_num'] ?? '';
            ckycData["CKYCFullName"] =
                data['response_ckyc_customer_name'] ?? '';
            ckycData["CKYCDOB"] = data['response_ckyc_dob'] ?? '';
            isSubmitted = true;
            isLoading = false;
          }
          onChanged = null;
          onChanged2 = null;
          onChanged3 = null;
          onChanged4 = null;
          disable = true;
          enableCKYC = true;
          enablePan = true;
          enableCIN = true;
          enable2 = true;
        });
        setState(() {
          addressProofController.text =
              data["doc_addr_proof_number"] ?? data["doc_id_proof_number"];
          documentIds['id_proof'] = data["doc_id_proof_type_selected"];
          if (data["doc_addr_proof_type_selected"] != null) {
            documentIds['address_proof'] = data["doc_addr_proof_type_selected"];
          }
          documentIds['pan_form60'] = data["doc_pan_form60_type_selected"];
        });

        if (data["doc_id_proof_type_selected"] != null &&
            data["doc_pan_form60_type_selected"] != null) {
          setState(() {
            isLoading = true;
          });
          await getDocuments(
              data["ckyc_entity_type_id"], data["doc_addr_proof_number"]);
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          print('done');
          disable = true;
          onChanged = null;
          onChanged2 = null;
          isLoading = false;
          isViewButton = true;
        });
      }
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

      print('payment link $paymentLink');
      // if (widget.isEdit) {
      //   if (checkKYC == true &&
      //       data['customer_type'].toLowerCase() == 'other') {
      //     setState(() {
      //       editKYC = true;
      //     });
      //   } else {
      //     setState(() {
      //       editKYC = false;
      //     });
      //   }
      // }
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
      print(err);
    }
  }

  Future<bool> editCkycDocuments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await uploadCkycDocuments(appState.proposalId.toString());

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
    formData.append('proposal_id', proposalId);
    formData.append('version', newVersion.toStringAsFixed(1));
    if (entityDropdownData.isEmpty) {
      formData.append('docAvailable', 'N');
    } else {
      for (var i = 0; i < ckycDocuments['pan_form60']!.length; i++) {
        if (ckycDocuments['pan_form60']![i] != '') {
          var fileExtension =
              ckycDocuments['pan_form60']![i]['file'].name.split('.').last;
          formData.appendBlob('files', ckycDocuments['pan_form60']![i]['file'],
              '${documentIds['pan_form60']}_page${i + 1}.$fileExtension');
        }
      }
      for (var i = 0; i < ckycDocuments['id_proof']!.length; i++) {
        if (ckycDocuments['id_proof']![i] != '') {
          var fileExtension =
              ckycDocuments['id_proof']![i]['file'].name.split('.').last;
          formData.appendBlob('files', ckycDocuments['id_proof']![i]['file'],
              '${documentIds['id_proof']}_page${i + 1}.$fileExtension');
        }
      }
      if (documentIds['id_proof'] == 23) {
        var fileExtension =
            ckycDocuments['id_proof']![0]['file'].name.split('.').last;
        formData.appendBlob('files', ckycDocuments['id_proof']![0]['file'],
            '18_page1.$fileExtension');
      } else {
        for (var i = 0; i < ckycDocuments['address_proof']!.length; i++) {
          if (ckycDocuments['address_proof']![i] != '') {
            var fileExtension =
                ckycDocuments['address_proof']![i]['file'].name.split('.').last;
            formData.appendBlob(
                'files',
                ckycDocuments['address_proof']![i]['file'],
                '${documentIds['address_proof']}_page${i + 1}.$fileExtension');
          }
        }
      }
    }

    print("ckycDocuments");

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

  resetVariable() {
    setState(() {
      _panAvailable = null;
      _cinAvailable = null;
      isPan = false;
      pan = false;
      isCIN = false;
      cin = false;
      enableCKYC = false;
      enablePan = false;
      enableCIN = false;
      manual = false;
      disable = false;
      enable2 = false;
      selectedValue = null;
      selectedDocument = null;
      selectedIdentity = null;
      selectedIdentity2 = null;
      selectedIdentity3 = null;
      selectedIdentity4 = null;
      selectedIdentity5 = null;
      selectedIdentity6 = null;
      selectedIdentity7 = null;
      selectedAddress = null;
      selectedCategories = {
        "pan_form60": null,
        "id_proof": null,
        "address_proof": null,
      };
      ckycIDController = TextEditingController();
      panNumberController = TextEditingController();
      companyIDController = TextEditingController();
      idProofController = TextEditingController();
      addressProofController = TextEditingController();
      incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      ckycDocuments = {
        "pan_form60": [''],
        "id_proof": [''],
        "address_proof": ['']
      };
      entityDropdownData = [];
      onChanged = (value) {
        if (_kycAvailable != value) {
          resetVariable();
          isPan = false;
          pan = false;
          isCIN = false;
          cin = false;
          manual = false;
          fetchPan = false;
          fetchCIN = false;
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
            isCIN = false;
            cin = false;
            manual = false;
            fetchPan = false;
            fetchCIN = false;
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
          isCIN = false;
          fetchCIN = false;
          cin = false;
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
            isCIN = false;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
      };
      onChanged3 = (value) {
        if (_panAvailable != value) {
          setState(() {
            _cinAvailable = null;
            selectedValue = null;
            selectedDocument = null;
            selectedIdentity = null;
            selectedIdentity2 = null;
            selectedIdentity3 = null;
            selectedIdentity4 = null;
            selectedIdentity5 = null;
            selectedIdentity6 = null;
            selectedIdentity7 = null;
            selectedAddress = null;
            selectedCategories = {
              "pan_form60": null,
              "id_proof": null,
              "address_proof": null,
            };
            companyIDController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();
            incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isCIN = false;
            fetchCIN = false;
            cin = false;
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
            isCIN = false;
            fetchCIN = false;
            cin = false;
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
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
      };
      onChanged4 = (value) {
        if (_cinAvailable != value) {
          setState(() {
            _cinAvailable = null;
            selectedValue = null;
            selectedDocument = null;
            selectedCategories = {
              "pan_form60": null,
              "id_proof": null,
              "address_proof": null,
            };
            selectedIdentity = null;
            selectedIdentity2 = null;
            selectedIdentity3 = null;
            selectedIdentity4 = null;
            selectedIdentity5 = null;
            selectedIdentity6 = null;
            selectedIdentity7 = null;
            selectedAddress = null;

            companyIDController = TextEditingController();
            idProofController = TextEditingController();
            addressProofController = TextEditingController();
            incorporationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
            kyc = false;
            fetchKyc = false;
            isPan = true;
            pan = false;
            fetchPan = false;
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = false;
          });
        }
        setState(() {
          _cinAvailable = value;
        });
        if (_cinAvailable == 'Yes') {
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

            isCIN = true;
            fetchCIN = true;
            cin = true;
            manual = false;
          });
        }
        if (_cinAvailable == 'No') {
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
            companyIDController = TextEditingController();
            isCIN = true;
            fetchCIN = false;
            cin = false;
            manual = true;
            onChanged = null;
            onChanged2 = null;
            onChanged3 = null;
            onChanged4 = null;
            disable = true;
            enableCKYC = true;
            enablePan = true;
            enableCIN = true;
          });
        }
      };
    });
    // String _member = '';
  }

  fetchCKYC() async {
    setState(() {
      isLoading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    Map<String, dynamic> kycData = {
      "ckycData": {
        "A99RequestData": {
          "source": "secure",
          "GetRecordType": "LE",
          "InputIdType": inputType,
          "InputIdNo": inputNo,
          "DateOfBirth": incorporationDate,
          "MobileNumber": "",
          "Pincode": "",
          "BirthYear": "",
          "Tags": "",
          "ApplicationRefNumber": "",
          "FirstName": "",
          "MiddleName": "",
          "LastName": "",
          "Gender": "",
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
    //     "GetRecordType": "LE",
    //     "InputIdType": inputType,
    //     "InputIdNo": inputNo,
    //     "DateOfBirth": incorporationDate,
    //     "MobileNumber": "",
    //     "Pincode": "",
    //     "BirthYear": "",
    //     "Tags": "",
    //     "ApplicationRefNumber": "",
    //     "FirstName": '',
    //     "MiddleName": '',
    //     "LastName": '',
    //     "Gender": "",
    //     "ResultLimit": "Latest",
    //     "photo": "",
    //     "AdditionalAction": ""
    //   }
    // };

    print(kycData);
    String result = aesCbcEncryptJson(jsonEncode(kycData));
    Map<String, dynamic> encryptedData = {'encryptedData': result};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/ckyc',
          data: encryptedData,
          options: Options(headers: headers));

      if (response.statusCode == 200) {
        // final Map<String, dynamic> data = jsonDecode(response.data);
        String decryptedData = aesCbcDecryptJson(response.data);

        var data = jsonDecode(decryptedData);
        print(data);
        // var data = const JsonDecoder().convert(jsonMap);
        setState(() {
          isFetched = true;
          ckycData = data;
          isLoading = false;
          isSubmitted = true;
          fetchKYC = false;
          if (_kycAvailable == 'Yes') {
            fetchKyc = false;
          }
          if (_panAvailable == 'Yes') {
            fetchKyc = false;
            fetchPan = false;
          }
          if (_cinAvailable == 'Yes') {
            fetchKyc = false;
            fetchPan = false;
            fetchCIN = false;
          }
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isFetched = false;
        noKYC = true;
        editKYC = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("No Records Found!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  getDocumentCategory(documentId) async {
    print("document category function callled");
    print(documentId);

    final appState = Provider.of<AppState>(context, listen: false);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/documentId',
          data: {"id": documentId},
          options: Options(headers: headers));

      return jsonDecode(response.data);
    } catch (err) {
      return null;
    }
  }

  fetchFilePath(String filename) async {
    print("calleddd");
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

  getDocuments(ckycEntityTypeId, addressProofNumber) async {
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
      await getCategoryDropdowns(ckycEntityTypeId);
      List documentIdsInternal = [];

      for (var i = 0; i < data.length; i++) {
        print('filename');
        print(data[i]['file_name']);
        var documentId = data[i]['initial_file_name'];
        // print(documentId);
        String documentName = data[i]['file_name'].split('.')[0];
        var documentIndex = int.parse(documentName[documentName.length - 1]);
        // print(documentIndex);
        Map? categoryMap = await getDocumentCategory(int.parse(documentId));
        // print(categoryMap);
        if (documentIdsInternal.contains(documentId) == false) {
          documentIdsInternal.add(documentId);
        }
        print('hereee it is');
        if (categoryMap != null) {
          print(data[i]['file_name']);
          ckycDocuments[categoryMap['category']]![documentIndex - 1] =
              await fetchFilePath(data[i]['file_name']);
        }
      }
      print(documentIds);
      Map? panForm60Map = await getDocumentCategory(documentIds['pan_form60']);
      Map? idProofMap = await getDocumentCategory(documentIds['id_proof']);
      Map? addressProofMap;
      if (documentIds['address_proof'] != null) {
        addressProofMap =
            await getDocumentCategory(documentIds['address_proof']);
      }
      // print(idProofMap);
      // print(panForm60Map);
      // print(addressProofMap);
      print(panForm60Map!['sub_category']);
      print(idProofMap!['sub_category']);
      setState(() {
        selectedCategories['pan_form60'] = panForm60Map['sub_category'];
        selectedCategories['id_proof'] = idProofMap['sub_category'];

        // print(selectedCategories['pan_form60']);
        // print(selectedCategories['id_proof']);
        if (documentIds['address_proof'] != null) {
          selectedCategories['address_proof'] =
              addressProofMap!['sub_category'];
          print(addressProofNumber);
          // addressProofController.text = addressProofNumber;
          print('above');
        }
      });
      setState(() {
        isLoading = false;
      });
      // print(selectedCategories);
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      print('this is error');
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error! Failed to fetch documents')));
    }
  }

  sendPaymentLink(kycData) async {
    setState(() {
      isLoading = true;
    });
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      Map<String, String> headers = {"Authorization": appState.accessToken};
      Map<String, dynamic> postData = {
        "proposal_id": appState.proposalId,
        "customerName": widget.customerName,
        "customerEmail": widget.customerEmail,
        "customerMobileNo": widget.customerMobile,
        "amount": double.parse(widget.premiumAmount).toStringAsFixed(2),
      };
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/payment/razorpay',
          data: postData,
          options: Options(headers: headers));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: const Text(
      //         "A payment link has been sent to your registered number. Please process the payment to complete your endorsement request."),
      //     action: SnackBarAction(
      //       label: ' Cancel',
      //       onPressed: () {},
      //     )));
      var data = jsonDecode(response.data);
      print(data['message']);

      setState(() {
        isLoading = false;
      });
      showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Payment Link Sent',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              content: const Text(
                "A payment link has been sent to your registered number. Please process the payment to complete your endorsement request",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProposalDocuments(
                                inwardData: widget.inwardData,
                                inwardType: widget.inwardType,
                                isView: widget.isView,
                                isEdit: widget.isEdit,
                                ckycData: kycData,
                                ckycDocuments: null)));
                    //             .then((value) {
                    //   setState(() {
                    //     editKYC = true;
                    //   });
                    //   // Navigator.of(context, rootNavigator: true).pop();
                    //   // return;
                    // });
                  },
                ),
              ],
            );
          });

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
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  sendCkyc(kycData, html.FormData formData) async {
    setState(() {
      isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      print(appState.proposalId);

      String result = aesCbcEncryptJson(
        jsonEncode({"proposal_detail_id": appState.proposalId, ...kycData}),
      );
      print(kycData);

      Map<String, dynamic> encryptedCkycData = {'encryptedData': result};
      print(encryptedCkycData);

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
      if (ckycData['CKYCFullName'] != "" || ckycData['CKYCFullName'] != null) {
        // print(widget.onlinePay);
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
                    ckycDocuments: null)));
        // }
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
      } else {
        String uploadDocResult =
            await uploadCkycDocs(appState.proposalId.toString(), formData);
        print(uploadDocResult);
        if (uploadDocResult == "" || entityDropdownData.isEmpty) {
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
                      ckycDocuments: null)));
          // }
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ProposalDocuments(
          //               inwardData: widget.inwardData,
          //               inwardType: widget.inwardType,
          //               isView: widget.isView,
          //               isEdit: widget.isEdit,
          //               ckycData: kycData,
          //               ckycDocuments: null,
          //             )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(uploadDocResult),
              action: SnackBarAction(
                label: ' Cancel',
                onPressed: () {},
              )));
        }

        setState(() {
          isLoading = false;
          // editKYC = true;
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
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
  //     print(kycData);

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
  //     print(response.data);
  //     await getVersion();
  //     if (ckycData['CKYCFullName'] != "") {
  //       print(widget.onlinePay);
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
  //       // sendPaymentLink();
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
  //           });
  //         }
  //       }
  //       // bool ckycError = await editCkycDocuments();
  //       // setState(() {
  //       //   isLoading = false;
  //       // });
  //       // if (ckycError) {
  //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       //       content: const Text("Ckyc Documents not editted!"),
  //       //       action: SnackBarAction(
  //       //         label: ' Cancel',
  //       //         onPressed: () {},
  //       //       )));
  //       //   return;
  //       // } else {
  //       //   Navigator.push(
  //       //       context,
  //       //       MaterialPageRoute(
  //       //           builder: (context) => ProposalDocuments(
  //       //               inwardData: widget.inwardData,
  //       //               inwardType: widget.inwardType,
  //       //               isView: widget.isView,
  //       //               isEdit: widget.isEdit,
  //       //               ckycData: kycData,
  //       //               ckycDocuments: formData)));
  //       setState(() {
  //         // editKYC = true;
  //       });
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
      print(kycData);

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
      print(response.data);
      await getVersion();
      if (ckycData['CKYCFullName'] != "") {
        print(widget.onlinePay);
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
        }
        // }
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadCkycDocs(proposalId, html.FormData formData) async {
    final appState = Provider.of<AppState>(context, listen: false);

    // Map<String, String> headers = {"Authorization": appState.accessToken};

    String? returnString = null;
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

  void _submitKYC() async {
    Map kycData;
    Map responseCkyc;
    if (manual) {
      responseCkyc = {};
      if (_formKey.currentState!.validate()) {
        if (selectedCategories['pan_form60'] != null) {
          if (ckycDocuments['pan_form60']!.every((dat) => dat == '')) {
            Style.showAlertDialog(
                context, "Please Upload ${selectedCategories['pan_form60']}.");

            return;
          }
        }
        if (selectedCategories['id_proof'] != null) {
          if (ckycDocuments['id_proof']!.every((dat) => dat == '')) {
            Style.showAlertDialog(
                context, "Please Upload Document For Proof of Identity.");
            return;
          }
        }
        if (selectedCategories['address_proof'] != null) {
          if (ckycDocuments['address_proof']!.every((dat) => dat == '')) {
            Style.showAlertDialog(
                context, "Please Upload Document For Proof of Address.");
            return;
          }
        }

        kycData = {
          "ckyc_exist": _kycAvailable == 'Yes' ? 'Y' : 'N',
          "ckyc_num":
              ckycIDController.text == '' ? null : ckycIDController.text,
          "pan_avail": _panAvailable == 'Yes'
              ? '1'
              : _panAvailable == 'No'
                  ? '0'
                  : null,
          "cin_avail": _cinAvailable == 'Yes'
              ? '1'
              : _cinAvailable == 'No'
                  ? '0'
                  : null,
          "customer_type": "other",
          "pan_num":
              panNumberController.text == '' ? null : panNumberController.text,
          "doc_addr_proof_number": addressProofController.text,
          "doc_id_proof_number": addressProofController.text,
          "cin":
              companyIDController.text == '' ? null : companyIDController.text,
          "doc_id_proof_type_selected": documentIds['id_proof'],
          "doc_addr_proof_type_selected":
              documentIds['id_proof'] == 23 ? 18 : documentIds['address_proof'],
          "doc_pan_form60_type_selected": documentIds['pan_form60'],
          "ckyc_entity_type_id": entityID,
          "dob": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(incorporationDate)),
          "otp_transaction_id": null,
          "mobile_no": null,
          ...responseCkyc
        };
        final appState = Provider.of<AppState>(context, listen: false);
        html.FormData formData = html.FormData();
        formData.append('proposal_id', appState.proposalId.toString());
        formData.append('doc_type', 'ckyc');

        for (var i = 0; i < ckycDocuments['pan_form60']!.length; i++) {
          if (ckycDocuments['pan_form60']![i] != '') {
            var fileExtension =
                ckycDocuments['pan_form60']![i]['file'].name.split('.').last;
            formData.appendBlob(
                'files',
                ckycDocuments['pan_form60']![i]['file'],
                '${documentIds['pan_form60']}_page${i + 1}.$fileExtension');
          }
        }
        for (var i = 0; i < ckycDocuments['id_proof']!.length; i++) {
          if (ckycDocuments['id_proof']![i] != '') {
            var fileExtension =
                ckycDocuments['id_proof']![i]['file'].name.split('.').last;
            formData.appendBlob('files', ckycDocuments['id_proof']![i]['file'],
                '${documentIds['id_proof']}_page${i + 1}.$fileExtension');
          }
        }
        if (documentIds['id_proof'] == 23) {
          var fileExtension =
              ckycDocuments['id_proof']![0]['file'].name.split('.').last;
          formData.appendBlob('files', ckycDocuments['id_proof']![0]['file'],
              '18_page1.$fileExtension');
        } else {
          for (var i = 0; i < ckycDocuments['address_proof']!.length; i++) {
            if (ckycDocuments['address_proof']![i] != '') {
              var fileExtension = ckycDocuments['address_proof']![i]['file']
                  .name
                  .split('.')
                  .last;
              formData.appendBlob(
                  'files',
                  ckycDocuments['address_proof']![i]['file'],
                  '${documentIds['address_proof']}_page${i + 1}.$fileExtension');
            }
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
        //                   sendCkyc(
        //                     kycData,
        //                     formData,
        //                   );
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
        if (checkKYC == false) {
          sendCkyc(
            kycData,
            formData,
          );
        } else {
          editCkyc(kycData, formData, context);
        }
        // }
      } else {
        Style.showAlertDialog(context, "Please fill out all the form fields.");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: const Text("Please fill out all the form fields"),
        //     action: SnackBarAction(
        //       label: ' Cancel',
        //       onPressed: () {},
        //     )));
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
        "cin_avail": _cinAvailable == 'Yes'
            ? '1'
            : _cinAvailable == 'No'
                ? '0'
                : null,
        "customer_type": "other",
        "pan_num":
            panNumberController.text == '' ? null : panNumberController.text,
        "doc_addr_proof_number": addressProofController.text,
        "doc_id_proof_number": addressProofController.text,
        "cin": companyIDController.text == '' ? null : companyIDController.text,
        "doc_id_proof_type_selected": documentIds['id_proof'],
        "doc_addr_proof_type_selected": documentIds['address_proof'],
        "doc_pan_form60_type_selected": documentIds['pan_form60'],
        "ckyc_entity_type_id": entityID,
        "dob": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(incorporationDate)),
        "response_ckyc_num": ckycData['CKYCNumber'],
        "response_ckyc_dob": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MMM-yyyy").parse(ckycData['CKYCDOB'])),
        "response_ckyc_customer_name": ckycData['CKYCFullName'],
        "otp_transaction_id": null,
        "mobile_no": null,
      };
      html.FormData formData = html.FormData();
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
      //                   sendCkyc(
      //                     kycData,
      //                     formData,
      //                   );
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
      if (checkKYC == false) {
        sendCkyc(
          kycData,
          formData,
        );
      } else {
        editCkyc(kycData, formData, context);
      }
      // }
    }
  }

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
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      CustomInputContainer(
                                        children: [
                                          heightGap(),
                                          Style.wrap(
                                            context,
                                            children: [
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
                                            ],
                                          ),
                                          KycCommonFunctions.dateField(context,
                                              disable, 'Date of Incorporation',
                                              (DateTime? value) {
                                            setState(() {
                                              incorporationDate = DateFormat(
                                                      'dd-MM-yyyy')
                                                  .format(value as DateTime);
                                            });
                                          }, incorporationDate),
                                        ],
                                      ),
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
                                          : const SizedBox.shrink(),
                                      heightGap(),
                                      isPan
                                          ? CustomInputContainer(
                                              children: [
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
                                                        })
                                                      : const SizedBox.shrink(),
                                                ]),
                                                heightGap()
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      heightGap(),
                                      fetchPan
                                          ? KycCommonFunctions.fetchButton(() {
                                              print('done');
                                              if (_panAvailable != null &&
                                                  _formKey.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  inputType = 'C';
                                                  inputNo =
                                                      panNumberController.text;
                                                  option = 'Company ID Number';
                                                });
                                                fetchCKYC();
                                              } else {
                                                Style.showAlertDialog(context,
                                                    'Please enter valid details.');
                                              }
                                            })
                                          : const SizedBox.shrink(),
                                      isCIN
                                          ? CustomInputContainer(
                                              children: [
                                                Style.wrap(context, children: [
                                                  RadioButton.customRadio(
                                                      context,
                                                      'Do you have Company ID Number?',
                                                      _cinAvailable,
                                                      onChanged4),
                                                  cin
                                                      ? KycCommonFunctions
                                                          .companyIdInputField(
                                                              enableCIN,
                                                              companyIDController)
                                                      : const SizedBox.shrink(),
                                                ]),
                                                heightGap()
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      heightGap(),
                                      fetchCIN
                                          ? KycCommonFunctions.fetchButton(
                                              () {
                                                print('done');
                                                if (_panAvailable != null &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  setState(() {
                                                    inputType = '02';
                                                    inputNo =
                                                        companyIDController
                                                            .text;
                                                    option = 'Document Upload';
                                                  });
                                                  fetchCKYC();
                                                } else {
                                                  Style.showAlertDialog(context,
                                                      'Please enter valid details.');
                                                  // ScaffoldMessenger.of(context)
                                                  //     .showSnackBar(
                                                  //   const SnackBar(
                                                  //       content: Text(
                                                  //           'Please enter valid details!')),
                                                  // );
                                                }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                      manual
                                          ? CustomInputContainer(
                                              children: [
                                                KycCommonFunctions
                                                    .customDropDown(
                                                        'Entity Type:',
                                                        (value) {
                                                  setState(() {
                                                    selectedCategories = {
                                                      "pan_form60": null,
                                                      "id_proof": null,
                                                      "address_proof": null,
                                                    };
                                                    ckycDocuments = {
                                                      "pan_form60": [''],
                                                      "id_proof": [''],
                                                      "address_proof": ['']
                                                    };
                                                    selectedValue = value;
                                                    print(selectedValue);
                                                    var id = ckycEntities
                                                        .where((d) =>
                                                            d['entity_type'] ==
                                                            value)
                                                        .first['id'];
                                                    getCategoryDropdowns(id);
                                                    entityID = id;
                                                    print(entityID);
                                                  });
                                                }, entity, selectedValue,
                                                        enable2),
                                                // heightGap(),
                                                entityDropdownData.isNotEmpty
                                                    ? Column(
                                                        // spacing: 20,
                                                        // // runSpacing: 15,
                                                        // alignment: WrapAlignment.start,
                                                        // crossAxisAlignment:
                                                        //     WrapCrossAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          KycCommonFunctions.customDropDown(
                                                              'Select Documents:',
                                                              (String?
                                                                  newValue) {
                                                            setState(() {
                                                              ckycDocuments[
                                                                  'pan_form60'] = [
                                                                ''
                                                              ];
                                                              selectedCategories[
                                                                      'pan_form60'] =
                                                                  newValue;
                                                              var indexDocumentType = List<
                                                                          String>.from(
                                                                      entityDropdownData[
                                                                              0]
                                                                          [
                                                                          'sub_categories'])
                                                                  .indexOf(
                                                                      newValue!);
                                                              if (indexDocumentType !=
                                                                  -1) {
                                                                documentIds[
                                                                    'pan_form60'] = entityDropdownData[
                                                                            0][
                                                                        "documentIds"]
                                                                    [
                                                                    indexDocumentType];
                                                              }
                                                            });
                                                          },
                                                              List<String>.from(
                                                                  entityDropdownData[
                                                                          0][
                                                                      'sub_categories']),
                                                              selectedCategories[
                                                                  'pan_form60'],
                                                              enable2),
                                                          heightGap(),
                                                          ckycDocuments['pan_form60']!
                                                                          .length <
                                                                      2 &&
                                                                  selectedCategories[
                                                                          'pan_form60'] !=
                                                                      null
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    widget.isView ==
                                                                            false
                                                                        ? TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                ckycDocuments['pan_form60']!.add('');
                                                                                if (widget.isEdit) {
                                                                                  edittedDocuments['pan_form60']!.add('');
                                                                                  oldFileNames['pan_form60']!.add(null);
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              '+',
                                                                              style: TextStyle(color: Color.fromRGBO(11, 133, 163, 1), fontSize: 20, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                  ],
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                          selectedCategories[
                                                                      'pan_form60'] !=
                                                                  null
                                                              ? Wrap(
                                                                  spacing: 20,
                                                                  runSpacing:
                                                                      15,
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  children: [
                                                                    ...List.generate(
                                                                        ckycDocuments['pan_form60']!
                                                                            .length,
                                                                        (index) {
                                                                      return _uploadDocument(
                                                                          'pan_form60',
                                                                          index);
                                                                    }),
                                                                  ],
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                          heightGap(),
                                                          entityDropdownData
                                                                  .isNotEmpty
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    KycCommonFunctions.customDropDown(
                                                                        'Proof of Identity:',
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        ckycDocuments[
                                                                            "address_proof"] = [
                                                                          ''
                                                                        ];
                                                                        addressProofController.text ==
                                                                            '';
                                                                        selectedCategories['address_proof'] =
                                                                            null;
                                                                        ckycDocuments[
                                                                            'id_proof'] = [
                                                                          ''
                                                                        ];
                                                                        selectedCategories['id_proof'] =
                                                                            newValue;
                                                                        var indexDocumentType =
                                                                            List<String>.from(entityDropdownData[2]['sub_categories']).indexOf(newValue!);
                                                                        if (indexDocumentType !=
                                                                            -1) {
                                                                          documentIds['id_proof'] =
                                                                              entityDropdownData[2]["documentIds"][indexDocumentType];
                                                                        }
                                                                      });
                                                                    },
                                                                        List<
                                                                            String>.from(entityDropdownData[
                                                                                2]
                                                                            [
                                                                            'sub_categories']),
                                                                        selectedCategories[
                                                                            'id_proof'],
                                                                        enable2),
                                                                    selectedCategories['id_proof'] !=
                                                                            null
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              entityInputs(selectedCategories['id_proof']),
                                                                              heightGap(),
                                                                              ckycDocuments['id_proof']!.length < 8 && selectedCategories['id_proof'] != null
                                                                                  ? Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        widget.isView == false
                                                                                            ? TextButton(
                                                                                                onPressed: () {
                                                                                                  setState(() {
                                                                                                    ckycDocuments['id_proof']!.add('');
                                                                                                    if (widget.isEdit) {
                                                                                                      edittedDocuments['id_proof']!.add('');
                                                                                                      oldFileNames['id_proof']!.add(null);
                                                                                                    }
                                                                                                  });
                                                                                                },
                                                                                                child: const Text(
                                                                                                  '+',
                                                                                                  style: TextStyle(color: Color.fromRGBO(143, 19, 168, 1), fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              )
                                                                                            : const SizedBox.shrink(),
                                                                                      ],
                                                                                    )
                                                                                  : const SizedBox.shrink(),
                                                                              Wrap(
                                                                                spacing: 20,
                                                                                runSpacing: 15,
                                                                                alignment: WrapAlignment.start,
                                                                                children: [
                                                                                  ...List.generate(ckycDocuments['id_proof']!.length, (index) {
                                                                                    return _uploadDocument('id_proof', index);
                                                                                  }),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                  ],
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                          heightGap(),
                                                          selectedCategories[
                                                                          'id_proof'] !=
                                                                      null &&
                                                                  rejectionList.contains(
                                                                          selectedCategories[
                                                                              'id_proof']) ==
                                                                      false
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    KycCommonFunctions.customDropDown(
                                                                        'Proof of Address:',
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        ckycDocuments[
                                                                            'address_proof'] = [
                                                                          ''
                                                                        ];
                                                                        selectedCategories['address_proof'] =
                                                                            newValue;
                                                                        var indexDocumentType =
                                                                            List<String>.from(entityDropdownData[1]['sub_categories']).indexOf(newValue!);
                                                                        if (indexDocumentType !=
                                                                            -1) {
                                                                          documentIds['address_proof'] =
                                                                              entityDropdownData[1]["documentIds"][indexDocumentType];
                                                                          print(
                                                                              documentIds);
                                                                        }
                                                                      });
                                                                    },
                                                                        List<
                                                                            String>.from(entityDropdownData[
                                                                                1]
                                                                            [
                                                                            'sub_categories']),
                                                                        selectedCategories[
                                                                            'address_proof'],
                                                                        enable2),
                                                                    selectedCategories['address_proof'] !=
                                                                            null
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              entityInputs(selectedCategories['address_proof']),
                                                                              heightGap(),
                                                                              ckycDocuments['address_proof']!.length < 8 && selectedCategories['address_proof'] != null
                                                                                  ? Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        widget.isView == false
                                                                                            ? TextButton(
                                                                                                onPressed: () {
                                                                                                  setState(() {
                                                                                                    ckycDocuments['address_proof']!.add('');
                                                                                                    if (widget.isEdit) {
                                                                                                      edittedDocuments['address_proof']!.add('');
                                                                                                      oldFileNames['address_proof']!.add(null);
                                                                                                    }
                                                                                                  });
                                                                                                },
                                                                                                child: const Text(
                                                                                                  '+',
                                                                                                  style: TextStyle(color: Color.fromRGBO(143, 19, 168, 1), fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              )
                                                                                            : const SizedBox.shrink(),
                                                                                      ],
                                                                                    )
                                                                                  : const SizedBox.shrink(),
                                                                              heightGap(),
                                                                              Wrap(
                                                                                spacing: 20,
                                                                                runSpacing: 15,
                                                                                alignment: WrapAlignment.start,
                                                                                runAlignment: WrapAlignment.center,
                                                                                children: [
                                                                                  ...List.generate(ckycDocuments['address_proof']!.length, (index) {
                                                                                    return _uploadDocument('address_proof', index);
                                                                                  }),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                  ],
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                          heightGap(),
                                                        ],
                                                      )
                                                    : const SizedBox.shrink(),
                                                heightGap(),
                                                Style.formSubmitButton(
                                                  widget.isView
                                                      ? 'Next'
                                                      : 'Next',
                                                  () {
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
                                                        _submitKYC();
                                                      }
                                                    }
                                                  },
                                                ),
                                                heightGap()
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      heightGap(),
                                      heightGap(),
                                      isFetched
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                KycCommonFunctions
                                                    .ckycFetchedContainer(
                                                        context,
                                                        'Other',
                                                        ckycData[
                                                            'CKYCFullName'],
                                                        ckycData['CKYCNumber']
                                                            .toString(),
                                                        ckycData['CKYCDOB'],
                                                        '',
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
                                                                    builder: (context) => ProposalDocuments(
                                                                        isView: widget
                                                                            .isView,
                                                                        isEdit: widget
                                                                            .isEdit,
                                                                        inwardData:
                                                                            widget
                                                                                .inwardData,
                                                                        inwardType:
                                                                            widget
                                                                                .inwardType,
                                                                        ckycData:
                                                                            null,
                                                                        ckycDocuments:
                                                                            null)));
                                                          } else {
                                                            _submitKYC();
                                                          }
                                                        }
                                                      })
                                                    : Container()
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          noKYC
              ? KycCommonFunctions.noKYC(context, option, () {
                  setState(() {
                    noKYC = false;
                    if (_cinAvailable == 'Yes') {
                      setState(() {
                        _cinAvailable = 'Yes';
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

                        fetchPan = false;
                        isCIN = true;
                        cin = true;
                        fetchCIN = true;
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
                        isCIN = false;
                        cin = false;
                        fetchCIN = false;
                        manual = false;
                      });
                    } else if (_kycAvailable == 'Yes') {
                      setState(() {
                        kyc = true;
                        fetchKyc = true;
                        isPan = false;
                        pan = false;
                        fetchPan = false;
                        isCIN = false;
                        fetchCIN = false;
                        cin = false;
                        manual = false;
                      });
                    }
                  });
                }, () {
                  // getVersion();
                  setState(() {
                    noKYC = false;
                  });
                  if (_cinAvailable == 'Yes') {
                    setState(() {
                      onChanged = null;
                      onChanged2 = null;
                      onChanged3 = null;
                      onChanged4 = null;
                      disable = true;
                      enableCKYC = true;
                      enablePan = true;
                      enableCIN = true;
                      if (_kycAvailable == 'Yes') {
                        kyc = true;
                        fetchKyc = false;
                      }
                      fetchKyc = false;
                      if (_panAvailable == 'Yes') {
                        isPan = true;
                        pan = true;
                        fetchPan = false;
                      }
                      fetchPan = false;

                      isCIN = true;
                      cin = true;
                      fetchCIN = false;
                      manual = true;
                    });
                  } else if (_panAvailable == 'Yes') {
                    print('next aadhar');
                    setState(() {
                      if (_kycAvailable == 'Yes') {
                        kyc = true;
                        fetchKyc = false;
                        disable = true;
                        enableCKYC = true;
                      } else {
                        kyc = false;
                      }
                      onChanged = null;
                      onChanged2 = null;
                      onChanged3 = null;
                      enablePan = true;
                      fetchKyc = false;
                      isPan = true;
                      pan = true;
                      fetchPan = false;
                      _cinAvailable = 'Yes';
                      isCIN = true;
                      cin = true;
                      fetchCIN = true;
                      manual = false;
                    });
                  } else if (_kycAvailable == 'Yes') {
                    setState(() {
                      kyc = true;
                      fetchKyc = false;
                      onChanged = null;
                      onChanged2 = null;
                      disable = true;
                      enableCKYC = true;
                      _panAvailable = 'Yes';
                      isPan = true;
                      pan = true;
                      fetchPan = true;
                      isCIN = false;
                      fetchCIN = false;
                      cin = false;
                      manual = false;
                    });
                  }
                })
              : const SizedBox.shrink(),
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
                  () {
                    setState(() {
                      // getVersion();
                      _kycAvailable = null;
                      resetVariable();
                      editKYC = false;
                      // edit = true;
                    });
                  },
                )
              : const SizedBox.shrink(),
          isLoading
              ? const LoadingPage(
                  label: "Loading",
                )
              : Container()
        ],
      ),
    );
  }

  entityInputs(String? type) {
    List inputsAllowed = [
      'Registration Certificate',
      'Certificate of Incorporation/Formation',
      'Others'
    ];

    if (inputsAllowed.contains(type)) {
      if (type == 'Registration Certificate') {
        return CustomInputField(
            view: enable2,
            controller: addressProofController,
            title: 'Registration Certificate',
            validator: Validators.registrationNumberValidation);
      } else if (type == 'Certificate of Incorporation/Formation') {
        return CustomInputField(
            view: enable2,
            controller: addressProofController,
            title: 'Company Id Number',
            validator: Validators.companyIdValidation);
      } else {
        return CustomInputField(
            view: enable2,
            controller: addressProofController,
            title: 'Other document name',
            validator: Validators.otherDocsValidation);
      }
    } else {
      return Container();
    }
  }

  _customDropDown(String label, onChanged, items, value) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(
          //   label,
          //   style: const TextStyle(
          //       color: Color.fromRGBO(143, 19, 168, 1),
          //       fontSize: 13,
          //       fontWeight: FontWeight.bold),
          // ),
          DropdownWidget(
            required: true,
            view: enable2,
            items: items,
            value: value,
            onChanged: onChanged,
            label: label,
          )
        ]);
  }

  _uploadDocument(String type, int index) {
    if (widget.isView && ckycDocuments[type]![index] == '') {
      return Container();
    }
    return DocumentCommonFunctions.uploadDocument(
      context,
      index,
      type,
      ckycDocuments[type]![index],
      widget.isView,
      widget.isEdit,
      () {
        if (widget.isView == false) {
          _pickFile(type, index);
        }
      },
      () {
        if (ckycDocuments[type]![index] != null &&
            ckycDocuments[type]![index].isNotEmpty) {
          html.Url.revokeObjectUrl(ckycDocuments[type]![index]['url']);
        }
        setState(() {
          ckycDocuments[type]![index] = '';
        });
      },
      ckycDocumentsLoaders,
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
              if (ckycDocuments[type]![index] != null &&
                  ckycDocuments[type]![index].isNotEmpty) {
                html.Url.revokeObjectUrl(ckycDocuments[type]![index]);
              }
              ckycDocuments[type]![index] = {
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
  //     ckycDocumentsLoaders[type]![index] = true;
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
  //           if (ckycDocuments[type]![index] != null &&
  //               ckycDocuments[type]![index].isNotEmpty) {
  //             html.Url.revokeObjectUrl(ckycDocuments[type]![index]);
  //           }
  //           ckycDocuments[type]![index] = {
  //             "url": url,
  //             "fileType": fileType,
  //             "file": file,
  //             "file_name": fileName,
  //           };
  //         });
  //         setState(() {
  //           ckycDocumentsLoaders[type]![index] = false;
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
