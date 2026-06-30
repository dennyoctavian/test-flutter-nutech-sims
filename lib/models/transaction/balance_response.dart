import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/transaction/balance.dart';

class BalanceResponse {
  int? status;
  String? message;
  Balance? data;
  BalanceResponse({
    this.status,
    this.message,
    this.data,
  });

  BalanceResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<Balance?>? data,
  }) {
    return BalanceResponse(
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

  factory BalanceResponse.fromMap(Map<String, dynamic> map) {
    return BalanceResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null ? Balance.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BalanceResponse.fromJson(String source) =>
      BalanceResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'BalanceResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BalanceResponse &&
        other.status == status &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}
