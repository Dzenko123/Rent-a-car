import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

String formatNumber(double? number) {
  if (number == null) {
    return "";
  }
  var f = NumberFormat('###,##0.00', 'en_US');
  return f.format(number);
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return "";
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute}';
}
String decrypt(String hash, String salt) {
  final key = utf8.encode(salt);
  final bytes = utf8.encode(hash);
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);
  return digest.toString();
}