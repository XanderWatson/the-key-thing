import 'dart:async';
import 'package:the_key_thing/screens/home_screen.dart';
import 'package:the_key_thing/models/account.dart';
import 'package:the_key_thing/screens/edit_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:the_key_thing/utils/account_utils.dart';

class AccountDetailsScreen extends StatefulWidget {
  late int? idx;
  late String? email;
  AccountDetailsScreen({Key? key, this.idx, this.email}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final TextStyle style =
      const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String passwordText = "Show";
  bool visible = false;

  void showHidePassword() {
    setState(() {
      visible = !visible;

      if (passwordText == "Show") {
        passwordText = "Hide";
      } else {
        passwordText = "Show";
      }
    });
  }

  FutureOr onEdit(dynamic value) {
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Accout details updated!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FutureOr onDelete(dynamic value) {
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Account deleted!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void goToEdit(context, idx) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditAccountDetailsScreen(idx: idx, email: widget.email)))
        .then(onEdit);
  }

  void delete(context, idx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure you want to delete this account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteAccount(widget.email, widget.idx!)
                    .then((response) => {
                          if (response.statusCode == 200)
                            {
                              Navigator.pop(context),
                            }
                          else
                            {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Error"),
                                        content:
                                            const Text("Something went wrong!"),
                                        actions: [
                                          TextButton(
                                            child: const Text("OK"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ))
                            }
                        })
                    .then(onDelete);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var idx = widget.idx;
    Account account = accounts[idx!];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      backgroundColor: Colors.white,
      body: Column(children: <Widget>[
        ListTile(
            title: const Text("Service:"),
            subtitle: Text(account.service!, style: style)),
        ListTile(
            title: const Text("Login:"),
            subtitle: Text(account.login!, style: style)),
        ListTile(
          title: const Text("Password:"),
          subtitle: Visibility(
            visible: visible,
            child: Text(account.password!, style: style),
          ),
          trailing: TextButton(
            child: Text("$passwordText Password"),
            onPressed: () {
              showHidePassword();
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              goToEdit(context, idx);
            },
            child: const Center(child: Text("Edit Details"))),
        ElevatedButton(
            onPressed: () {
              delete(context, idx);
            },
            child: const Center(child: Text("Delete Account")))
      ]),
    );
  }
}
