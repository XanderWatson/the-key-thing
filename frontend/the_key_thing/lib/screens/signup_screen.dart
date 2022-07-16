import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_key_thing/utils/user_utils.dart';
import 'package:the_key_thing/services/secure_storage_service.dart';
import 'package:crypto/crypto.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool passwordObscured = true;
  IconData passwordVisibilityIcon = Icons.visibility_off_sharp;

  bool confirmPasswordObscured = true;
  IconData confirmPasswordVisibilityIcon = Icons.visibility_off_sharp;

  late String firstName;
  late String lastName;
  late String email;
  late String password;
  late String passwordConfirm;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final StorageService _storageService = StorageService();

  void toggleMasterPasswordVisibility() {
    setState(() {
      passwordObscured = !passwordObscured;

      if (passwordVisibilityIcon == Icons.visibility_off_sharp) {
        passwordVisibilityIcon = Icons.visibility_sharp;
      } else {
        passwordVisibilityIcon = Icons.visibility_off_sharp;
      }
    });
  }

  void toggleConfirmMasterPasswordVisibility() {
    setState(() {
      confirmPasswordObscured = !confirmPasswordObscured;
      if (confirmPasswordVisibilityIcon == Icons.visibility_off_sharp) {
        confirmPasswordVisibilityIcon = Icons.visibility_sharp;
      } else {
        confirmPasswordVisibilityIcon = Icons.visibility_off_sharp;
      }
    });
  }

  void clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void signUp() {
    if (password != passwordConfirm) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Passwords do not match'),
            content: const Text('Please confirm your password again'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var data = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "master_password": sha512.convert(utf8.encode(password)).toString(),
      };

      postUserDetails(data).then((response) {
        if (response.statusCode == 201) {
          _storageService.writeSecureData('email', email).then((_) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Sign Up Success!'),
                    content: const Text(
                        'You have successfully signed up! Please login to continue.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          clear();
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  );
                });
          });
        } else if (response.statusCode == 409) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Email address already exists'),
                content: const Text('Please try another email address.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextField(
      controller: firstNameController,
      obscureText: false,
      style: style,
      onChanged: (text) {
        setState(() {
          firstName = text;
        });
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final lastNameField = TextField(
      controller: lastNameController,
      obscureText: false,
      style: style,
      onChanged: (text) {
        setState(() {
          lastName = text;
        });
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      onChanged: (text) {
        setState(() {
          email = text;
        });
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: passwordObscured,
      style: style,
      onChanged: (text) {
        setState(() {
          password = text;
        });
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                toggleMasterPasswordVisibility();
              },
              icon: Icon(passwordVisibilityIcon)),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Master Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordConfirmField = TextField(
      controller: passwordConfirmController,
      obscureText: confirmPasswordObscured,
      style: style,
      onChanged: (text) {
        setState(() {
          passwordConfirm = text;
        });
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                toggleConfirmMasterPasswordVisibility();
              },
              icon: Icon(confirmPasswordVisibilityIcon)),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Master Password Again",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightBlue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: signUp,
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.75,
                        child: firstNameField,
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.75,
                        child: lastNameField,
                      )
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  const SizedBox(height: 25.0),
                  passwordConfirmField,
                  const SizedBox(height: 35.0),
                  signUpButton
                ],
              ))),
        ),
      ),
    );
  }
}
