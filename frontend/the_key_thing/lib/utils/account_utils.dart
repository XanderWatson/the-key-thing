import 'package:http/http.dart';

String baseURL = "http://192.168.1.7:3000/";

Future<Response> postAccountDetails(String? email, var data) async {
  var url = "${baseURL}accounts";
  Response response = await post(Uri.parse(url), body: data, headers: {
    "email": email!,
  });
  return response;
}

Future<Response> getAccounts(String? email) async {
  var url = "${baseURL}accounts";
  Response response = await get(Uri.parse(url), headers: {
    "email": email!,
  });
  return response;
}

Future<Response> editAccount(String? email, int index, var data) async {
  var url = "${baseURL}accounts";
  Response response = await put(Uri.parse(url), body: data, headers: {
    "email": email!,
    "index": index.toString(),
  });
  return response;
}

Future<Response> deleteAccount(String? email, int index) async {
  var url = "${baseURL}accounts";
  Response response = await delete(Uri.parse(url), headers: {
    "email": email!,
    "index": index.toString(),
  });
  return response;
}
