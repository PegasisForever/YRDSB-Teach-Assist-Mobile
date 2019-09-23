import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:ta/model/User.dart';

import '../firebaseMsg.dart';

const String baseUrl = "http://192.168.1.22:1560/";

Future<List> regi(User user) async {
  Response response = await post(baseUrl + "regi",
      body: jsonEncode({"user": user, "token": firebaseToken}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return jsonDecode(response.body);
}

Future<void> deregi(User user) async{
  Response response = await post(baseUrl + "deregi",
      body: jsonEncode({"user": user, "token": firebaseToken}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return;
}