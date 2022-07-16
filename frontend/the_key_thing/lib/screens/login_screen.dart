import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_key_thing/utils/user_utils.dart';
import 'package:the_key_thing/services/secure_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final StorageService _storageService = StorageService();

  void setEmail() {
    _storageService.readSecureData('email').then((value) {
      if (value != null) {
        setState(() {
          emailController.text = value;
          email = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setEmail());
  }

  late String email;
  late String password;

  bool passwordObscured = true;
  IconData passwordVisibilityIcon = Icons.visibility_off_sharp;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      passwordObscured = !passwordObscured;
      if (passwordVisibilityIcon == Icons.visibility_off_sharp) {
        passwordVisibilityIcon = Icons.visibility_sharp;
      } else {
        passwordVisibilityIcon = Icons.visibility_off_sharp;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    var userDetails;

    loginUser(email, password).then((response) {
      if (response.statusCode == 200) {
        _storageService.writeSecureData('email', email);
        getUserDetails(email).then((res) => {
              if (res.statusCode == 200)
                {
                  userDetails = json.decode(res.body),
                  _storageService.writeSecureData(
                      'first_name', userDetails['first_name']),
                  _storageService.writeSecureData(
                      'last_name', userDetails['last_name']),
                }
            });

        Navigator.pushNamed(context, '/home');
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email address not found'),
              content: const Text(
                  'Please register before using this email address.'),
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
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Incorrect password'),
              content: const Text('Please try again.'),
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
              content: const Text('Please try again.'),
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

  @override
  Widget build(BuildContext context) {
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
          prefixIcon: const Icon(Icons.email_sharp),
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
          prefixIcon: const Icon(Icons.password_sharp),
          suffixIcon: IconButton(
              onPressed: () {
                togglePasswordVisibility();
              },
              icon: Icon(passwordVisibilityIcon)),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Master Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightBlue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          login();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        backgroundColor: Colors.lightBlue,
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
                    const SizedBox(height: 65),
                    // SizedBox(
                    //     height: 175,
                    //     child: SvgPicture.asset("assets/icons/login.svg",
                    //         fit: BoxFit.contain)),
                    const SizedBox(height: 50.0),
                    emailField,
                    const SizedBox(height: 25.0),
                    passwordField,
                    const SizedBox(height: 35.0),
                    loginButon,
                    const SizedBox(height: 70)
                  ],
                ),
              )),
        )));
  }
}
