// ignore_for_file: unused_import, avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
import 'package:secure_app/Screens/dashboard.dart';
import 'package:secure_app/Screens/endorsementDocuments.dart';
import 'package:secure_app/Screens/endorsementForm.dart';
import 'package:secure_app/Screens/kycOther.dart';
import 'package:secure_app/Screens/unauthorized.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Screens/kycIndividual.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String employeeNo = '';
  var queryData;
  // bool isRootedOrJailBroken = false;
  // String? _result;
  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  checkAccess() {
    final url = Uri.base;
    final appState = Provider.of<AppState>(context, listen: false);
    String? encryptedData = url.queryParameters['data'];
    print(encryptedData);
    var data =
        jsonDecode(aesCbcDecryptJson(encryptedData!.replaceAll(' ', '+')));
    print(data);
    setState(() {
      queryData = data;
    });
    print(queryData['imdCode']);
    print(queryData['rmCode']);

    if (data['imdCode'] != null) {
      appState.updateVariables(imdCode: data['imdCode']);
    } else {
      appState.updateVariables(employee_code: data['rmCode']);
    }
    // print('Received rmCode: $rmCode');
    // _checkIsRootedOrJailBroken();
  }

  // void _checkIsRootedOrJailBroken() async {
  //   try {
  //     bool isJailBroken = await SafeDevice.isJailBroken;
  //     isRootedOrJailBroken = isJailBroken;
  //     if (Platform.isAndroid) {
  //       setState(() {
  //         _result = isJailBroken ? 'Rooted' : 'Not rooted';
  //       });
  //     } else if (Platform.isIOS) {
  //       setState(() {
  //         _result = isJailBroken ? 'Jailbroken' : 'Not jailbroken';
  //       });
  //     } else {
  //       setState(() {
  //         _result = '-';
  //       });
  //     }
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => _prefs.then((SharedPreferences prefs) {
        // employeeNo = prefs.getString('employeeNo') ?? '';
        // // if (isRootedOrJailBroken) {
        // //   Navigator.pushReplacement(context,
        // //       MaterialPageRoute(builder: (context) => const CheckRooted()));
        // // } else {
        if (queryData?['imdCode'] != null || queryData?['rmCode'] != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const InwardStatus2()));
          // Navigator.pushReplacementNamed(context, '/dashboard');
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => KYCIndividual(
          //               inwardData: {'id': 5942159},
          //               inwardType: {},
          //               isEdit: true,
          //               // isView: true,
          //             )));
          //             ProposalDocuments(
          //                 inwardData: {
          //                   "product": "Arogya Sanjeevani",
          //                   'id': "5941633"
          //                 },
          //                 isEdit: true,
          //                 // isView: true,
          //                 inwardType: "endorsement",
          //                 ckycData: {},
          //                 ckycDocuments: null)));
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const MyForm()));
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             //  InwardStatus2())
          //             ProposalDocuments(
          //                 inwardData: const {
          //                   "product": "Advance Loss Of Profit",
          //                   'id': "5927406"
          //                 },
          //                 inwardType: "Proposal",
          //                 ckycData: {},
          //                 ckycDocuments: null)));
        } else {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             // KYCIndividual(
          //             //     inwardData: {'id': 5927412}, inwardType: {})
          //             ProposalDocuments(
          //                 inwardData: {
          //                   "product": "Advance Loss Of Profit",
          //                   'id': "5927406"
          //                 },
          //                 inwardType: "Proposal",
          //                 ckycData: {},
          //                 ckycDocuments: null)
          //         // );
          //         ));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const UnauthorizedScreen()));
        }
        // }
      }),
    );
    // () => Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => MyForm())));
    // // KYCIndividual(inwardData: {'id': 5927412}, inwardType: {})

    // );
    // const InwardStatus2()
    // const KYCOther(
    //   inwardData: {'id': 5927294},
    //   inwardType: {},
    // ))));
    // KYCIndividual(inwardData: {}, inwardType: {})
    // ProposalDocuments(
    //     inwardData: {"product": "Advance Loss Of Profit", 'id': "5927406"},
    //     inwardType: "Proposal",
    //     ckycData: {},
    //     ckycDocuments: null)
    // );

    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(children: [
              Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 230,
                        height: 170,
                        child: Image.asset('assets/new_logo.jpg'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: const Color.fromRGBO(13, 154, 189, 1),
                          rightDotColor: const Color.fromRGBO(145, 5, 158, 1),
                          size: 35,
                        ),
                      ),
                    ]),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.white),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                              '© SBI General Insurance Company Limited | All Rights Reserved.',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(15, 5, 158, 1),
                              )),
                        ),
                      ]),
                ),
              ),
            ])));
  }
}

// const Color.fromRGBO(13, 154, 189, 1),
// const Color.fromRGBO(11, 133, 163, 1),