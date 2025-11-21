import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

String aesCbcEncryptJson(String jsonData) {
  final keyBytes = encrypt.Key.fromUtf8(('secure@rework').padRight(32, ' '));
  final iv = encrypt.IV.fromUtf8(('secure@reworkiv').padRight(16, ' '));

  final encrypter =
      encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

  final encrypted = encrypter.encrypt(jsonData, iv: iv);

  final encryptedString = base64.encode(encrypted.bytes);
  return encryptedString;
}

String aesCbcDecryptJson(String encryptedData) {
  final keyBytes = encrypt.Key.fromUtf8(('secure@rework').padRight(32, ' '));
  final iv = encrypt.IV.fromUtf8(('secure@reworkiv').padRight(16, ' '));

  final encrypter =
      encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

  final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

  return decrypted;
}
