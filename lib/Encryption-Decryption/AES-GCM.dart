import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;

// const keyBase64 = 'FKUm4HyKW1M/z+o2LdE5+5XORd2J/LcQ';
// const ivBase64 = '+XIwbOMCzLQ=';

const keyBase64 = "cm3EvzwAl4xhfg8vNux4Ykn4l5EMQ4EtRsnhFa1EIK0=";
const ivBase64 = "KWtA4Crj5AySK4g8";

String aesGcmEncryptJson(String jsonData) {
  final keyBytes = encrypt.Key(Uint8List.fromList(base64.decode(keyBase64)));
  final iv = encrypt.IV(Uint8List.fromList(base64.decode(ivBase64)));

  final encrypter = encrypt.Encrypter(encrypt.AES(
    keyBytes,
    mode: encrypt.AESMode.gcm,
  ));

  final encrypted = encrypter.encrypt(jsonData, iv: iv);

  final encryptedString = base64.encode(encrypted.bytes);
  return encryptedString;
}

String aesGcmDecryptJson(String encryptedData) {
  // final keyBytes = encrypt.Key.fromUtf8((keyBase64));
  // final iv = encrypt.IV.fromUtf8((ivBase64));
  final keyBytes = encrypt.Key(Uint8List.fromList(base64.decode(keyBase64)));
  final iv = encrypt.IV(Uint8List.fromList(base64.decode(ivBase64)));
  final encrypter =
      encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.gcm));

  final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

  return decrypted;
}
