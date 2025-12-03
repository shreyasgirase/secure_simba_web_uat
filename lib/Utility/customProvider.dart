// ignore_for_file: unused_local_variable, avoid_init_to_null, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
import 'package:secure_app/Encryption-Decryption/AES-GCM.dart';
// import 'package:secure_app/Encryption-Decryption/crypto-utils.dart';
import 'package:secure_app/Utility/dioSingleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Dio dio = DioSingleton.dio;
  var _mobileNumber;
  var _employeeNo;
  int _otp = 0;
  var _userId = null;
  String _name = '';
  var _proposalId;
  var _email;
  String _accessToken = '';
  var _employee_code = null;
  var _imdCode = null;
  var _selectedRegNO = 'BH';

  int get otp => _otp;
  get employeeNo => _employeeNo;
  get employee_code => _employee_code;
  get imdCode => _imdCode;
  get userId => _userId;
  get mobileNumber => _mobileNumber;
  get proposalId => _proposalId;
  get name => _name;
  get email => _email;
  get accessToken => _accessToken;
  get selectedRegNO => _selectedRegNO;

  void updateVariables(
      {mobileNumber,
      employeeNo,
      userId,
      otp,
      email,
      name,
      proposalId,
      employee_code,
      imdCode,
      selectedRegNO
      }) {
    if (mobileNumber != null) {
      _mobileNumber = mobileNumber;
    }
    if (employeeNo != null) {
      _employeeNo = employeeNo;
    }
    if (employee_code != null) {
      _employee_code = employee_code;
    }
    if (imdCode != null) {
      _imdCode = imdCode;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (otp != null) {
      _otp = otp;
    }
    if (email != null) {
      _email = email;
    }
    if (name != null) {
      _name = name;
    }
    if (proposalId != null) {
      _proposalId = proposalId;
    }
    if(selectedRegNO != null) {
      _selectedRegNO = selectedRegNO;
    }
    notifyListeners();
  }

  Future<void> createToken() async {
    print('calleddd hereee');
    SharedPreferences prefs = await _prefs;

    final url = Uri.base;

    String? encryptedData = url.queryParameters['data'];
    print(encryptedData);
    var data =
        jsonDecode(aesCbcDecryptJson(encryptedData!.replaceAll(' ', '+')));
    print(data);

    print(data['imdCode']);
    print(data['rmCode']);

    // var employeeNo = prefs.getString('employeeNo') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
    };

    Map<String, dynamic> postData = imdCode == null
        ? {'rmCode': data['rmCode']}
        : {
            'imdCode': data['imdCode'].toString(),
          };
    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/checkEmployee',
          data: postData,
          options: Options(headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.data);

        _accessToken = data["token"];
        print(_accessToken);
      } else {
        throw Exception('Failed to create token');
      }
    } catch (e) {
      print(e);
    }
  }
}
