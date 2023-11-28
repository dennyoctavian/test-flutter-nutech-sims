import 'dart:convert';

class RegisterBody {
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  RegisterBody({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}
