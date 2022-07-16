import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

String baseURL = "http://192.168.1.7:3000/";

Future<Response> postUserDetails(var data) async {
  var url = "${baseURL}users/signup/";
  Response response = await post(Uri.parse(url), body: data);
  return response;
}

Future<Response> loginUser(String email, String password) async {
  var url = "${baseURL}users/login/";
  Response response = await get(Uri.parse(url), headers: {
    "email": email,
    "master_password": sha512.convert(utf8.encode(password)).toString(),
  });
  return response;
}

Future<Response> getUserDetails(String? email) async {
  var url = "${baseURL}users/details/";
  Response response = await get(Uri.parse(url), headers: {
    "email": email!,
  });
  return response;
}
