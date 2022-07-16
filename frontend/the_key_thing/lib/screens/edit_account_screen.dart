import 'package:flutter/material.dart';
import 'package:the_key_thing/screens/home_screen.dart';
import 'package:the_key_thing/models/account.dart';
import 'package:the_key_thing/utils/account_utils.dart';

class EditAccountDetailsScreen extends StatefulWidget {
  late int? idx;
  late String? email;
  EditAccountDetailsScreen({Key? key, this.idx, this.email}) : super(key: key);

  @override
  State<EditAccountDetailsScreen> createState() =>
      _EditAccountDetailsScreenState();
}

class _EditAccountDetailsScreenState extends State<EditAccountDetailsScreen> {
  final TextStyle style =
      const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  late Account account;

  String? service = "";
  String? login = "";
  String? password = "";

  bool passwordObscured = true;
  IconData passwordVisibilityIcon = Icons.visibility_off_sharp;

  void togglePasswordVisibility() {
    passwordObscured = !passwordObscured;

    if (passwordVisibilityIcon == Icons.visibility_off_sharp) {
      passwordVisibilityIcon = Icons.visibility_sharp;
    } else {
      passwordVisibilityIcon = Icons.visibility_off_sharp;
    }
  }

  void edit(context) {
    if (service != "") {
      account.service = service!;
    }
    if (login != "") {
      account.login = login!;
    }
    if (password != "") {
      account.password = password!;
    }

    var data = {
      "service": account.service,
      "login": account.login,
      "password": account.password,
    };

    editAccount(widget.email, widget.idx!, data).then((response) => {
          if (response.statusCode == 200)
            {Navigator.pop(context)}
          else
            {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Something went wrong!"),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    account = accounts[widget.idx!];
    Size size = MediaQuery.of(context).size;

    final serviceField = TextField(
      style: style,
      onChanged: (text) {
        service = text;
      },
      decoration:
          InputDecoration(hintText: ("Service Name: ${account.service!}")),
    );

    final loginField = TextField(
      style: style,
      onChanged: (text) {
        login = text;
      },
      decoration: InputDecoration(
          hintText: ("Login (Username or Email): ${account.login!}")),
    );

    final passwordField = TextField(
      obscureText: passwordObscured,
      style: style,
      onChanged: (text) {
        password = text;
      },
      decoration: InputDecoration(
        hintText: ("Password: ${account.password!}"),
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
          edit(context);
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account Details"),
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
