import 'dart:convert';

import 'package:flutter/widgets.dart';

class UserToken {
  String? token;

  UserToken({
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return UserToken(
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserToken.fromJson(String source) =>
      UserToken.fromMap(json.decode(source));

  @override
  String toString() => 'UserToken(token: $token)';

  UserToken copyWith({
    ValueGetter<String?>? token,
  }) {
    return UserToken(
      token: token?.call() ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserToken && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
