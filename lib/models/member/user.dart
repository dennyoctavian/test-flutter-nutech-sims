import 'dart:convert';

import 'package:flutter/widgets.dart';

class User {
  String? email;
  String? firstName;
  String? lastName;
  String? profileImage;

  User({
    this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  User copyWith({
    ValueGetter<String?>? email,
    ValueGetter<String?>? firstName,
    ValueGetter<String?>? lastName,
    ValueGetter<String?>? profileImage,
  }) {
    return User(
      email: email?.call() ?? this.email,
      firstName: firstName?.call() ?? this.firstName,
      lastName: lastName?.call() ?? this.lastName,
      profileImage: profileImage?.call() ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      profileImage: map['profile_image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(email: $email, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        profileImage.hashCode;
  }
}
