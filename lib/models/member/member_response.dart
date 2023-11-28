import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/member/user.dart';

class MemberResponse {
  int? status;
  String? message;
  User? data;
  MemberResponse({
    this.status,
    this.message,
    this.data,
  });

  MemberResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<User?>? data,
  }) {
    return MemberResponse(
      status: status?.call() ?? this.status,
      message: message?.call() ?? this.message,
      data: data?.call() ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory MemberResponse.fromMap(Map<String, dynamic> map) {
    return MemberResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null ? User.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberResponse.fromJson(String source) =>
      MemberResponse.fromMap(json.decode(source));
}
