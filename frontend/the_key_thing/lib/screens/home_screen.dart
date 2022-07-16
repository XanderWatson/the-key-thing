import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_key_thing/screens/add_account_screen.dart';
import 'package:the_key_thing/services/secure_storage_service.dart';
import 'package:the_key_thing/utils/account_utils.dart';
import 'package:the_key_thing/screens/account_details_screen.dart';
import 'package:the_key_thing/models/account.dart';
import 'package:the_key_thing/utils/user_utils.dart';
import 'package:http/http.dart';

List<Account> accounts = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextStyle style =
      const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final StorageService _storageService = StorageService();

  FutureOr onSave(dynamic value) {
    setState(() {});
    final snackBar = SnackBar(
      content: const Text('Accout details added!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FutureOr onReturn(dynamic value) {
    setState(() {});
  }

  void viewDetails(int idx) {
    _storageService.readSecureData('email').then((email) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountDetailsScreen(
            idx: idx,
            email: email,
          ),
        ),
      ).then(onReturn);
    });
  }

  Future<List<String>> fetchData() async {
    String? email = await _storageService.readSecureData('email');
    Response response = await getAccounts(email);
    List names = await getUserDetails();

    List<String> data = [names[0], names[1], response.body];

    return Future.value(data);
  }

  void loadAccounts(String? accountsJSON) {
    accounts = [];
    var data = json.decode(accountsJSON!);

    if (data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        accounts.add(Account.fromJson(json.decode(data[i])));
      }
    }
  }

  Future<List<String>> getUserDetails() async {
    var fname = await _storageService.readSecureData('first_name');
    var lname = await _storageService.readSecureData('last_name');

    return Future.value([fname!, lname!]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("The Key Thing")),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
            backgroundColor: Colors.white,
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("The Key Thing")),
              body: const Center(
                child: Text(
                    "Unable to fetch your accounts at this time. Please try again later."),
              ),
              backgroundColor: Colors.white,
            );
          } else {
            loadAccounts(snapshot.data![2]);
            return Scaffold(
              appBar: AppBar(title: const Text("The Key Thing")),
              drawer: Drawer(
                  child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Text(
                      "Welcome,\n${snapshot.data![0]} ${snapshot.data![1]}",
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/logout', (_) => false);
                    },
                    color: Colors.blue,
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Log Out",
                      style: style,
                    ),
                  )
                ],
              )),
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAccountScreen()))
                      .then(onSave);
                },
                tooltip: 'Add New Account',
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: <Widget>[
                  RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 1), () {
                          setState(() {});
                        });
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: accounts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(accounts[index].service!),
                              subtitle: Text(accounts[index].login!),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  viewDetails(index);
                                },
                              ),
                            ),
                          );
                        },
                      ))
                ],
              ),
            );
          }
        }
      },
    );
  }
}
