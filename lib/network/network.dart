import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:ta/model/User.dart';

import '../firebaseMsg.dart';

const String baseUrl = true?"https://api.pegasis.site/yrdsb_ta/":"http://192.168.1.22:5004/";

Future<String> regi(User user) async {
  print(baseUrl);
  Response response = await post(baseUrl + "regi",
      body: jsonEncode({"user": user, "token": firebaseToken}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return response.body;
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

Future<String> getMark(User user) async {
  Response response = await post(baseUrl + "getmark",
      body: jsonEncode({"number": user.number, "password": user.password}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return response.body;
}