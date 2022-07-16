class Account {
  late String? service;
  late String? login;
  late String? password;

  Account({
    this.service,
    this.login,
    this.password,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        service: json["service"],
        login: json["login"],
        password: json["password"],
      );
}
