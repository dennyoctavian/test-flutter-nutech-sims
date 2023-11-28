import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/member/user_token.dart';

class LoginResponse {
  int? status;
  String? message;
  UserToken? data;
  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null ? UserToken.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));

  LoginResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<UserToken?>? data,
  }) {
    return LoginResponse(
      status: status?.call() ?? this.status,
      message: message?.call() ?? this.message,
      data: data?.call() ?? this.data,
    );
  }
}
