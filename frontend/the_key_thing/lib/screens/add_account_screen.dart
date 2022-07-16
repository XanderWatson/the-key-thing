import 'package:flutter/material.dart';
import 'package:the_key_thing/utils/account_utils.dart';
import 'package:the_key_thing/services/secure_storage_service.dart';

class AddAccountScreen extends StatelessWidget {
  final TextStyle style =
      const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  late String service;
  late String login;
  late String password;

  bool passwordObscured = true;
  IconData passwordVisibilityIcon = Icons.visibility_off_sharp;

  AddAccountScreen({Key? key}) : super(key: key);

  final StorageService _storageService = StorageService();

  void togglePasswordVisibility() {
    passwordObscured = !passwordObscured;
    if (passwordVisibilityIcon == Icons.visibility_off_sharp) {
      passwordVisibilityIcon = Icons.visibility_sharp;
    } else {
      passwordVisibilityIcon = Icons.visibility_off_sharp;
    }
  }

  void addAccount(context) {
    var data = {
      "service": service,
      "login": login,
      "password": password,
    };

    _storageService.readSecureData('email').then((email) => {
          postAccountDetails(email, data).then((response) => {
                if (response.statusCode == 201)
                  {Navigator.pop(context)}
                else
                  {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Something went wrong"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        })
                  }
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final serviceField = TextField(
      style: style,
      onChanged: (text) {
        service = text;
      },
      decoration: const InputDecoration(hintText: "Service Name"),
    );

    final loginField = TextField(
      style: style,
      onChanged: (text) {
        login = text;
      },
      decoration: const InputDecoration(hintText: "Login (Username or Email)"),
    );

    final passwordField = TextField(
      obscureText: passwordObscured,
      style: style,
      onChanged: (text) {
        password = text;
      },
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: IconButton(
            onPressed: () {
              togglePasswordVisibility();
            },
            icon: Icon(passwordVisibilityIcon)),
      ),
    );

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightBlue,
      child: MaterialButton(
        minWidth: size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          addAccount(context);
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Account"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                serviceField,
                const SizedBox(height: 55),
                loginField,
                const SizedBox(height: 55),
                passwordField,
                const SizedBox(height: 65),
                saveButton,
                const SizedBox(height: 70)
              ],
            ))),
      ),
    );
  }
}
