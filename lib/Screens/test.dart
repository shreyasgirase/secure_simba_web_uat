// // ignore_for_file: unnecessary_import, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print, library_private_types_in_public_api, prefer_typing_uninitialized_variables

// import 'dart:convert';
// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:secure_app/Encryption-Decryption/AES-GCM.dart';
// import 'package:secure_app/Screens/dashboard.dart';
// import 'package:secure_app/Widgets/NavBar.dart';
// import 'package:secure_app/Widgets/DatePickerFormField.dart';
// import 'package:secure_app/Widgets/DropdownWidget.dart';
// import 'package:secure_app/Widgets/InputField2.dart';
// import 'package:secure_app/Widgets/RenderForm.dart';
// import 'package:secure_app/Widgets/InputField1.dart';
// import 'package:secure_app/Widgets/isLoading.dart';
// import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
// import 'package:secure_app/Widgets/InputContainer.dart';
// import 'package:secure_app/Widgets/Style.dart';
// import 'package:secure_app/Utility/customProvider.dart';
// import 'package:secure_app/Utility/dioSingleton.dart';
// import 'package:secure_app/Screens/kycOther.dart';
// import 'package:secure_app/Screens/kycIndividual.dart';
// import 'package:secure_app/Screens/endorsementDocuments.dart';
// import 'package:secure_app/Validations/validators.dart';

// class MyForm extends StatefulWidget {
//   final String proposalId;
//   final bool isView;
//   final bool isEdit;
//   final String formStatus;
//   final String paymentStatus;

//   const MyForm(
//       {super.key,
//       this.proposalId = '',
//       this.isView = false,
//       this.isEdit = false,
//       this.formStatus = '',
//       this.paymentStatus = ''});
//   @override
//   _MyFormState createState() => _MyFormState();
// }

// class _MyFormState extends State<MyForm> {
//   // String propInwardType = 'Proposal';
//   int? propProposalId;

//   List instruments = [
//     {
//       'instrumentType': null,
//       'instrumentNumber': '',
//       'instrumentAmount': '',
//       'instrumentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//     }
//   ];
//   List<TextEditingController> instrumentAmounts = [TextEditingController()];
//   List<TextEditingController> instrumentNumbers = [TextEditingController()];
//   final _formKey = GlobalKey<FormState>();
//   final _formKey2 = GlobalKey<FormState>();
//   final _formKey3 = GlobalKey<FormState>();
//   List<String> productList = <String>['Nope'];
//   List<String> list = <String>[
//     'EFT',
//     'Cash',
//     'Cheque',
//     'Credit Card',
//     'Agent Cash Deposit',
//     'Bank Guarantee',
//     'Customer Cash Deposit',
//     'Demand Draft',
//     'Customer Balance'
//   ];
//   List<String> mode = <String>[
//     'Physical',
//     'Digital',
//   ];
//   List<String> yesNo = <String>[
//     'Yes',
//     'No',
//   ];
//   List<String> leaderFollower = <String>[
//     'Leader',
//     'Follower',
//   ];
//   List<String> individualOther = <String>[
//     'Individual',
//     'Other than Individual',
//   ];
//   List<String> spCodes = <String>['124456', '124452', '124458', '124459'];
//   List<String> inwardType = <String>[
//     'endorsement',
//   ];

//   List<String> branches = <String>['Udaipur', 'Jaipur', 'Mumbai', 'Assam'];
//   final List<String> items = ['23456', '12345', '34567', '23528'];
//   // var dropdownValue = "";
//   TextEditingController customerNameController = TextEditingController();
//   TextEditingController previousPolicyController = TextEditingController();
//   TextEditingController premiumAmountController = TextEditingController();
//   TextEditingController instrumentNumberController = TextEditingController();
//   TextEditingController instrumentAmountController = TextEditingController();
//   TextEditingController salesEmailController = TextEditingController();
//   TextEditingController salesMobileController = TextEditingController();
//   TextEditingController policyNumberController = TextEditingController();
//   TextEditingController quoteNumberController = TextEditingController();
//   TextEditingController portalPolicyNumberController = TextEditingController();
//   TextEditingController premiumCollectedController = TextEditingController();
//   TextEditingController referenceNumberController = TextEditingController();
//   TextEditingController sbigAccountNumberController = TextEditingController();
//   TextEditingController paymentModeController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController accountHolderNameController = TextEditingController();
//   TextEditingController accountNumberController = TextEditingController();
//   TextEditingController ifscController = TextEditingController();
//   TextEditingController accountTypeController = TextEditingController();
//   TextEditingController refundAmountController = TextEditingController();
//   TextEditingController customerAccountController = TextEditingController();
//   TextEditingController requesterRemarkController = TextEditingController();
//   TextEditingController discrepancyReasonController = TextEditingController();
//   TextEditingController discrepancyResolveRemarkController =
//       TextEditingController();
//   TextEditingController oldValueController = TextEditingController();
// // newwwwww controllerss
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController customerEmailController = TextEditingController();
//   TextEditingController productController = TextEditingController();
//   TextEditingController secondarySalesNameController = TextEditingController();
//   TextEditingController secondarySalesCodeController = TextEditingController();
//   TextEditingController spCodeController = TextEditingController();
//   TextEditingController sbiBranchController = TextEditingController();
//   TextEditingController intermediaryNameController = TextEditingController();
//   TextEditingController intermediaryCodeController = TextEditingController();

//   TextEditingController ckycNumberController = TextEditingController();
//   TextEditingController ckycNameController = TextEditingController();
//   TextEditingController ckycDateController = TextEditingController();
//   TextEditingController ckycTypeController = TextEditingController();

//   TextEditingController otherMobileNumberController = TextEditingController();
//   TextEditingController otherNameController = TextEditingController();
//   TextEditingController otherEmailController = TextEditingController();

//   TextEditingController totalPremiumPaidController = TextEditingController();
//   TextEditingController pendingPremiumAmountController =
//       TextEditingController();
//   FocusNode focusNode1 = FocusNode();
//   String? selectedCode;
//   String? selectedEndorsementRequestType;
//   String? selectedEndorsementType;
//   String? selectedEndorsementSubType;
//   TextEditingController agreementCodeController = TextEditingController();
//   List<String> products = [];
//   String? category;
//   List<String> endorsementRequestType = [
//     'Basic Information Endorsement',
//     'Cancellation & Refund',
//     'Financial Endorsement'
//   ];
//   List<String> endorsementType = [];
//   List<String> paymentMode = ["Cheque", "Online"];
//   List<String> refundReason = [];
//   List<String> refundType = [];
//   List<String> endorsementSubType = [];
//   List productName = [];
//   String retrivedNewValue = '';
//   String? requestType;
//   String _inwardType = 'endorsement';
//   String _modeOfSubmission1 = 'online';
//   bool isValid = false;
//   bool view = false;
//   bool codeMapped = false;

//   bool isLoading = false;
//   List customerTypeRejectionList = [
//     'Group Loan Insurance',
//     "Group Sampoorna Arogya",
//     'Personal Accident',
//     "Travel Group Insurance (Business and Holiday)",
//     "GHI"
//   ];
//   String instrumentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String proposedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String policyIssueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String requestReceivedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String _coInsurance = 'No';
//   // ignore: non_constant_identifier_names
//   String _PPHC = 'No';
//   String? customerType;
//   String? leadType;
//   String? selectedRefundReason;
//   String? selectedRefundType;
//   String? selectedPaymentMode;
//   // String? productController.text;
//   String? selectedProposal;
//   String? selectedSPCode;
//   String? selectedBranch;
//   String? selectedSBIGBranch;
//   String? selectedInstrumentType;
//   String? salesID;
//   Map? endorsementData;
//   int instrumentAmount = 0;
//   Dio dio = DioSingleton.dio;
//   List? endorsementFields;
//   var proposalData;
//   var onChanged;
//   var onChanged2;
//   bool noPolicy = false;
//   Widget dynamicForm = const SizedBox.shrink();
//   var productType;
//   var checkCustomerType;
//   bool edit = false;
//   bool mandatoryFields = false;
//   bool verifyPolicy = false;
//   bool viewDetails = true;
//   bool viewPolicy = false;
//   bool required = true;
//   bool generateLink = false;
//   bool paymentButton = false;
//   bool ckycDetails = false;
//   bool verifyButton = false;
//   bool paymentLink = false;
//   bool isResolved = false;

//   String? customerEmailId;
//   String? customerMobile;
//   String? linkSentTo;

//   Map<String, dynamic> policyRmMap = {
//     "0414228": [
//       "0000000101754031",
//       "0000000010533072-05",
//       "0000000039454084",
//       "0000000039500216",
//       "0000000033199069",
//     ]
//   };

//   List testPolicy = [
//     "0000000101754031",
//     "0000000010533072-05",
//     "0000000039454084",
//     "0000000039500216",
//     "0000000033199069",
//     "0000000039477216",
//     "0000000039455588",
//     "0000000033451785",
//     "0000000033256361",
//     "0000000034848077",
//   ];

//   String? checkCode;

//   @override
//   void initState() {
//     super.initState();
//     // getPolicyDetails('0000000033199069');
//     // Map<String, dynamic> sendData = {
//     //   "source": "simba",
//     //   "policyNumber": "0000000101754031",
//     // };
//     // String encrypted = aesGcmEncryptJson(jsonEncode(sendData));
//     // print(encrypted);

//     // var decrypted = aesGcmDecryptJson(
//     //     "JlG2XDIHS80O2oO/QKMbkjEEbEio4ty4NHgcHZHnXrc+Bi0wPYphXd2MWULFI4Yu4nKxeT7okzfkRlmm4LfCgAZ9Durl0WZJCgljvxHNTR9S1Q==");
//     // var data = jsonDecode(decrypted);
//     // print(decrypted);
//     // print(data);
//     print(" edit : ${widget.isEdit}");
//     print(" view: ${widget.isView}");

//     // getProposalProductList();
//     // checkEndorsementType("Arogya Sanjeevani");
//     // getPolicyDetails("0000000086180971-01");
//     setState(() {
//       // mandatoryFields = false;
//     });
//     if (widget.isEdit) {
//       setState(() {
//         verifyButton = false;
//       });
//     }
//     if (widget.isView) {
//       setState(() {
//         verifyButton = false;
//       });
//     }
//     if (widget.isView == false && widget.isEdit == false) {
//       setState(() {
//         verifyButton = true;
//       });
//     }
//     // _inwardType = 'Endorsement';
//     // _modeOfSubmission1 = 'Digital';

//     onChanged2 = (value) {
//       setState(() {
//         customerType = value!;
//       });
//     };
//     onChanged = (value) {
//       setState(() {
//         _modeOfSubmission1 = value;
//       });
//     };
//     if (widget.isView || widget.isEdit || edit) {
//       instruments = [];
//       getVersion();
//       getInwardDetails();
//       setState(() {});
//     }

//     setState(() {
//       endorsementData = {'endorsement': {}};
//     });
//   }

//   getVersion() async {
//     print('version');
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final appState = Provider.of<AppState>(context, listen: false);
//       Map<String, String> headers = {"Authorization": appState.accessToken};
//       Map<String, dynamic> postData = {'proposal_id': appState.proposalId};
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/getCkycDocVersion',
//           data: postData,
//           options: Options(headers: headers));
//       var data = jsonDecode(response.data);
//       print(data);

//       setState(() {
//         isLoading = false;
//       });
//       // print(data);

//       // if (widget.isView == false) {
//       //   setState(() {
//       //     isLoading = false;
//       //   });
//       // }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       print("error ${err}");
//     }
//   }

//   getEndorsementFields(endorsementSubType, endorsementRequestType) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final appState = Provider.of<AppState>(context, listen: false);
//       // Map<String, dynamic> postData = {"id": widget.proposalId};

//       Map<String, String> headers = {
//         'Content-Type': 'application/json; charset=UTF-8',
//         "Accept": "application/json",
//         "Authorization": appState.accessToken
//       };

//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/endorsementDetails/endorsementFields',
//           options: Options(headers: headers),
//           data: {
//             "subType": endorsementSubType,
//             "requestorType": endorsementRequestType
//           });
//       print(jsonDecode(response.data)['fields'] as List);
//       // setState(() {
//       //   endorsementFields = response.data['fields'];
//       // });
//       // return response.data['fields'];
//       setState(() {
//         dynamicForm = InsuranceForm(
//             fillDetails: retrivedNewValue,
//             getDetails: getEndorsementValues,
//             subType: selectedEndorsementSubType,
//             fields: jsonDecode(response.data)['fields'] as List,
//             isView: view);
//         // endorsementFields = jsonDecode(response.data)['fields'] as List;
//         isLoading = false;
//       });
//     } catch (err) {
//       print(err);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   getInwardDetails() async {
//     print('call');
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       Map<String, dynamic> postData = {"id": widget.proposalId};
//       final appState = Provider.of<AppState>(context, listen: false);
//       String result = aesCbcEncryptJson(jsonEncode(postData));
//       Map<String, dynamic> encryptedData = {'encryptedData': result};
//       print(encryptedData);
//       // print(postData);

//       Map<String, String> headers = {
//         'Content-Type': 'application/json; charset=UTF-8',
//         "Accept": "application/json",
//         "Authorization": appState.accessToken
//       };

//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/allProposalDetails',
//           options: Options(headers: headers),
//           data: encryptedData);
//       String decryptedData = aesCbcDecryptJson(response.data);
//       print(decryptedData);
//       // String decryptedData2 =
//       //     aesCbcDecryptJson(response.data['instruments'], key, base64iv);

//       var resData = jsonDecode(decryptedData);
//       var data = resData['proposalDetails'];
//       var instrumentData = resData['instruments'];
//       var data2 = resData['proposalDetails']['additional_proposal_details'];
//       var data3 = resData['paymentDetails'];
//       var data4 = resData['policyDetails'];
//       var data5 = resData['ckycDetails'];

//       // var data = const JsonDecoder().convert(jsonMap1);
//       // var instrumentData = List.from(const JsonDecoder().convert(jsonMap2));
//       // print(data);
//       print(data2);

//       // await getProposalProductList();

//       appState.updateVariables(proposalId: data['id']);

//       setState(() {
//         policyNumberController.text = data['policy_no'];
//       });
//       // await getPolicyDetails(data['policy_no']);

//       setState(() {
//         if (widget.isView) {
//           onChanged = null;
//           onChanged2 = null;
//           view = true;
//         }
//         instruments = instrumentData;
//         instrumentAmounts = [];
//         instrumentNumbers = [];
//         for (var i = 0; i < instrumentData.length; i++) {
//           instrumentAmounts.add(TextEditingController(
//               text: instrumentData[i]['instrumentAmount']));
//           instrumentNumbers.add(TextEditingController(
//               text: instrumentData[i]['instrumentNumber']));
//         }
//         proposedDate = data['proposer_signed_date'] ?? '';
//         _coInsurance = data['co_insurance'] == 'Y' ? "Yes" : "No";
//         _PPHC = data['pphc'] == 'Y' ? "Yes" : "No";
//         customerType =
//             data['customer_type'] == 'Other' || data['customer_type'] == 'other'
//                 ? 'Other than Individual'
//                 : data['customer_type'] == 'Individual' ||
//                         data['customer_type'] == 'individual'
//                     ? 'Individual'
//                     : null;
//         leadType = data['leader_follower_type'];
//         portalPolicyNumberController.text = data2["portal_policy_no"] ?? '';
//         policyIssueDate = data2["portal_policy_issue_date"] ?? '';
//         _modeOfSubmission1 = 'online';
//         _inwardType = 'endorsement';
//         discrepancyReasonController.text = data['reject_reason'] ?? '';
//       });
//       print(data['additional_proposal_details']);
//       print(' payment link ${data3['paymentRequestFlag']}');
//       setState(() {
//         paymentLink = data3['paymentRequestFlag'];
//         totalPremiumPaidController.text = data3['totalPremiumAmount'] != null
//             ? data3['totalPremiumAmount'].toString()
//             : '0';
//         pendingPremiumAmountController.text = data3['pendingAmount'] != null
//             ? data3['pendingAmount'].toString()
//             : '0';
//       });
//       print('came here');
//       print('payment link is here ${paymentLink}');

//       setState(() {
//         policyNumberController.text = data['policy_no'] ?? '';
//         quoteNumberController.text = data['quote_no'] ?? '';
//         customerNameController.text = data['customer_name'] ?? '';

//         agreementCodeController.text = data['agreement_code'] ?? '';
//         productController.text = data['product'] ?? '';
//         // mobileNumberController.text = data4['customer_mobile_number'] ?? '';
//         // customerEmailController.text = data4['customer_email_id'] ?? '';
//         mobileNumberController.text = data4['customer_mobile_number'] == null
//             ? ""
//             : data4['customer_mobile_number'].length == 12
//                 ? 'XXX-XXX-' + data4['customer_mobile_number'].substring(8)
//                 : 'XXX-XXX-' + data4['customer_mobile_number'].substring(6);
//         customerEmailController.text = data4['customer_email_id'] == null
//             ? ''
//             : data4['customer_email_id'].substring(0, 4) +
//                 '********' +
//                 data4['customer_email_id'].substring(11);
//         // mobileNumberController.text = data['CUSTOMER_MOBILENUMBER'] == null
//         //     ? "1234567890"
//         //     : data['CUSTOMER_MOBILENUMBER'].length == 12
//         //         ? 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(8)
//         //         : 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(6);
//         // customerEmailController.text = data['CUSTOMER_EMAILID'] == null
//         //     ? 'Test@sbigeneral.in'
//         //     : data['CUSTOMER_EMAILID'].substring(0, 4) +
//         //         '********' +
//         //         data['CUSTOMER_EMAILID'].substring(11);

//         secondarySalesNameController.text = data4['sm_name'] ?? '';
//         secondarySalesCodeController.text = data4['sm_code'] ?? '';

//         intermediaryNameController.text = data4['intermediary_name'] ?? '';
//         intermediaryCodeController.text = data4['intermediary_code'] ?? '';
//         sbiBranchController.text = data['sbigi_branch'] ?? '';
//         premiumAmountController.text = data['premium_amount'] == null
//             ? ''
//             : data['premium_amount'].toString();
//       });
//       setState(() {
//         customerEmailId = data4['customer_email_id'];
//         customerMobile = data4['customer_mobile_number'];
//       });
//       print('came here too');
//       setState(() {
//         viewPolicy = true;
//         viewDetails = true;

//         print('policy  $verifyPolicy');
//       });
//       print('ckyc avail ${data4['ckyc_avail']}');
//       if (data4['ckyc_avail'] == true) {
//         setState(() {
//           ckycDetails = true;
//           ckycNameController.text = data5['response_ckyc_customer_name'] ?? '';
//           ckycTypeController.text = data5['customer_type'] == 'individual'
//               ? 'Individual'
//               : data5['customer_type'] == 'other'
//                   ? 'Other than Individual'
//                   : '';
//           ckycDateController.text = data5['response_ckyc_dob'];
//           ckycNumberController.text = data5['response_ckyc_num'];
//         });
//       }

//       if (_inwardType == 'endorsement') {
//         print('calling');
//         await checkEndorsementType(data['product']);
//         await getEndorsementDetails(data['id']);
//       }

//       await getProposalProductDetail(data['product']);

//       setState(() {
//         isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: const Text("Technical Error!"),
//           action: SnackBarAction(
//             label: ' Cancel',
//             onPressed: () {},
//           )));
//       print(error);
//     }
//   }

//   getEndorsementDetails(proposalID) async {
//     setState(() {
//       isLoading = true;
//     });
//     print(proposalID);
//     final appState = Provider.of<AppState>(context, listen: false);

//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       Map<String, dynamic> postData = {"proposal_id": proposalID};

//       String result = aesCbcEncryptJson(jsonEncode(postData));
//       Map<String, dynamic> encryptedData = {'encryptedData': result};
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/allEndorsementDetails',
//           options: Options(headers: headers),
//           data: encryptedData);
//       // var data = jsonDecode(response.data)['endorsementDetails'];
//       String decryptedData1 = aesCbcDecryptJson((response.data));
//       print('decrypt');
//       print(decryptedData1);
//       // String decryptedData2 =
//       //     aesCbcDecryptJson(response.data['instruments'], key, base64iv);

//       var data = jsonDecode(decryptedData1)['endorsementDetails'];
//       print('emaill ${data['email']}');
//       // var jsonMap2 = jsonDecode(decryptedData2);

//       // var data = const JsonDecoder().convert(jsonMap1);
//       // var instrumentData = List.from(const JsonDecoder().convert(jsonMap2));
//       await checkEndorsementType(productController.text);
//       if (paymentLink == true &&
//           data["premium_payment_mode"] == 'Online' &&
//           data["premium_to_be_collected"] != '0' &&
//           data['form_type'] == 'Financial Endorsement') {
//         setState(() {
//           paymentButton = true;
//           view = true;
//         });
//       }
//       await getEndorsementType(data['form_type']);
//       if (data['form_type'] != 'Cancellation & Refund') {
//         setState(() {
//           retrivedNewValue = data['new_value'];
//         });
//         await getEndorsementSubType(
//             data['endorsement_type'], data['form_type']);
//         await getEndorsementFields(data['sub_type'], data['form_type']);
//       }
//       await getVersion();
//       print(data["remark"]);

//       setState(() {
//         selectedEndorsementRequestType = data['form_type'];
//         selectedEndorsementType = data['endorsement_type'];
//         selectedEndorsementSubType = data['sub_type'];
//         requesterRemarkController.text = data["remark"] ?? '';
//         salesEmailController.text = data["email"] ?? '';
//         salesMobileController.text = data["mobile"] ?? '';
//         selectedPaymentMode = data["payment_mode"];
//         selectedRefundReason = data["refund_reason"];
//         selectedRefundType = data["refund_type"];
//         refundAmountController.text = data["refund_amount"] ?? '';
//         accountHolderNameController.text = data["refund_holder_name"] ?? '';
//         ifscController.text = data["refund_IFSC"] ?? '';
//         accountNumberController.text = data["refund_account_no"] ?? '';
//         accountTypeController.text = data["refund_account_type"] ?? '';

//         requestReceivedDate = data["req_receive_date"];
//         premiumCollectedController.text = data["premium_to_be_collected"];

//         referenceNumberController.text =
//             data["premium_reference_number"] ?? data["reference_no"] ?? '';
//         sbigAccountNumberController.text =
//             data["premium_SBIG_account_number"] ??
//                 data["sbig_account_no"] ??
//                 '';
//         amountController.text = data["premium_amount"] ?? '';
//         selectedPaymentMode =
//             data["premium_payment_mode"] ?? data["payment_mode"];
//         transactionDate =
//             data["premium_transaction_date"] ?? data["transaction_date"];

//         requesterRemarkController.text = data['remark'] ?? '';
//       });
//       print('premium collected ${data["premium_to_be_collected"]}');

//       print(" view again: ${widget.isView}");

//       print('payment buttonnnnn $paymentButton ');
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _addInstrument() {
//     if (instruments.length == 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cannot add more than 5 instruments')),
//       );
//       return;
//     }
//     if (_validateInstruments()) {
//       setState(() {
//         instruments.add({
//           'instrumentType': null,
//           'instrumentNumber': '',
//           'instrumentAmount': '',
//           'instrumentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//         instrumentAmounts.add(TextEditingController());
//         instrumentNumbers.add(TextEditingController());
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 'Please fill out all fields of current instrument before adding a new instrument.')),
//       );
//     }
//   }

//   bool _validateInstruments() {
//     for (var i = 0; i < instruments.length; i++) {
//       if (instruments[i]['instrumentType'] == null ||
//           instrumentAmounts[i].text == '' ||
//           instrumentNumbers[i].text == '' ||
//           instruments[i]['instrumentDate'] == null) {
//         return false;
//       }
//     }
//     return true;
//   }

//   void _removeInstrument(int index) {
//     setState(() {
//       instruments.removeAt(index);
//       instrumentAmounts.removeAt(index);
//       instrumentNumbers.removeAt(index);
//     });
//   }

//   Widget _buildInstrumentDetails(int index) {
//     var instrument = instruments[index];
//     var instrumentNumber = instrumentNumbers[index];
//     var instrumentAmount = instrumentAmounts[index];
//     return Column(
//       children: [
//         // heightGap(),
//         CustomInputContainer(
//           children: [
//             Style.notRequiredFieldLabel("Instrument Details:", 16),
//             Stack(
//               children: [
//                 Style.wrap(
//                   context,
//                   children: [
//                     DropdownWidget(
//                       view: view,
//                       label: 'Instrument Type',
//                       items: list,
//                       value: instrument['instrumentType'],
//                       onChanged: (val) {
//                         setState(() {
//                           instrument['instrumentType'] = val;
//                         });
//                       },
//                     ),
//                     CustomInputField(
//                       maxLines: 1,
//                       view: view,
//                       maxLength: 12,
//                       title: 'Instrument Number',
//                       controller: instrumentNumber,
//                       // onChanged: (val) {
//                       //   setState(() {
//                       //     instrumentNumber.text = val;
//                       //   });
//                       // },
//                       // mandatoryFields: checkInstrumentNo,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please Enter the Instrument Number';
//                         } else if (int.parse(value) == 0) {
//                           return 'Instrument Number cannot be zero';
//                         }
//                         return null;
//                       },
//                     ),
//                     CustomInputField(
//                       maxLines: 1,
//                       view: view,
//                       maxLength: 9,
//                       title: 'Instrument Amount',

//                       controller: instrumentAmount,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       // onChanged: (val) {
//                       //   setState(() {
//                       //     instrumentAmount.text = val;
//                       //   });
//                       // },
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please Enter the Instrument Amount';
//                         } else if (int.parse(value) == 0) {
//                           return 'Instrument amount cannot be zero';
//                         }
//                         return null;
//                       },
//                       // mandatoryFields: mandatoryFields,
//                     ),
//                     DatePickerFormField(
//                       disabled: view,
//                       labelText: 'Select Date',
//                       onChanged: (DateTime? value) {
//                         setState(() {
//                           instrument['instrumentDate'] =
//                               DateFormat('yyyy-MM-dd')
//                                   .format(value as DateTime);
//                         });
//                       },
//                       date: instrument['instrumentDate'],
//                       // mandatoryField: mandatoryFields,
//                     ),
//                   ],
//                 ),
//                 widget.isView == false && index > 0
//                     ? Positioned(
//                         right: 20,
//                         // bottom: -2,
//                         child: Container(
//                           padding: const EdgeInsets.all(1),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color.fromARGB(255, 196, 52, 42),
//                           ),
//                           child: IconButton(
//                               onPressed: () => _removeInstrument(index),
//                               icon: const Icon(Icons.delete_forever_rounded,
//                                   size: 18, color: Colors.white)),
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//                 widget.isView == false && index == 0
//                     ? Positioned(
//                         right: 20,
//                         child: Container(
//                           padding: const EdgeInsets.all(1),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color.fromRGBO(143, 19, 168, 1),
//                           ),
//                           child: IconButton(
//                               onPressed: () {
//                                 _addInstrument();
//                               },
//                               icon: const Icon(Icons.add,
//                                   size: 16, color: Colors.white)),
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // getProposalProductList() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   final appState = Provider.of<AppState>(context, listen: false);
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json; charset=UTF-8',
//   //     "Accept": "application/json",
//   //     "Authorization": appState.accessToken
//   //   };
//   //   try {
//   //     final response = await dio.get(
//   //         'https://uatcld.sbigeneral.in/SecureApp/inwardProducts',
//   //         options: Options(headers: headers));
//   //     var data = jsonDecode(response.data);

//   //     setState(() {
//   //       products = List.from(data);
//   //     });
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     print(e);
//   //     print('not received');
//   //   }
//   // }

//   getProposalProductDetail(product) async {
//     setState(() {
//       isLoading = true;
//     });

//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, dynamic> postData = {"productName": product};
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/inwardProducts/productDetails',
//           data: postData,
//           options: Options(headers: headers));
//       var data = jsonDecode(response.data);
//       setState(() {
//         productType = data['product_type'];
//       });
//       setState(() {
//         isLoading = false;
//       });
//       print(data);
//     } catch (e) {
//       print(e);
//       setState(() {
//         isLoading = false;
//       });
//       print('not received');
//     }
//   }

//   checkEndorsementType(product) async {
//     setState(() {
//       isLoading = true;
//     });

//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, dynamic> postData = {"productName": product};
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/check-product',
//           data: postData,
//           options: Options(headers: headers));
//       var data = jsonDecode(response.data);
//       print(data);
//       setState(() {
//         requestType = data["requestorTypeAvailable"].toString();
//         // salesEmailController.text = appState.email ?? '';
//       });
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('not received');
//     }
//   }

//   getEndorsementProductList() async {
//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       final response = await dio.get(
//           'https://uatcld.sbigeneral.in/SecureApp/endorsementProducts',
//           options: Options(headers: headers));
//       var data2 = jsonDecode(response.data);
//       setState(() {
//         products = List.from(data2);
//       });
//     } catch (e) {
//       print('not received');
//     }
//   }

//   // getEndorsementProductDetail() async {
//   //   SharedPreferences prefs = await _prefs;
//   //   var token = prefs.getString('token') ?? '';
//   //   Map<String, dynamic> postData = {"productName": productController.text};
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json; charset=UTF-8',
//   //     "Accept": "application/json",
//   //     "Authorization": appState.accessToken
//   //   };
//   //   try {
//   //     final response = await dio.post(
//   //         'https://uatcld.sbigeneral.in/SecureApp/endorsementProducts/productDetails',
//   //         data: postData,
//   //         options: Options(headers: headers));
//   //     var data = jsonDecode(response.data);
//   //     print(data);
//   //   } catch (e) {
//   //     print(e);
//   //     print('not received');
//   //   }
//   // }

//   getEndorsementType(requestType) async {
//     setState(() {
//       isLoading = true;
//     });

//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, dynamic> postData = {
//       "productName": productController.text,
//       "requestorType": requestType
//     };
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/endorsementDetails/endorsementType',
//           data: postData,
//           options: Options(headers: headers));
//       var data = jsonDecode(response.data);
//       print('print here');
//       print(data['refundReason']);
//       print(requestType);
//       setState(() {
//         endorsementType = List.from(data['endtType']);
//         // paymentMode = List.from(data['paymentMode']);
//         refundType = List.from(data['refundType']);
//         if (requestType == 'Cancellation & Refund') {
//           refundReason = List.from(data['refundReason']);
//         }

//         if (requestType == 'Financial Endorsement' &&
//             widget.isEdit == false &&
//             widget.isView == false) {
//           setState(() {
//             premiumCollectedController.text = '0';
//           });
//         }
//       });
//       setState(() {
//         isLoading = false;
//       });
//       print(data);
//       print("refund reasons ${refundReason}");
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print(e);
//       print('not received');
//     }
//   }

//   getEndorsementSubType(endorsementType, endorsementRequestType) async {
//     setState(() {
//       isLoading = true;
//     });

//     Map<String, dynamic> postData = {
//       "productName": productController.text,
//       "endtType": endorsementType,
//       "requestorType": endorsementRequestType
//     };
//     print(postData);
//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/endorsementDetails/endorsementSubType',
//           data: postData,
//           options: Options(headers: headers));
//       var data = jsonDecode(response.data);
//       setState(() {
//         endorsementSubType = List.from(data);
//       });
//       setState(() {
//         isLoading = false;
//       });
//       print(data);
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print(e);
//       print('not received');
//     }
//   }

//   getPolicyDetails(policyNo) async {
//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, dynamic> postData = {
//       "source": "simba",
//       "policyNumber": policyNo
//     };
//     print('hello');
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SECUREAPI/getPremiumAmount',
//           data: policyNo);
//       print("Sameer");
//       print(response);

//       var data = jsonDecode(response.data);
//       print(data);

//       if (appState.imdCode != null) {
//         if (appState.imdCode.toString() ==
//             data['intermediary_CODE'].toString()) {
//           setState(() {
//             codeMapped = true;
//           });
//         } else {
//           setState(() {
//             codeMapped = false;
//           });
//         }
//       } else if (appState.employee_code != null) {
//         if (appState.employee_code.toString() ==
//             data['AGREEMENT_CODE'].toString()) {
//           setState(() {
//             codeMapped = true;
//           });
//         } else {
//           setState(() {
//             codeMapped = false;
//           });
//         }
//       }

//       print("code mapped : $codeMapped");
//       if (codeMapped == true) {
//         setState(() {
//           quoteNumberController.text = data['QUOTE_NO'] ?? '';
//           customerNameController.text = data['CUSTOMER_NAME'] ?? '';
//           productController.text = data['PRODUCT_NAME'] ?? '';
//           agreementCodeController.text = data['AGREEMENT_CODE'] ?? '';
//           productController.text = data['PRODUCT_NAME'] ?? '';

//           mobileNumberController.text = data['CUSTOMER_MOBILENUMBER'] == null
//               ? ""
//               : data['CUSTOMER_MOBILENUMBER'].length == 12
//                   ? 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(8)
//                   : 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(6);
//           customerEmailController.text = data['CUSTOMER_EMAILID'] == null
//               ? ''
//               : data['CUSTOMER_EMAILID'].substring(0, 4) +
//                   '********' +
//                   data['CUSTOMER_EMAILID'].substring(11);

//           secondarySalesNameController.text =
//               data['secondary_SALES_MANAGER_NAME'] ?? '';
//           secondarySalesCodeController.text =
//               data['secondary_SALES_MANAGER_CODE'] ?? '';
//           salesEmailController.text = data["sales_MANAGER_EMAIL"] ?? '';
//           salesMobileController.text = data['MOBILE_NUMBER'] ?? '';
//           // agreementCodeController.text = data['AGREEMENT_CODE'] ?? '';
//           intermediaryNameController.text = data['INTERMEDIARY_NAME'] ?? '';
//           intermediaryCodeController.text = data['intermediary_CODE'] ?? '';
//           sbiBranchController.text = data['sbi_BRANCH'] ?? '';
//           premiumAmountController.text = data['PREMIUM_AMOUNT_SUM'] ?? '';
//           // productType = data[0]['lob'] ?? '';
//         });
//         setState(() {
//           customerEmailId = data['CUSTOMER_EMAILID'];
//           customerMobile = data['CUSTOMER_MOBILENUMBER'].length == 12
//               ? data['CUSTOMER_MOBILENUMBER'].substring(3)
//               : data['CUSTOMER_MOBILENUMBER'];
//         });

//         if (data['CKYCID'] != null) {
//           List dateArr = data['CKYC_DATE_OF_BIRTH'].split('-');
//           dateArr[1] = dateArr[1][0] + dateArr[1].substring(1).toLowerCase();
//           String date = dateArr.join('-');

//           print('date here : ${data['CKYC_DATE_OF_BIRTH']}');

//           print('date new : $date');
//           DateTime oldDate = DateFormat("dd-MMM-yyyy").parse(date);
//           DateFormat newDate = DateFormat('yyyy-MM-dd');
//           String kycDate = newDate.format(oldDate);
//           setState(() {
//             ckycDetails = true;
//             ckycNameController.text = (data['CKYC_PREFIX'] ?? '') +
//                 " " +
//                 data['CKYC_FIRST_NAME'] +
//                 " " +
//                 (data['CKYC_MIDDLE_NAME'] ?? '') +
//                 " " +
//                 (data['CKYC_LAST_NAME'] ?? '');
//             ckycTypeController.text = data['EBAO_CUSTOMER_TYPE'] == 'IND'
//                 ? 'Individual'
//                 : 'Other than Individual';
//             ckycDateController.text = kycDate;

//             ckycNumberController.text = data['CKYCID'];
//           });
//           // setState(() {
//           //   verifyPolicy = true;
//           // });
//         }

//         setState(() {
//           viewPolicy = true;
//           isLoading = false;
//           viewDetails = true;
//           verifyPolicy = true;

//           print('policy  $verifyPolicy');
//         });
//         print('policy details $verifyPolicy');
//         print("producttt" + data['PRODUCT_NAME']);
//         await getProposalProductDetail(data['PRODUCT_NAME']);
//         await checkEndorsementType(data['PRODUCT_NAME']);
//         // setState(() {
//         //   codeMapped = true;
//         // });
//       } else {
//         // setState(() {
//         //   codeMapped = true;
//         // });
//         checkPolicyWithCode(policyNo);
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print(e);
//       setState(() {
//         isLoading = false;
//       });
//       setState(() {
//         verifyPolicy = false;
//         viewPolicy = false;
//       });
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 'Policy No.$policyNo not found!',
//                 style: const TextStyle(fontSize: 15, color: Colors.black),
//               ),
//               content: Text(
//                 "No details found against Policy No.$policyNo. Please enter correct policy number.",
//                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('Ok'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           });
//     }
//   }
//   // getPolicyDetails(policyNo) async {
//   //   final appState = Provider.of<AppState>(context, listen: false);
//   //   Map<String, dynamic> postData = {
//   //     'source': 'simba',
//   //     "policyNumber": policyNo
//   //   };
//   //   print('hello');

//   //   String encryptedData = aesGcmEncryptJson(jsonEncode(postData));
//   //   print('encrypted $encryptedData');

//   //   try {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     final response = await dio.post(
//   //         'https://uatcld.sbigeneral.in/SECUREAPI/getPolicyDetails',
//   //         data: postData);
//   //     print("Sameer");
//   //     print(response);
//   //     var decryptedData = aesGcmDecryptJson(encryptedData);
//   //     print('decrypted $decryptedData');
//   //     var data = jsonDecode(decryptedData);
//   //     print(data);

//   //     // var data = jsonDecode(response.data);
//   //     // print(data);

//   //     if (appState.imdCode != null) {
//   //       if (appState.imdCode.toString() ==
//   //           data['intermediary_CODE'].toString()) {
//   //         setState(() {
//   //           codeMapped = true;
//   //         });
//   //       } else {
//   //         setState(() {
//   //           codeMapped = false;
//   //         });
//   //       }
//   //     } else if (appState.employee_code != null) {
//   //       if (appState.employee_code.toString() ==
//   //           data['AGREEMENT_CODE'].toString()) {
//   //         setState(() {
//   //           codeMapped = true;
//   //         });
//   //       } else {
//   //         setState(() {
//   //           codeMapped = false;
//   //         });
//   //       }
//   //     }

//   //     print("code mapped : $codeMapped");
//   //     if (codeMapped == true) {
//   //       setState(() {
//   //         quoteNumberController.text = data['QUOTE_NO'] ?? '';
//   //         customerNameController.text = data['CUSTOMER_NAME'] ?? '';
//   //         productController.text = data['PRODUCT_NAME'] ?? '';
//   //         agreementCodeController.text = data['AGREEMENT_CODE'] ?? '';
//   //         productController.text = data['PRODUCT_NAME'] ?? '';

//   //         mobileNumberController.text = data['CUSTOMER_MOBILENUMBER'] == null
//   //             ? ""
//   //             : data['CUSTOMER_MOBILENUMBER'].length == 12
//   //                 ? 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(8)
//   //                 : 'XXX-XXX-' + data['CUSTOMER_MOBILENUMBER'].substring(6);
//   //         customerEmailController.text = data['CUSTOMER_EMAILID'] == null
//   //             ? ''
//   //             : data['CUSTOMER_EMAILID'].substring(0, 4) +
//   //                 '********' +
//   //                 data['CUSTOMER_EMAILID'].substring(11);

//   //         secondarySalesNameController.text =
//   //             data['secondary_SALES_MANAGER_NAME'] ?? '';
//   //         secondarySalesCodeController.text =
//   //             data['secondary_SALES_MANAGER_CODE'] ?? '';
//   //         salesEmailController.text = data["sales_MANAGER_EMAIL"] ?? '';
//   //         salesMobileController.text = data['MOBILE_NUMBER'] ?? '';
//   //         // agreementCodeController.text = data['AGREEMENT_CODE'] ?? '';
//   //         intermediaryNameController.text = data['INTERMEDIARY_NAME'] ?? '';
//   //         intermediaryCodeController.text = data['intermediary_CODE'] ?? '';
//   //         sbiBranchController.text = data['sbi_BRANCH'] ?? '';
//   //         premiumAmountController.text = data['PREMIUM_AMOUNT_SUM'] ?? '';
//   //         // productType = data[0]['lob'] ?? '';
//   //       });
//   //       setState(() {
//   //         customerEmailId = data['CUSTOMER_EMAILID'];
//   //         customerMobile = data['CUSTOMER_MOBILENUMBER'].length == 12
//   //             ? data['CUSTOMER_MOBILENUMBER'].substring(3)
//   //             : data['CUSTOMER_MOBILENUMBER'];
//   //       });

//   //       if (data['CKYCID'] != null) {
//   //         List dateArr = data['CKYC_DATE_OF_BIRTH'].split('-');
//   //         dateArr[1] = dateArr[1][0] + dateArr[1].substring(1).toLowerCase();
//   //         String date = dateArr.join('-');

//   //         print('date here : ${data['CKYC_DATE_OF_BIRTH']}');

//   //         print('date new : $date');
//   //         DateTime oldDate = DateFormat("dd-MMM-yyyy").parse(date);
//   //         DateFormat newDate = DateFormat('yyyy-MM-dd');
//   //         String kycDate = newDate.format(oldDate);
//   //         setState(() {
//   //           ckycDetails = true;
//   //           ckycNameController.text = (data['CKYC_PREFIX'] ?? '') +
//   //               " " +
//   //               data['CKYC_FIRST_NAME'] +
//   //               " " +
//   //               (data['CKYC_MIDDLE_NAME'] ?? '') +
//   //               " " +
//   //               (data['CKYC_LAST_NAME'] ?? '');
//   //           ckycTypeController.text = data['EBAO_CUSTOMER_TYPE'] == 'IND'
//   //               ? 'Individual'
//   //               : 'Other than Individual';
//   //           ckycDateController.text = kycDate;

//   //           ckycNumberController.text = data['CKYCID'];
//   //         });
//   //         // setState(() {
//   //         //   verifyPolicy = true;
//   //         // });
//   //       }

//   //       setState(() {
//   //         viewPolicy = true;
//   //         isLoading = false;
//   //         viewDetails = true;
//   //         verifyPolicy = true;

//   //         print('policy  $verifyPolicy');
//   //       });
//   //       print('policy details $verifyPolicy');
//   //       print("producttt" + data['PRODUCT_NAME']);
//   //       await getProposalProductDetail(data['PRODUCT_NAME']);
//   //       await checkEndorsementType(data['PRODUCT_NAME']);
//   //       // setState(() {
//   //       //   codeMapped = true;
//   //       // });
//   //     } else {
//   //       // setState(() {
//   //       //   codeMapped = true;
//   //       // });
//   //       checkPolicyWithCode(policyNo);
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     setState(() {
//   //       verifyPolicy = false;
//   //       viewPolicy = false;
//   //     });
//   //     return showDialog<void>(
//   //         context: context,
//   //         builder: (BuildContext context) {
//   //           return AlertDialog(
//   //             title: Text(
//   //               'Policy No.$policyNo not found!',
//   //               style: const TextStyle(fontSize: 15, color: Colors.black),
//   //             ),
//   //             content: Text(
//   //               "No details found against Policy No.$policyNo. Please enter correct policy number.",
//   //               style: const TextStyle(fontSize: 12, color: Colors.black54),
//   //             ),
//   //             actions: <Widget>[
//   //               TextButton(
//   //                 child: const Text('Ok'),
//   //                 onPressed: () {
//   //                   Navigator.of(context).pop();
//   //                 },
//   //               ),
//   //             ],
//   //           );
//   //         });
//   //   }
//   // }

//   sendPaymentLink(name, number, email) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final appState = Provider.of<AppState>(context, listen: false);
//       Map<String, String> headers = {"Authorization": appState.accessToken};
//       Map<String, dynamic> postData = {
//         "proposal_id": widget.proposalId,
//         "customerName": name,
//         "customerEmail": email,
//         "customerMobileNo": number,
//         "amount":
//             double.parse(premiumCollectedController.text).toStringAsFixed(2),
//       };

//       var encryptedData = aesCbcEncryptJson(jsonEncode(postData));
//       Map<String, dynamic> encryptedRazorPayData = {
//         'encryptedData': encryptedData
//       };
//       print('data $postData');
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/payment/razorpay',
//           data: encryptedRazorPayData,
//           options: Options(headers: headers));
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //     content: const Text(
//       //         "A payment link has been sent to your registered number. Please process the payment to complete your endorsement request."),
//       //     action: SnackBarAction(
//       //       label: ' Cancel',
//       //       onPressed: () {},
//       //     )));
//       var data = jsonDecode(response.data);
//       print(data['message']);

//       setState(() {
//         isLoading = false;
//       });
//       showDialog<void>(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text(
//                 'Payment Link Sent',
//                 style: TextStyle(fontSize: 15, color: Colors.black),
//               ),
//               content: const Text(
//                 "A payment link has been sent to mobile number and Email ID. Please process the payment to complete your endorsement request.",
//                 style: TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('Ok'),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const InwardStatus2()));
//                   },
//                 ),
//               ],
//             );
//           });
//       setState(() {
//         isLoading = false;
//       });
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       print(err);
//     }
//   }
//   // getAgreementCodeList(code) async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });

//   //   final appState = Provider.of<AppState>(context, listen: false);
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json; charset=UTF-8',
//   //     "Accept": "application/json",
//   //     "Authorization": appState.accessToken
//   //   };
//   //   try {
//   //     final response = await dio.get(
//   //         'https://uatcld.sbigeneral.in/SecureApp/agreement-codes',
//   //         options: Options(headers: headers));
//   //     List data = jsonDecode(response.data);
//   //     print(data);
//   //     if (data.contains(code)) {
//   //       setState(() {
//   //         codeMapped = true;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         codeMapped = false;
//   //       });
//   //     }

//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() {
//   //       codeMapped = false;
//   //     });
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   }
//   // }

//   void resetVariables() {
//     if (widget.isEdit == false) {
//       setState(() {
//         instruments = [
//           {
//             'instrumentType': null,
//             'instrumentNumber': '',
//             'instrumentAmount': '',
//             'instrumentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//           }
//         ];
//         instrumentAmounts = [TextEditingController()];
//         instrumentNumbers = [TextEditingController()];
//         customerNameController = TextEditingController();
//         previousPolicyController = TextEditingController();
//         premiumAmountController = TextEditingController();
//         selectedCode = null;
//         agreementCodeController = TextEditingController();
//         _modeOfSubmission1 = 'Digital';
//         instrumentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         proposedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         _coInsurance = 'No';
//         _PPHC = 'No';
//         customerType = null;
//         leadType = null;
//         productController = TextEditingController();
//         selectedProposal = null;
//         selectedSPCode = null;
//         selectedBranch = null;
//         selectedSBIGBranch = null;
//         selectedInstrumentType = null;
//         selectedEndorsementRequestType = null;
//         selectedEndorsementType = null;
//         selectedEndorsementSubType = null;
//         salesEmailController = TextEditingController();
//         salesMobileController = TextEditingController();
//         policyNumberController = TextEditingController();
//         quoteNumberController = TextEditingController();
//         portalPolicyNumberController = TextEditingController();
//         premiumCollectedController = TextEditingController();
//         referenceNumberController = TextEditingController();
//         sbigAccountNumberController = TextEditingController();
//         paymentModeController = TextEditingController();
//         amountController = TextEditingController();
//         accountHolderNameController = TextEditingController();
//         accountNumberController = TextEditingController();
//         ifscController = TextEditingController();
//         accountTypeController = TextEditingController();
//         refundAmountController = TextEditingController();
//         customerAccountController = TextEditingController();
//         requesterRemarkController = TextEditingController();
//         oldValueController = TextEditingController();
//         policyIssueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         requestReceivedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         selectedPaymentMode = null;
//         selectedRefundReason = null;
//         selectedRefundType = null;
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (selectedPaymentMode == 'Cheque') {
//         if (_formKey2.currentState!.validate() == false) {
//           return;
//         }
//       }
//       if (verifyPolicy == false &&
//           widget.isEdit == false &&
//           widget.isView == false) {
//         Style.showAlertDialog(context, "Please verify Policy Number!");
//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         //     content: const Text("Please verify Policy Number!"),
//         //     action: SnackBarAction(
//         //       label: ' Cancel',
//         //       onPressed: () {},
//         //     )));
//         return;
//       }
//       if (customerType == null && ckycDetails == false) {
//         if (customerTypeRejectionList.contains(productController.text) ==
//             true) {
//           widget.isEdit || propProposalId != null
//               ? editProposal()
//               : uploadProposal(context);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: const Text("Please select customer type"),
//               action: SnackBarAction(
//                 label: ' Cancel',
//                 onPressed: () {},
//               )));
//         }
//       } else {
//         customerType == 'Individual'
//             ? widget.isEdit || propProposalId != null
//                 ? editProposal()
//                 : uploadProposal(context)
//             : widget.isEdit || propProposalId != null
//                 ? editProposal()
//                 : uploadProposal(context);
//       }
//     } else {
//       Style.showAlertDialog(context, 'Please enter all the mandatory fields.');
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //     content: const Text("Please fill all the mandatory fields!"),
//       //     action: SnackBarAction(
//       //       label: ' Cancel',
//       //       onPressed: () {},
//       //     )));
//     }
//   }

//   uploadProposal(context) async {
//     print("uploaded proposal");
//     print(propProposalId);
//     List finalInstruments = [];
//     var i = 0;
//     if (selectedEndorsementRequestType == 'Financial Endorsement' &&
//         selectedPaymentMode == 'Cheque') {
//       finalInstruments = instruments.map((e) {
//         var instrumentAmount = instrumentAmounts[i];
//         var instrumentNumber = instrumentNumbers[i];
//         i = i + 1;
//         return {
//           "instrumentType": e['instrumentType'],
//           "instrumentAmount": instrumentAmount.text,
//           "instrumentNumber": instrumentNumber.text,
//           "instrumentDate": e['instrumentDate']
//         };
//       }).toList();
//     }

//     Map inwardData = {
//       "is_bulk": 0,
//       "final_submitted": 0,
//       "inward_type": _inwardType.toLowerCase(),
//       "submission_mode": 'online',
//       "product": productController.text,
//       "agreement_code": agreementCodeController.text.isEmpty
//           ? null
//           : agreementCodeController.text,
//       "branch":
//           sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//       "sbigi_branch":
//           sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//       "customer_name": customerNameController.text.isEmpty
//           ? null
//           : customerNameController.text,
//       "premium_amount": premiumAmountController.text.isEmpty
//           ? null
//           : premiumAmountController.text,
//       "quote_no": quoteNumberController.text.isEmpty
//           ? null
//           : quoteNumberController.text,
//       "co_insurance": _coInsurance == 'Yes' ? "Y" : "N",
//       "leader_follower_type": leadType,
//       "endt_lead_type": leadType?.toLowerCase(),
//       "pphc": _PPHC == 'Yes' ? "Y" : "N",
//       "proposer_signed_date": proposedDate,
//       'prev_policy_num': previousPolicyController.text,
//       "customer_type": ckycDetails == true
//           ? ckycTypeController.text.toLowerCase()
//           : customerType == "Individual"
//               ? 'individual'
//               : customerType == "Other than Individual"
//                   ? 'other'
//                   : null,
//       "additionalDetails": {
//         "transaction_branch": '',
//         "customer_mobile_number": customerMobile,
//         "customer_email_id": customerEmailId,
//         "sm_code": secondarySalesCodeController.text,
//         "sm_name": secondarySalesNameController.text,
//         "intermediary_code": intermediaryCodeController.text,
//         "intermediary_name": intermediaryNameController.text,
//         "ckyc_avail": ckycDetails == true ? '1' : '0',
//       },
//       "instruments": finalInstruments
//     };

//     Map financialDetails = {
//       "premium_to_be_collected": premiumCollectedController.text,
//       "premium_reference_number": referenceNumberController.text,
//       "premium_SBIG_account_number": sbigAccountNumberController.text,
//       "premium_amount": premiumCollectedController.text,
//       "premium_payment_mode": selectedPaymentMode,
//       "premium_transaction_date": transactionDate,
//     };
//     Map refundDetails = {
//       "reference_no": referenceNumberController.text,
//       "transaction_date": transactionDate,
//       "sbig_account_no": sbigAccountNumberController.text,
//       "payment_mode": selectedPaymentMode,
//       "refund_amount": refundAmountController.text,
//       "refund_reason": selectedRefundReason,
//       "refund_type": selectedRefundType,
//       "refund_holder_name": accountHolderNameController.text,
//       "refund_IFSC": ifscController.text,
//       "refund_account_no": accountNumberController.text,
//       "refund_account_type": accountTypeController.text,
//     };
//     Map details = {};
//     if (selectedEndorsementRequestType == 'Financial Endorsement') {
//       details = financialDetails;
//     } else if (selectedEndorsementRequestType == 'Cancellation & Refund') {
//       details = refundDetails;
//     }

//     Map endorsementData2 = {
//       "product": productController.text,
//       "proposalDetails": {
//         "is_bulk": 0,
//         "final_submitted": 0,
//         "inward_type": "endorsement",
//         "submission_mode": 'online',
//         "product": productController.text,
//         "agreement_code": agreementCodeController.text.isEmpty
//             ? null
//             : agreementCodeController.text,
//         "branch":
//             sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//         "sbigi_branch":
//             sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//         "customer_name": customerNameController.text.isEmpty
//             ? null
//             : customerNameController.text,
//         "co_insurance": _coInsurance == 'Yes' ? "Y" : "N",
//         "leader_follower_type": leadType,
//         "endt_lead_type": leadType?.toLowerCase(),
//         "pphc": _PPHC == 'Yes' ? "Y" : "N",
//         "premium_amount": premiumAmountController.text.isEmpty
//             ? null
//             : premiumAmountController.text,
//         "proposer_signed_date": proposedDate,
//         "policy_no": policyNumberController.text,
//         "quote_no": quoteNumberController.text.isEmpty
//             ? null
//             : quoteNumberController.text,
//         "policy_issue_date": policyIssueDate,
//         "customer_type": ckycDetails == true
//             ? ckycTypeController.text.toLowerCase()
//             : customerType == "Individual"
//                 ? 'individual'
//                 : customerType == "Other than Individual"
//                     ? 'other'
//                     : null,
//         "instruments": finalInstruments
//       },
//       "endorsementDetails": {
//         ...{
//           "form_type": selectedEndorsementRequestType ==
//                   'Basic Information Endorsement'
//               ? 'basic'
//               : selectedEndorsementRequestType == 'Financial Endorsement'
//                   ? 'financial'
//                   : selectedEndorsementRequestType == 'Cancellation & Refund'
//                       ? 'refund'
//                       : null,
//           "sub_type": selectedEndorsementSubType,
//           "endt_sub_type": selectedEndorsementSubType,
//           "product": productController.text,
//           "endorsement_type": selectedEndorsementType,
//           "email": salesEmailController.text.isEmpty
//               ? null
//               : salesEmailController.text,
//           "mobile": salesMobileController.text.isEmpty
//               ? null
//               : salesMobileController.text,
//           "branch_name": sbiBranchController.text.isEmpty
//               ? null
//               : sbiBranchController.text,
//           "payment_mode": selectedPaymentMode,
//           "policy_number": policyNumberController.text,
//           "remark": requesterRemarkController.text,
//           "req_receive_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
//           "account_no": selectedEndorsementRequestType ==
//                       'Basic Information Endorsement' &&
//                   productController.text == "SBI Simple PA (PAI)"
//               ? accountNumberController.text
//               : null,
//           // "journal_no": productController.text == "SBI Simple PA (PAI)"
//           //     ? journalNumberController.text
//           //     : null,
//           // "old_value": oldValueController.text,
//         },
//         ...details,
//         ...endorsementData!['endorsement'],
//       },
//       "additionalDetails": {
//         "transaction_branch": '',
//         "customer_mobile_number": customerMobile,
//         "customer_email_id": customerEmailId,
//         "sm_code": secondarySalesCodeController.text,
//         "sm_name": secondarySalesNameController.text,
//         "intermediary_code": intermediaryCodeController.text,
//         "intermediary_name": intermediaryNameController.text,
//         "ckyc_avail": ckycDetails == true ? '1' : '0',
//       }
//     };
//     // print(inwardData);
//     print(endorsementData);
//     print(endorsementData2);

//     String resultEndorsement = aesCbcEncryptJson(jsonEncode(endorsementData2));
//     String resultProposal = aesCbcEncryptJson(jsonEncode(inwardData));

//     Map<String, dynamic> encryptedEndorsementData = {
//       'encryptedData': resultEndorsement
//     };
//     Map<String, dynamic> encryptedProposalData = {
//       'encryptedData': resultProposal
//     };
//     print(encryptedProposalData);
//     final appState = Provider.of<AppState>(context, listen: false);
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };
//     String sendDetails = 'proposalDetails';
//     if (_inwardType == 'endorsement') {
//       sendDetails = 'endorsementDetails';
//     }
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/$sendDetails',
//           data: _inwardType == 'endorsement' && requestType == 'true'
//               ? encryptedEndorsementData
//               : encryptedProposalData,
//           options: Options(headers: headers));
//       print(response.data);
//       String decryptedData = aesCbcDecryptJson(response.data);

//       var data = jsonDecode(decryptedData);
//       // var data = const JsonDecoder().convert(jsonMap);

//       // final Map<String, dynamic> data = jsonDecode(response.data);

//       final appState = Provider.of<AppState>(context, listen: false);
//       appState.updateVariables(
//         proposalId: data['proposal']['id'],
//       );
//       if ((customerTypeRejectionList.contains(productController.text) ==
//           true)) {
//         customerType = null;
//       }
//       if (ckycDetails == true) {
//         await editCkyc(data['proposal']['id']);
//       }

//       // if (_formKey.currentState!.validate()) {
//       setState(() {
//         propProposalId = data['proposal']['id'];
//       });
//       print(propProposalId);
//       if (customerType == null &&
//           (customerTypeRejectionList.contains(productController.text) ==
//               true)) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ProposalDocuments(
//                       inwardData: _inwardType == 'endorsement'
//                           ? endorsementData2
//                           : inwardData,
//                       inwardType: _inwardType,
//                       ckycData: null,
//                       ckycDocuments: null,
//                       isEdit: widget.isEdit,
//                     )));
//       } else if (ckycDetails == true) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ProposalDocuments(
//                       inwardData: _inwardType == 'endorsement'
//                           ? endorsementData2
//                           : inwardData,
//                       inwardType: _inwardType,
//                       ckycData: null,
//                       ckycDocuments: null,
//                       isEdit: widget.isEdit,
//                     )));
//       } else {
//         if (ckycDetails == false) {
//           customerType == 'Individual'
//               ? Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => KYCIndividual(
//                             inwardData: _inwardType == 'endorsement'
//                                 ? endorsementData2
//                                 : inwardData,
//                             inwardType: _inwardType,
//                             isEdit: widget.isEdit,
//                             onlinePay: selectedPaymentMode == 'Online',
//                             premiumAmount: premiumCollectedController.text,
//                             customerName: customerNameController.text,
//                             customerEmail: customerEmailId,
//                             customerMobile: customerMobile,
//                             // edit: false,
//                           )))
//               : Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => KYCOther(
//                             inwardData: _inwardType == 'endorsement'
//                                 ? endorsementData2
//                                 : inwardData,
//                             inwardType: _inwardType,
//                             isEdit: widget.isEdit,
//                             onlinePay: selectedPaymentMode == 'Online',

//                             premiumAmount: premiumCollectedController.text,
//                             customerName: customerNameController.text,
//                             customerEmail: customerEmailId,
//                             customerMobile: customerMobile,
//                             // edit: false,
//                           )));
//         }
//       }
//       // } else {
//       //   Style.showAlertDialog(
//       //       context, 'Please enter all the mandartory fields.');
//       //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //   //     content: const Text("Please fill all the mandatory fields!"),
//       //   //     action: SnackBarAction(
//       //   //       label: ' Cancel',
//       //   //       onPressed: () {},
//       //   //     )));
//       // }
//     } catch (e) {
//       print(e);
//     }
//   }

//   editProposal() async {
//     print("edit proposal");
//     List finalInstruments = [];
//     var i = 0;
//     final appState = Provider.of<AppState>(context, listen: false);
//     var proposalId = appState.proposalId;
//     if (selectedEndorsementRequestType == 'Financial Endorsement' &&
//         selectedPaymentMode == 'Cheque') {
//       finalInstruments = instruments.map((e) {
//         var instrumentAmount = instrumentAmounts[i];
//         var instrumentNumber = instrumentNumbers[i];
//         i = i + 1;
//         return {
//           "instrumentType": e['instrumentType'],
//           "instrumentAmount": instrumentAmount.text,
//           "instrumentNumber": instrumentNumber.text,
//           "instrumentDate": e['instrumentDate']
//         };
//       }).toList();
//     }
//     Map inwardData = {
//       "is_bulk": 0,
//       "final_submitted": 0,
//       "proposal_id": proposalId,
//       "inward_type": 'endorsement',
//       "submission_mode": 'online',
//       "product": productController.text,
//       "agreement_code": agreementCodeController.text.isEmpty
//           ? null
//           : agreementCodeController.text,
//       "branch":
//           sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//       "sbigi_branch":
//           sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//       "customer_name": customerNameController.text.isEmpty
//           ? null
//           : customerNameController.text,
//       "premium_amount": premiumAmountController.text.isEmpty
//           ? null
//           : premiumAmountController.text,
//       "quote_no": quoteNumberController.text.isEmpty
//           ? null
//           : quoteNumberController.text,
//       "co_insurance": _coInsurance == 'Yes' ? "Y" : "N",
//       "leader_follower_type": leadType,
//       "endt_lead_type": leadType?.toLowerCase(),
//       "pphc": _PPHC == 'Yes' ? "Y" : "N",
//       "proposer_signed_date": proposedDate,
//       "customer_type": ckycDetails == true
//           ? ckycTypeController.text.toLowerCase()
//           : customerType == "Individual"
//               ? 'individual'
//               : customerType == "Other than Individual"
//                   ? 'other'
//                   : null,
//       "additionalDetails": {
//         "transaction_branch": '',
//         "customer_mobile_number": customerMobile,
//         "customer_email_id": customerEmailId,
//         "sm_code": secondarySalesCodeController.text,
//         "sm_name": secondarySalesNameController.text,
//         "intermediary_code": intermediaryCodeController.text,
//         "intermediary_name": intermediaryNameController.text,
//         "ckyc_avail": ckycDetails == true ? '1' : '0',
//       },
//       "instruments": finalInstruments
//     };
//     Map financialDetails = {
//       "premium_to_be_collected": premiumCollectedController.text,
//       "premium_reference_number": referenceNumberController.text,
//       "premium_SBIG_account_number": sbigAccountNumberController.text,
//       "premium_amount": premiumCollectedController.text,
//       "premium_payment_mode": selectedPaymentMode,
//       "premium_transaction_date": transactionDate,
//     };
//     Map refundDetails = {
//       "reference_no": referenceNumberController.text,
//       "transaction_date": transactionDate,
//       "sbig_account_no": sbigAccountNumberController.text,
//       "payment_mode": selectedPaymentMode,
//       "refund_amount": refundAmountController.text,
//       "refund_reason": selectedRefundReason,
//       "refund_type": selectedRefundType,
//       "refund_holder_name": accountHolderNameController.text,
//       "refund_IFSC": ifscController.text,
//       "refund_account_no": accountNumberController.text,
//       "refund_account_type": accountTypeController.text,
//     };
//     Map details = {};
//     if (selectedEndorsementRequestType == 'Financial Endorsement') {
//       details = financialDetails;
//     } else if (selectedEndorsementRequestType == 'Cancellation & Refund') {
//       details = refundDetails;
//     }
//     Map endorsementData2 = {
//       "product": productController.text,
//       "proposal_id": proposalId,
//       "proposalDetails": {
//         "is_bulk": 0,
//         "final_submitted": 0,
//         "inward_type": "endorsement",
//         "submission_mode": 'online',
//         "product": productController.text,
//         "agreement_code": agreementCodeController.text.isEmpty
//             ? null
//             : agreementCodeController.text,
//         "branch":
//             sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//         "sbigi_branch":
//             sbiBranchController.text.isEmpty ? null : sbiBranchController.text,
//         "customer_name": customerNameController.text.isEmpty
//             ? null
//             : customerNameController.text,
//         "premium_amount": premiumAmountController.text.isEmpty
//             ? null
//             : premiumAmountController.text,
//         "quote_no": quoteNumberController.text.isEmpty
//             ? null
//             : quoteNumberController.text,
//         "co_insurance": _coInsurance == 'Yes' ? "Y" : "N",
//         "leader_follower_type": leadType,
//         "endt_lead_type": leadType?.toLowerCase(),
//         "pphc": _PPHC == 'Yes' ? "Y" : "N",
//         "policy_no": policyNumberController.text,
//         "proposer_signed_date": proposedDate,
//         "customer_type": ckycDetails == true
//             ? ckycTypeController.text.toLowerCase()
//             : customerType == "Individual"
//                 ? 'individual'
//                 : customerType == "Other than Individual"
//                     ? 'other'
//                     : null,
//         "ckyc_avail": ckycDetails == true ? '1' : '0',
//         "discrepancy_resolve_remark": widget.formStatus == 'discrepancy'
//             ? discrepancyResolveRemarkController.text
//             : null,
//         "discrepancy_resolve_flag":
//             widget.formStatus == 'discrepancy' && isResolved == true
//                 ? '1'
//                 : widget.formStatus == 'discrepancy' && isResolved == false
//                     ? '0'
//                     : null,
//         "instruments": finalInstruments
//       },
//       "endorsementDetails": {
//         ...endorsementData!['endorsement'],
//         ...{
//           "form_type": selectedEndorsementRequestType ==
//                   'Basic Information Endorsement'
//               ? 'basic'
//               : selectedEndorsementRequestType == 'Financial Endorsement'
//                   ? 'financial'
//                   : selectedEndorsementRequestType == 'Cancellation & Refund'
//                       ? 'refund'
//                       : null,
//           "sub_type": selectedEndorsementSubType,
//           "endt_sub_type": selectedEndorsementSubType,
//           "product": productController.text,
//           "endorsement_type": selectedEndorsementType,
//           "email": salesEmailController.text.isEmpty
//               ? null
//               : salesEmailController.text,
//           "mobile": salesMobileController.text.isEmpty
//               ? null
//               : salesMobileController.text,
//           "branch_name": sbiBranchController.text.isEmpty
//               ? null
//               : sbiBranchController.text,
//           "payment_mode": selectedPaymentMode,
//           "policy_number": policyNumberController.text,
//           "remark": requesterRemarkController.text,
//           "req_receive_date": requestReceivedDate,
//           "account_no": selectedEndorsementRequestType ==
//                       'Basic Information Endorsement' &&
//                   productController.text == "SBI Simple PA (PAI)"
//               ? accountNumberController.text
//               : null,
//           // "journal_no": productController.text == "SBI Simple PA (PAI)"
//           //     ? journalNumberController.text
//           //     : null,
//           // "old_value": oldValueController.text,
//         },
//         ...details,
//       },
//       "additionalDetails": {
//         "transaction_branch": '',
//         "customer_mobile_number": customerMobile,
//         "customer_email_id": customerEmailId,
//         "sm_code": secondarySalesCodeController.text,
//         "sm_name": secondarySalesNameController.text,
//         "intermediary_code": intermediaryCodeController.text,
//         "intermediary_name": intermediaryNameController.text,
//         "ckyc_avail": ckycDetails == true ? '1' : '0',
//       },
//     };

//     print('editing');
//     print(inwardData);
//     print(endorsementData);
//     print(endorsementData2);

//     String resultEndorsement = aesCbcEncryptJson(
//       jsonEncode({'proposal_id': proposalId, ...endorsementData2}),
//     );
//     String resultProposal = aesCbcEncryptJson(
//         jsonEncode({'proposal_id': proposalId, ...inwardData}));

//     Map<String, dynamic> encryptedEndorsementData = {
//       'encryptedData': resultEndorsement
//     };
//     Map<String, dynamic> encryptedProposalData = {
//       'encryptedData': resultProposal
//     };
//     setState(() {
//       isLoading = true;
//     });

//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Accept": "application/json",
//       "Authorization": appState.accessToken
//     };

//     String sendDetails = 'proposalDetails/update';
//     if (_inwardType == 'endorsement') {
//       sendDetails = 'updateEndorsementDetails';
//     }
//     try {
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/$sendDetails',
//           data: _inwardType == 'endorsement' && requestType == 'true'
//               ? encryptedEndorsementData
//               : encryptedProposalData,
//           options: Options(headers: headers));
//       print(response);
//       String decryptedData = aesCbcDecryptJson(response.data);
//       print(decryptedData);
//       var data = jsonDecode(decryptedData);
//       // var data = const JsonDecoder().convert(jsonMap);

//       // final Map<String, dynamic> data = jsonDecode(response.data);

//       if (data['proposal']['ckyc_exist'] == 'Y') {
//         edit = true;
//       } else if (data['proposal']['ckyc_exist'] == null) {
//         edit = false;
//       }
//       if ((customerTypeRejectionList.contains(productController.text) ==
//           true)) {
//         customerType = null;
//       }
//       setState(() {
//         if (customerType == null &&
//             (customerTypeRejectionList.contains(productController.text) ==
//                 true)) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ProposalDocuments(
//                         inwardData: _inwardType == 'endorsement'
//                             ? endorsementData2
//                             : inwardData,
//                         inwardType: _inwardType,
//                         ckycData: null,
//                         ckycDocuments: null,
//                         isEdit: widget.isEdit,
//                       )));
//         } else if (ckycDetails == true) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ProposalDocuments(
//                         inwardData: _inwardType == 'endorsement'
//                             ? endorsementData2
//                             : inwardData,
//                         inwardType: _inwardType,
//                         ckycData: null,
//                         ckycDocuments: null,
//                         isEdit: widget.isEdit,
//                       )));
//         } else {
//           if (ckycDetails == false) {
//             customerType == 'Individual'
//                 ? Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => KYCIndividual(
//                               inwardData: _inwardType == 'endorsement'
//                                   ? endorsementData2
//                                   : inwardData,
//                               inwardType: _inwardType,
//                               isEdit: widget.isEdit,
//                               onlinePay: selectedPaymentMode == 'Online',
//                               premiumAmount: premiumCollectedController.text,
//                               customerName: customerNameController.text,
//                               customerEmail: customerEmailId,
//                               customerMobile: customerMobile,
//                               // edit: customerType == appState.typeOfCustomer
//                               //     ? true
//                               //     : false,
//                             )))
//                 : Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => KYCOther(
//                               inwardData: _inwardType == 'endorsement'
//                                   ? endorsementData2
//                                   : inwardData,
//                               inwardType: _inwardType,
//                               isEdit: widget.isEdit,
//                               onlinePay: selectedPaymentMode == 'Online',
//                               premiumAmount: premiumCollectedController.text,
//                               customerName: customerNameController.text,
//                               customerEmail: customerEmailId,
//                               customerMobile: customerMobile,
//                               // edit: customerType == appState.typeOfCustomer
//                               //     ? true
//                               //     : false,
//                             )));
//           }
//         }
//         setState(() {
//           propProposalId = data['proposal']['id'];
//         });
//       });
//       setState(() {
//         isLoading = false;
//       });
//     } on DioException catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       print(error);
//       print(error.message);

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: const Text("Form not submitted. Try again!"),
//           action: SnackBarAction(
//             label: ' Cancel',
//             onPressed: () {},
//           )));
//     }
//   }

//   _viewForm() {
//     print('customer type: $customerType');
//     print('ckycDetails: $ckycDetails');
//     var viewInwardData = {"product": productController.text};
//     if ((customerTypeRejectionList.contains(productController.text) == true)) {
//       customerType = null;
//     }
//     if (ckycDetails == true) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ProposalDocuments(
//                     inwardData: viewInwardData,
//                     inwardType: _inwardType,
//                     ckycData: null,
//                     ckycDocuments: null,
//                     isView: true,
//                   )));
//     } else {
//       customerType == 'Individual'
//           ? Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => KYCIndividual(
//                         inwardData: viewInwardData,
//                         inwardType: _inwardType,
//                         isView: true,
//                       )))
//           : customerType == 'Other than Individual'
//               ? Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => KYCOther(
//                             inwardData: viewInwardData,
//                             inwardType: _inwardType,
//                             isView: true,
//                           )))
//               : Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProposalDocuments(
//                             inwardData: viewInwardData,
//                             inwardType: _inwardType,
//                             ckycData: null,
//                             ckycDocuments: null,
//                             isView: true,
//                           )));
//     }
//   }

//   editCkyc(proposalID) async {
//     var kycData = {
//       "ckyc_exist": 'Y',
//       "ckyc_num": ckycNumberController.text,
//       "customer_type": ckycTypeController.text.toLowerCase(),
//       "response_ckyc_num": ckycNumberController.text,
//       "response_ckyc_dob": ckycDateController.text,
//       "response_ckyc_customer_name": ckycNameController.text,
//     };
//     print('editedd');
//     setState(() {
//       isLoading = true;
//     });
//     print(kycData);

//     try {
//       final appState = Provider.of<AppState>(context, listen: false);
//       print(appState.proposalId);

//       String result = aesCbcEncryptJson(
//         jsonEncode({"proposal_detail_id": proposalID, ...kycData}),
//       );

//       Map<String, dynamic> encryptedCkycData = {'encryptedData': result};

//       Map<String, String> headers = {
//         'Content-Type': 'application/json; charset=UTF-8',
//         "Accept": "application/json",
//         "Authorization": appState.accessToken
//       };
//       final response = await dio.post(
//           'https://uatcld.sbigeneral.in/SecureApp/updateCkycDetails',
//           data: encryptedCkycData,
//           options: Options(headers: headers));
//       setState(() {
//         isLoading = false;
//       });

//       // if (ckycNumberController != null) {
//       //   if (paymentMode == 'Online' && paymentLink == null) {
//       //     // await sendPaymentLink(kycData);
//       //   } else {
//       //     setState(() {
//       //       isLoading = false;
//       //     });
//       //   }
//       // } else {
//       //   print(response.data);
//       //   setState(() {
//       //     isLoading = false;
//       //   });
//       // }
//     } catch (err) {
//       print(err);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     agreementCodeController.dispose();
//     super.dispose();
//   }

//   getEndorsementValues(Map endorsementDetails) {
//     Map<String, dynamic> combinedMap = {
//       ...endorsementData!['endorsement'],
//       ...endorsementDetails
//     };
//     print(combinedMap);
//     setState(() {
//       endorsementData!['endorsement'] = combinedMap;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final appState = Provider.of<AppState>(context, listen: false);
//     return Stack(
//       children: [
//         Scaffold(
//           appBar: NavBar.appBar(),
//           body: Stack(
//             children: [
//               Style.background(context),
//               SingleChildScrollView(
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         NavBar.header(
//                           context,
//                           "Dashboard",
//                           () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const InwardStatus2()),
//                             );
//                           },
//                         ),
//                         Style.formContainer(
//                             context,
//                             widget.isView || widget.isEdit
//                                 ? 'Inward No : ${widget.proposalId}'
//                                 : 'Create Endorsement:',
//                             [
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CustomInputContainer(children: [
//                                         heightGap(),
//                                         policyNumber(),
//                                         // Style.wrap(context, children: [
//                                         //   policyNumber(),
//                                         // ]),

//                                         Style.notRequiredFieldLabel(
//                                             'Policy Details :', 14),
//                                         // heightGap(),
//                                         Style.wrap(
//                                           context,
//                                           children: [
//                                             quoteNumber(),
//                                             customerName(),
//                                             customerMobileNumber(),
//                                             customerEmail(),
//                                             product(),
//                                             smName(),
//                                             smCode(),
//                                             smEmail(),
//                                             smMobile(),
//                                             // transactionBranch(),
//                                             sbigBranch(),
//                                             agreementCode(),
//                                             intermediaryName(),
//                                             intermediaryCode(),
//                                             premiumAmount2(),
//                                             selectedEndorsementRequestType ==
//                                                         'Financial Endorsement' &&
//                                                     (widget.isEdit ||
//                                                         widget.isView)
//                                                 ? totalPremiumPaid()
//                                                 : const SizedBox.shrink(),
//                                             selectedEndorsementRequestType ==
//                                                         'Financial Endorsement' &&
//                                                     (widget.isEdit ||
//                                                         widget.isView)
//                                                 ? pendingPremiumAmount()
//                                                 : const SizedBox.shrink()
//                                           ],
//                                         ),
//                                         heightGap(),
//                                         ckycDetails
//                                             ? Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Style.notRequiredFieldLabel(
//                                                       'Ckyc Details :', 14),
//                                                   // heightGap(),
//                                                   Style.wrap(context,
//                                                       children: [
//                                                         ckycType(),
//                                                         ckycNumber(),
//                                                         ckycDob(),
//                                                         ckycName()
//                                                       ])
//                                                 ],
//                                               )
//                                             : Container(),
//                                       ]),
//                                       heightGap(),
//                                       if (_inwardType == 'endorsement' &&
//                                           requestType == 'true' &&
//                                           viewPolicy == true)
//                                         CustomInputContainer(children: [
//                                           heightGap(),
//                                           Style.wrap(
//                                             context,
//                                             children: [
//                                               endtRequestType(),
//                                               if (selectedEndorsementRequestType !=
//                                                       'Cancellation & Refund' &&
//                                                   selectedEndorsementRequestType !=
//                                                       null)
//                                                 Style.wrap(context, children: [
//                                                   endtType(),
//                                                   endtSubType(),
//                                                 ]),
//                                               if (selectedEndorsementRequestType ==
//                                                       'Cancellation & Refund' &&
//                                                   selectedEndorsementRequestType !=
//                                                       null)
//                                                 Style.wrap(
//                                                   context,
//                                                   children: [
//                                                     reasonForRefund(),
//                                                     typeOfRefund()
//                                                   ],
//                                                 ),
//                                               if (selectedEndorsementSubType !=
//                                                   null)
//                                                 dynamicForm,
//                                               if (selectedEndorsementRequestType ==
//                                                       'Cancellation & Refund' &&
//                                                   selectedEndorsementRequestType !=
//                                                       null)
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   children: [
//                                                     Style.notRequiredFieldLabel(
//                                                         'Refund to be Made to :',
//                                                         14),
//                                                     heightGap(),
//                                                     Style.wrap(
//                                                       context,
//                                                       children: [
//                                                         accountHolderName(),
//                                                         accountNumber(),
//                                                         ifscCode(),
//                                                         typeOfAccount(),
//                                                         refundAmount(),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               if (selectedEndorsementRequestType ==
//                                                       'Financial Endorsement' &&
//                                                   selectedEndorsementRequestType !=
//                                                       null)
//                                                 Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Style.notRequiredFieldLabel(
//                                                           'Premium Collection Details :',
//                                                           14),
//                                                       heightGap(),
//                                                       Style.wrap(context,
//                                                           children: [
//                                                             premiumToBeCollected(),
//                                                             referenceNumber(),
//                                                             dateOfTransaction(),
//                                                             sbiAccountNumber(),
//                                                             modeOfPayment(),
//                                                             // amount()
//                                                           ])
//                                                     ]),
//                                               requesterRemark(),
//                                             ],
//                                           ),
//                                           heightGap()
//                                         ]),
//                                       heightGap(),
//                                       CustomInputContainer(
//                                         children: [
//                                           heightGap(),
//                                           Style.wrap(
//                                             context,
//                                             children: [
//                                               // premiumAmount(),
//                                               proposerSignedDate(),
//                                               (customerTypeRejectionList.contains(
//                                                               productController
//                                                                   .text) ==
//                                                           false &&
//                                                       ckycDetails == false)
//                                                   ? typeOfCustomer()
//                                                   : const SizedBox.shrink(),

//                                               coInsurer(),
//                                               _coInsurance == 'Yes'
//                                                   ? typeOfLead()
//                                                   : const SizedBox(),
//                                               // productType == 'Health' ||
//                                               //         productType == 'health'
//                                               //     ? pphc()
//                                               //     : const SizedBox(),
//                                               // policyNumberController.text ==
//                                               //         '0000000101754031'
//                                               //     ? pphc()
//                                               //     :
//                                             ],
//                                           ),
//                                           widget.formStatus == 'discrepancy' &&
//                                                   paymentLink == false &&
//                                                   widget.isEdit
//                                               ? Style.wrap(context, children: [
//                                                   discrepancyReason(),
//                                                   discrepancyRemark(),
//                                                   Row(
//                                                     children: [
//                                                       Checkbox(
//                                                         checkColor:
//                                                             Colors.white,
//                                                         activeColor: const Color
//                                                             .fromRGBO(
//                                                             143, 19, 168, 1),
//                                                         // fillColor: MaterialStateProperty.all<Color>(
//                                                         //     const Color.fromRGBO(13, 154, 189, 1)),
//                                                         value: isResolved,
//                                                         onChanged:
//                                                             (bool? value) {
//                                                           setState(() {
//                                                             isResolved = value!;
//                                                           });
//                                                         },
//                                                       ),
//                                                       const SizedBox(width: 7),
//                                                       Style.notRequiredFieldLabel(
//                                                           'Discrepancy Resolved',
//                                                           13),
//                                                     ],
//                                                   )
//                                                 ])
//                                               : const SizedBox.shrink()
//                                         ],
//                                       ),
//                                       heightGap(),
//                                       if (selectedPaymentMode == "Cheque")
//                                         Form(
//                                             key: _formKey2,
//                                             child: Column(
//                                               children: instruments
//                                                   .asMap()
//                                                   .entries
//                                                   .map((entry) =>
//                                                       _buildInstrumentDetails(
//                                                           entry.key))
//                                                   .toList(),
//                                             )),
//                                       heightGap(),
//                                       heightGap(),
//                                       paymentButton == true
//                                           ? Style.formSubmitButton("Close", () {
//                                               print('done');
//                                               Navigator.pushReplacement(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           const InwardStatus2()));
//                                             })
//                                           : Style.formSubmitButton("Next", () {
//                                               print('done');
//                                               if (widget.isView) {
//                                                 _viewForm();
//                                               } else {
//                                                 _submitForm();
//                                               }
//                                             }),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               generateLink
//                   ? Positioned(
//                       top: 0,
//                       right: 0,
//                       left: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height,
//                         decoration:
//                             BoxDecoration(color: Colors.black.withOpacity(0.6)),
//                         child: Center(
//                           child: Container(
//                               width: MediaQuery.of(context).size.width * 0.6,
//                               height: MediaQuery.of(context).size.height * 0.75,
//                               // padding: const EdgeInsets.all(15),
//                               child: CustomInputContainer(
//                                 children: [
//                                   Wrap(
//                                     alignment: WrapAlignment.end,
//                                     children: [
//                                       TextButton(
//                                           onPressed: () {
//                                             // Navigator.pop(context);
//                                             setState(() {
//                                               generateLink = false;
//                                             });
//                                           },
//                                           child: Container(
//                                               padding: const EdgeInsets.all(6),
//                                               decoration: const BoxDecoration(
//                                                   color: Color.fromARGB(
//                                                       255, 190, 50, 40),
//                                                   shape: BoxShape.circle),
//                                               child: const Text(
//                                                 'X',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 16,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )))
//                                     ],
//                                   ),

//                                   SizedBox(
//                                     width: 250,
//                                     child: Wrap(
//                                       spacing: 25,
//                                       alignment: WrapAlignment.start,
//                                       crossAxisAlignment:
//                                           WrapCrossAlignment.center,
//                                       children: [
//                                         const SizedBox(
//                                           height: 15,
//                                         ),
//                                         Style.notRequiredFieldLabel(
//                                             'Send Payment Link to? ', 14),
//                                         radioButtonDesign('Customer'),
//                                         radioButtonDesign('Other'),
//                                       ],
//                                     ),
//                                   ),
//                                   // linkSentTo == null
//                                   //     ? const SizedBox(
//                                   //         height: 150,
//                                   //       )
//                                   //     : Container(),
//                                   SizedBox(
//                                     height: 350,
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         children: [
//                                           linkSentTo == 'Other'
//                                               ? Form(
//                                                   key: _formKey3,
//                                                   child: Column(
//                                                     children: [
//                                                       Style.wrap(
//                                                         context,
//                                                         children: [
//                                                           otherInputField(
//                                                               'Name',
//                                                               false,
//                                                               otherNameController),
//                                                           otherInputField(
//                                                               'Mobile Number',
//                                                               false,
//                                                               otherMobileNumberController),
//                                                           otherInputField(
//                                                               'Email',
//                                                               false,
//                                                               otherEmailController),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               : Container(),
//                                           linkSentTo == 'Customer'
//                                               ? Column(
//                                                   children: [
//                                                     heightGap(),
//                                                     heightGap()
//                                                   ],
//                                                 )
//                                               : Container(),
//                                           linkSentTo != null
//                                               ? Style.notRequiredFieldLabel(
//                                                   'Payer Details :', 14)
//                                               : Container(),
//                                           linkSentTo == 'Other'
//                                               ? Column(
//                                                   children: [
//                                                     ckycFetchedDetailsRow(
//                                                         'Name:',
//                                                         otherNameController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Mobile Number:',
//                                                         otherMobileNumberController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Email ID:',
//                                                         otherEmailController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Amout:',
//                                                         premiumCollectedController
//                                                             .text,
//                                                         true)
//                                                   ],
//                                                 )
//                                               : Container(),
//                                           linkSentTo == 'Customer'
//                                               ? Column(
//                                                   children: [
//                                                     heightGap(),
//                                                     ckycFetchedDetailsRow(
//                                                         'Customer Name:',
//                                                         customerNameController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Customer Mobile Number:',
//                                                         mobileNumberController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Customer Email ID:',
//                                                         customerEmailController
//                                                             .text,
//                                                         true),
//                                                     ckycFetchedDetailsRow(
//                                                         'Amout:',
//                                                         premiumCollectedController
//                                                             .text,
//                                                         true)
//                                                   ],
//                                                 )
//                                               : Container(),
//                                           heightGap(),
//                                           linkSentTo != null
//                                               ? Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Style.formSubmitButton(
//                                                         "Submit", () {
//                                                       if (linkSentTo ==
//                                                           'Other') {
//                                                         if (_formKey3
//                                                             .currentState!
//                                                             .validate()) {
//                                                           showDialog<void>(
//                                                               barrierDismissible:
//                                                                   false,
//                                                               context: context,
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                                 return AlertDialog(
//                                                                   title:
//                                                                       const Text(
//                                                                     'Confirmation!',
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             15,
//                                                                         color: Colors
//                                                                             .black),
//                                                                   ),
//                                                                   content:
//                                                                       const Text(
//                                                                     "Do you want to send Payment Link?",
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             12,
//                                                                         color: Colors
//                                                                             .black54),
//                                                                   ),
//                                                                   actions: <Widget>[
//                                                                     TextButton(
//                                                                       child: const Text(
//                                                                           'No'),
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                     ),
//                                                                     TextButton(
//                                                                       child: const Text(
//                                                                           'Yes'),
//                                                                       onPressed:
//                                                                           () {
//                                                                         sendPaymentLink(
//                                                                             otherNameController.text,
//                                                                             otherMobileNumberController.text,
//                                                                             otherEmailController.text);
//                                                                       },
//                                                                     ),
//                                                                   ],
//                                                                 );
//                                                               });
//                                                         }
//                                                       } else if (linkSentTo ==
//                                                           'Customer') {
//                                                         if (customerEmailId !=
//                                                                 null &&
//                                                             customerMobile !=
//                                                                 null) {
//                                                           showDialog<void>(
//                                                               barrierDismissible:
//                                                                   false,
//                                                               context: context,
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                                 return AlertDialog(
//                                                                   title:
//                                                                       const Text(
//                                                                     'Confirmation!',
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             15,
//                                                                         color: Colors
//                                                                             .black),
//                                                                   ),
//                                                                   content:
//                                                                       const Text(
//                                                                     "Do you want to send Payment Link?",
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             12,
//                                                                         color: Colors
//                                                                             .black54),
//                                                                   ),
//                                                                   actions: <Widget>[
//                                                                     TextButton(
//                                                                       child: const Text(
//                                                                           'No'),
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                     ),
//                                                                     TextButton(
//                                                                       child: const Text(
//                                                                           'Yes'),
//                                                                       onPressed:
//                                                                           () {
//                                                                         sendPaymentLink(
//                                                                             customerNameController.text,
//                                                                             customerMobile,
//                                                                             customerEmailId);
//                                                                       },
//                                                                     ),
//                                                                   ],
//                                                                 );
//                                                               });
//                                                         } else {
//                                                           Style.showAlertDialog(
//                                                               context,
//                                                               'Customer Email ID and Customer Number is not available. Please send payment link to Other!');
//                                                         }
//                                                       }
//                                                     }),
//                                                   ],
//                                                 )
//                                               : Container()
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//         isLoading
//             ? const LoadingPage(
//                 label: "Loading",
//               )
//             : const SizedBox.shrink()
//       ],
//     );
//   }

//   Widget otherInputField(
//       String label, bool readOnly, TextEditingController controller) {
//     return CustomInputField(
//       onChanged: (value) {
//         setState(() {});
//       },
//       maxLines: 1,
//       required: true,
//       view: readOnly,
//       controller: controller,
//       title: label,
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.@ ]")),
//       ],
//       validator: (value) {
//         if (label == 'Name') {
//           return Validators.nameValidation(value, label);
//         } else if (label == 'Mobile Number') {
//           return Validators.phoneNumberValidator(value);
//         } else if (label == 'Email') {
//           return Validators.emailValidator(value);
//         } else {
//           return Validators.formValidation(value, label);
//         }
//       },
//     );
//   }

//   Widget ckycFetchedDetailsRow(String label, String data, bool borderLine) {
//     return Container(
//       // height: 20,
//       width: MediaQuery.of(context).size.width * 0.6,
//       padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
//       decoration: BoxDecoration(
//           border: borderLine
//               ? const Border(
//                   bottom: BorderSide(
//                   color: Colors.black45,
//                   width: 1,
//                 ))
//               : null),
//       child: Wrap(
//         children: [
//           SizedBox(
//             width: 200,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           SizedBox(
//             width: 250,
//             child: Text(
//               data,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   radioButtonDesign(String value) {
//     return SizedBox(
//       width: 100,
//       child: Row(
//         children: [
//           Radio(
//               activeColor: const Color.fromRGBO(143, 19, 168, 1),
//               autofocus: false,
//               value: value,
//               groupValue: linkSentTo,
//               onChanged: (String? value) {
//                 setState(() {
//                   linkSentTo = value;
//                 });
//                 print(linkSentTo);
//                 // if (linkSentTo != value) {
//                 //   // linkSentTo = null;
//                 // }
//               }),
//           Text(value),
//         ],
//       ),
//     );
//   }

//   policyNumber() {
//     return Wrap(
//         spacing: 20,
//         alignment: WrapAlignment.start,
//         // runAlignment: WrapAlignment.start,
//         crossAxisAlignment: WrapCrossAlignment.center,
//         children: [
//           // SizedBox(
//           //   width: 700,
//           //   child:
//           CustomInputField(
//             required: required,
//             view: viewPolicy,
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-_]")),
//             ],
//             title: 'Policy Number',
//             controller: policyNumberController,
//             validator: (value) {
//               return Validators.policyNumberValidation(value, 'Policy Number');
//             },
//           ),
//           // verifyButton: widget.isView == false
//           //     ?
//           verifyButton
//               ? verifyPolicy
//                   ? SizedBox(
//                       width: 300,
//                       height: 20,
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 // SizedBox(
//                                 //   width: 15,
//                                 // ),
//                                 Text(
//                                   'Verified ',
//                                   style: TextStyle(
//                                       color: Colors.green, fontSize: 14),
//                                 ),
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green,
//                                   size: 16,
//                                 )
//                               ],
//                             ),
//                             TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     policyNumberController =
//                                         TextEditingController();
//                                     quoteNumberController =
//                                         TextEditingController();
//                                     customerNameController =
//                                         TextEditingController();
//                                     mobileNumberController =
//                                         TextEditingController();
//                                     customerEmailController =
//                                         TextEditingController();
//                                     productController = TextEditingController();
//                                     secondarySalesNameController =
//                                         TextEditingController();
//                                     secondarySalesCodeController =
//                                         TextEditingController();
//                                     salesEmailController =
//                                         TextEditingController();
//                                     salesMobileController =
//                                         TextEditingController();
//                                     sbiBranchController =
//                                         TextEditingController();
//                                     agreementCodeController =
//                                         TextEditingController();
//                                     intermediaryNameController =
//                                         TextEditingController();
//                                     intermediaryCodeController =
//                                         TextEditingController();
//                                     premiumAmountController =
//                                         TextEditingController();
//                                     verifyPolicy = false;
//                                     viewPolicy = false;
//                                     _coInsurance = "No";
//                                     instruments = [
//                                       {
//                                         'instrumentType': null,
//                                         'instrumentNumber': '',
//                                         'instrumentAmount': '',
//                                         'instrumentDate':
//                                             DateFormat('yyyy-MM-dd')
//                                                 .format(DateTime.now()),
//                                       }
//                                     ];
//                                     instrumentAmounts = [
//                                       TextEditingController()
//                                     ];
//                                     instrumentNumbers = [
//                                       TextEditingController()
//                                     ];
//                                     instrumentDate = DateFormat('yyyy-MM-dd')
//                                         .format(DateTime.now());
//                                     proposedDate = DateFormat('yyyy-MM-dd')
//                                         .format(DateTime.now());
//                                     selectedEndorsementRequestType = null;
//                                     selectedEndorsementType = null;
//                                     selectedEndorsementSubType = null;
//                                     dynamicForm = Container();
//                                     selectedPaymentMode = null;
//                                     paymentButton = false;
//                                     ckycDetails = false;
//                                     ckycNameController =
//                                         TextEditingController();
//                                     ckycNumberController =
//                                         TextEditingController();
//                                     ckycTypeController =
//                                         TextEditingController();
//                                     ckycDateController =
//                                         TextEditingController();
//                                     totalPremiumPaidController =
//                                         TextEditingController();
//                                     pendingPremiumAmountController =
//                                         TextEditingController();
//                                   });
//                                 },
//                                 child: const Text(
//                                   'Check other Policy!',
//                                   style: TextStyle(
//                                       color: Colors.blue, fontSize: 14),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     )
//                   : SizedBox(
//                       width: 300,
//                       height: 20,
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // SizedBox(
//                             //   width: 15,
//                             // ),
//                             TextButton(
//                                 onPressed: () {
//                                   if (policyNumberController.text != '') {
//                                     getPolicyDetails(
//                                         policyNumberController.text);
//                                   } else {
//                                     Style.showAlertDialog(
//                                         context, 'Please enter Policy Number!');
//                                   }
//                                 },
//                                 child: const Text(
//                                   'Verify Policy!',
//                                   style: TextStyle(
//                                       color: Colors.blue, fontSize: 14),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     )
//               : const SizedBox.shrink(),
//           paymentButton
//               ? TextButton(
//                   child: const Text('Generate Payment Link'),
//                   onPressed: () {
//                     // showPopUp();
//                     setState(() {
//                       generateLink = true;
//                     });
//                   })
//               : Container(),
//           // )
//         ]);
//   }

//   customerName() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Customer Name",
//       // inputFormatters: <TextInputFormatter>[
//       //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//       // ],
//       controller: customerNameController,
//     );
//   }

//   customerMobileNumber() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLength: 9,
//       maxLines: 1,
//       title: " Customer Mobile Number",
//       controller: mobileNumberController,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//     );
//   }

//   customerEmail() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Customer Email id",
//       controller: customerEmailController,
//     );
//   }

//   product() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Product",
//       controller: productController,
//     );
//   }

//   smName() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "SM Name",
//       controller: secondarySalesNameController,
//     );
//   }

//   smCode() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "SM Code",
//       controller: secondarySalesCodeController,
//     );
//   }

//   smEmail() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "SM Email Id",
//       controller: salesEmailController,
//     );
//   }

//   smMobile() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "SM Mobile Number",
//       controller: salesMobileController,
//     );
//   }

//   spCode() {
//     return CustomInputField(
//       view: view,
//       maxLines: 1,
//       title: "SP Code",
//       controller: spCodeController,
//     );
//   }

//   // transactionBranch() {
//   //   return CustomInputField(
//   //     view: viewDetails,
//   //     maxLines: 1,
//   //     title: "Transaction Branch",
//   //
//   //     inputFormatters: <TextInputFormatter>[
//   //       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//   //     ],
//   //     controller: sbiBranchController,
//   //   );
//   // }

//   sbigBranch() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "SBI Branch",
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       controller: sbiBranchController,
//     );
//   }

//   agreementCode() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Agreement Code",
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       controller: agreementCodeController,
//     );
//   }

//   intermediaryName() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Intermediary Name",
//       // inputFormatters: <TextInputFormatter>[
//       //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//       // ],
//       controller: intermediaryNameController,
//     );
//   }

//   intermediaryCode() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Intermediary Code",
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//       ],
//       controller: intermediaryCodeController,
//     );
//   }

//   premiumAmount2() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Premium Amount",
//       controller: premiumAmountController,
//     );
//   }

//   totalPremiumPaid() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Total Premium Paid",
//       controller: totalPremiumPaidController,
//     );
//   }

//   pendingPremiumAmount() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Pending Premium Amount",
//       controller: pendingPremiumAmountController,
//     );
//   }

//   quoteNumber() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Quote Number",
//       controller: quoteNumberController,
//     );
//   }

//   ckycType() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Customer Type",
//       controller: ckycTypeController,
//     );
//   }

//   ckycNumber() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "CKYC ID",
//       controller: ckycNumberController,
//     );
//   }

//   // ckycName() {
//   //   return CustomInputField(
//   //     view: viewDetails,
//   //     maxLines: 1,
//   //     title: "Quote Number",
//   //     controller: ckycNameController,
//   //   );
//   // }

//   ckycDob() {
//     return CustomInputField(
//       view: viewDetails,
//       maxLines: 1,
//       title: "Date of Birth",
//       controller: ckycDateController,
//     );
//   }

//   ckycName() {
//     return CustomInputField2(
//       view: viewDetails,
//       maxLines: 1,
//       title: 'Name',
//       controller: ckycNameController,
//     );
//   }

//   endtRequestType() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Endorsement Request Type',
//         items: endorsementRequestType,
//         value: selectedEndorsementRequestType,
//         onChanged: (val) {
//           setState(() {
//             selectedEndorsementRequestType = val;
//             if (requestType == 'true') {
//               getEndorsementType(val);
//             }
//             if (selectedEndorsementRequestType == 'Financial Endorsement') {
//               setState(() {
//                 premiumCollectedController.text = '0';
//               });
//             }

//             dynamicForm = const SizedBox.shrink();
//             selectedEndorsementType = null;
//             selectedEndorsementSubType = null;
//             // salesMobileController = TextEditingController();
//             portalPolicyNumberController = TextEditingController();
//             // premiumCollectedController = TextEditingController();
//             referenceNumberController = TextEditingController();
//             sbigAccountNumberController = TextEditingController();
//             paymentModeController = TextEditingController();
//             amountController = TextEditingController();
//             accountHolderNameController = TextEditingController();
//             accountNumberController = TextEditingController();
//             ifscController = TextEditingController();
//             accountTypeController = TextEditingController();
//             refundAmountController = TextEditingController();
//             customerAccountController = TextEditingController();
//             requesterRemarkController = TextEditingController();
//             oldValueController = TextEditingController();
//             policyIssueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//             transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//             requestReceivedDate =
//                 DateFormat('yyyy-MM-dd').format(DateTime.now());
//             selectedPaymentMode = null;
//             selectedRefundReason = null;
//             selectedRefundType = null;
//           });
//         });
//   }

//   endtType() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Endorsement Type',
//         items: endorsementType,
//         value: selectedEndorsementType,
//         onChanged: (val) {
//           setState(() {
//             selectedEndorsementType = val;
//             dynamicForm = const SizedBox.shrink();
//             selectedEndorsementSubType = null;
//             // premiumCollectedController = TextEditingController();
//             referenceNumberController = TextEditingController();
//             sbigAccountNumberController = TextEditingController();
//             paymentModeController = TextEditingController();
//             amountController = TextEditingController();
//             accountHolderNameController = TextEditingController();
//             accountNumberController = TextEditingController();
//             ifscController = TextEditingController();
//             accountTypeController = TextEditingController();
//             refundAmountController = TextEditingController();
//             customerAccountController = TextEditingController();

//             oldValueController = TextEditingController();
//             policyIssueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//             transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

//             selectedPaymentMode = null;
//             selectedRefundReason = null;
//             selectedRefundType = null;
//           });
//           getEndorsementSubType(
//               selectedEndorsementType, selectedEndorsementRequestType);
//         });
//   }

//   endtSubType() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Endorsement Sub-Type',
//         items: endorsementSubType,
//         value: selectedEndorsementSubType,
//         onChanged: (val) {
//           setState(() {
//             selectedEndorsementSubType = val;
//             dynamicForm = const SizedBox.shrink();
//             // premiumCollectedController = TextEditingController();
//             referenceNumberController = TextEditingController();
//             sbigAccountNumberController = TextEditingController();
//             paymentModeController = TextEditingController();
//             amountController = TextEditingController();
//             accountHolderNameController = TextEditingController();
//             accountNumberController = TextEditingController();
//             ifscController = TextEditingController();
//             accountTypeController = TextEditingController();
//             refundAmountController = TextEditingController();
//             customerAccountController = TextEditingController();
//             oldValueController = TextEditingController();
//             policyIssueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//             transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//             selectedPaymentMode = null;
//             selectedRefundReason = null;
//             selectedRefundType = null;
//           });
//           getEndorsementFields(
//               selectedEndorsementSubType, selectedEndorsementRequestType);
//         });
//   }

//   reasonForRefund() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Refund Reason',
//         items: refundReason,
//         value: selectedRefundReason,
//         onChanged: (val) {
//           setState(() {
//             selectedRefundReason = val;
//           });
//         });
//   }

//   typeOfRefund() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Refund Type',
//         items: refundType,
//         value: selectedRefundType,
//         onChanged: (val) {
//           setState(() {
//             selectedRefundType = val;
//           });
//         });
//   }

//   accountHolderName() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Account Holder Name',
//       controller: accountHolderNameController,
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//       ],
//       validator: (value) {
//         return Validators.nameValidation(value, 'Account Holder Name');
//       },
//     );
//   }

//   accountNumber() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Account Number',
//       controller: accountNumberController,
//       validator: (value) {
//         return Validators.formValidation(value, 'Account Number');
//       },
//     );
//   }

//   ifscCode() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'IFSC',
//       controller: ifscController,
//       validator: (value) {
//         return Validators.formValidation(
//           value,
//           'IFSC',
//         );
//       },
//     );
//   }

//   typeOfAccount() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Account Type',
//       controller: accountTypeController,
//       validator: (value) {
//         return Validators.formValidation(
//           value,
//           'Account Type',
//         );
//       },
//     );
//   }

//   refundAmount() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Refund Amount',
//       controller: refundAmountController,
//       validator: (value) {
//         return Validators.formValidation(value, 'Refund Amount');
//       },
//     );
//   }

//   premiumToBeCollected() {
//     return CustomInputField(
//       required: required,
//       maxLines: 1,
//       view: true,
//       title: 'Premium to be Collected',
//       controller: premiumCollectedController,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please Enter Premium to be Collected';
//         }
//         final alphanumericRegex = RegExp(r'^[a-zA-Z0-9-]+$');
//         if (!alphanumericRegex.hasMatch(value)) {
//           return 'Please Enter Premium to be Collected';
//         }

//         return null;
//       },
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//     );
//   }

//   referenceNumber() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Reference Number',
//       controller: referenceNumberController,
//       validator: (value) {
//         return Validators.formValidation(value, 'Reference Number');
//       },
//     );
//   }

//   dateOfTransaction() {
//     return DatePickerFormField(
//       required: required,
//       disabled: view,
//       labelText: 'Transaction Date',
//       onChanged: (DateTime? value) {
//         setState(() {
//           transactionDate = DateFormat('yyyy-MM-dd').format(value as DateTime);
//         });
//       },
//       date: transactionDate,
//     );
//   }

//   sbiAccountNumber() {
//     return CustomInputField(
//       view: view,
//       maxLines: 1,
//       title: 'SBIG Account Number',
//       controller: sbigAccountNumberController,
//     );
//   }

//   modeOfPayment() {
//     return DropdownWidget(
//         required: required,
//         view: view,
//         label: 'Payment Mode',
//         items: paymentMode,
//         value: selectedPaymentMode,
//         onChanged: (val) {
//           setState(() {
//             selectedPaymentMode = val;
//           });

//           instruments = [
//             {
//               'instrumentType': null,
//               'instrumentNumber': '',
//               'instrumentAmount': '',
//               'instrumentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//             }
//           ];
//           instrumentAmounts = [TextEditingController()];
//           instrumentNumbers = [TextEditingController()];
//           instrumentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         });
//   }

//   amount() {
//     return CustomInputField(
//       required: required,
//       view: view,
//       maxLines: 1,
//       title: 'Amount',
//       controller: amountController,
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//       validator: (value) {
//         return Validators.formValidation(value, 'Amount');
//       },
//     );
//   }

//   requesterRemark() {
//     return CustomInputField2(
//       required: required,
//       view: view,
//       maxLines: 4,
//       minLines: 1,
//       maxLength: 800,
//       title: 'Requester Remarks',
//       controller: requesterRemarkController,
//       validator: (value) {
//         return Validators.remarkValidation(value, 'Requester Remarks');
//       },
//     );
//   }

//   discrepancyRemark() {
//     return CustomInputField2(
//       required: false,
//       view: view,
//       maxLines: 4,
//       maxLength: 200,
//       minLines: 1,
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.allow(
//             RegExp(r'^[a-zA-Z0-9-\[\]\(\)_@. \s\S]+$')),
//       ],
//       title: 'Discrepancy Resolve Remark',
//       controller: discrepancyResolveRemarkController,
//     );
//   }

//   discrepancyReason() {
//     return CustomInputField2(
//       required: false,
//       view: true,
//       maxLines: 4,
//       maxLength: 200,
//       minLines: 1,
//       title: 'Discrepancy Reason',
//       controller: discrepancyReasonController,
//     );
//   }

//   premiumAmount() {
//     return CustomInputField(
//       view: view,
//       maxLength: 9,
//       maxLines: 1,
//       title: "Premium Amount",
//       controller: premiumAmountController,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'Please Enter the Premium Amount';
//         } else if (int.parse(value) == 0) {
//           return 'Premium amount cannot be zero';
//         }
//         for (var instrument in instrumentAmounts) {
//           if (instrument.text != '') {
//             if (int.parse(value) > int.parse(instrument.text)) {
//               return 'Premium Amount cannot be more than \nInstrument Amount';
//             }
//           }
//         }
//         return null;
//       },
//     );
//   }

//   proposerSignedDate() {
//     return DatePickerFormField(
//       required: required,
//       disabled: view,
//       labelText: 'Proposer Signed Date',
//       onChanged: (DateTime? value) {
//         setState(() {
//           proposedDate = DateFormat('yyyy-MM-dd').format(value as DateTime);
//         });
//         print('Selected date: $value');
//       },
//       date: proposedDate,
//     );
//   }

//   typeOfCustomer() {
//     return DropdownWidget(
//       required: required,
//       view: view,
//       label: 'Customer Type',
//       items: individualOther,
//       value: customerType,
//       onChanged: (dat) {
//         setState(() {
//           customerType = dat;
//         });
//       },
//     );
//   }

//   coInsurer() {
//     return DropdownWidget(
//       required: required,
//       view: view,
//       label: "Co-Insurance",
//       items: yesNo,
//       value: _coInsurance,
//       onChanged: (dat) {
//         if (dat != _coInsurance) {
//           setState(() {
//             leadType = null;
//           });
//         }
//         setState(() {
//           _coInsurance = dat;
//         });
//       },
//     );
//   }

//   // pphc() {
//   //   return DropdownWidget(
//   //     required: required,
//   //     view: view,
//   //     label: 'PPHC',
//   //     items: yesNo,
//   //     value: _PPHC,
//   //     onChanged: (dat) {
//   //       setState(() {
//   //         _PPHC = dat;
//   //       });
//   //     },
//   //   );
//   // }

//   typeOfLead() {
//     return DropdownWidget(
//       required: required,
//       view: view,
//       label: 'Lead Type',
//       items: leaderFollower,
//       value: leadType,
//       onChanged: (dat) {
//         setState(() {
//           leadType = dat;
//         });
//       },
//     );
//   }

//   checkPolicyWithCode(policyNo) {
//     final appState = Provider.of<AppState>(context, listen: false);
//     String? code;
//     String? label;
//     if (appState.imdCode != null) {
//       setState(() {
//         code = appState.imdCode.toString();
//         label = 'IMD Code';
//       });
//     } else if (appState.employee_code != null) {
//       setState(() {
//         code = appState.employee_code.toString();
//         label = 'RM Code';
//       });
//     }
//     return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               '$label $code not mapped!',
//               style: const TextStyle(fontSize: 15, color: Colors.black),
//             ),
//             content: Text(
//               "$label $code of Policy No.$policyNo is not mapped to the logged-in user. Please enter another policy number.",
//               style: const TextStyle(fontSize: 12, color: Colors.black54),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Ok'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }
