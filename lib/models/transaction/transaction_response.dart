import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/transaction/transaction.dart';

class TransactionResponse {
  int? status;
  String? message;
  Transaction? data;
  TransactionResponse({
    this.status,
    this.message,
    this.data,
  });

  TransactionResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<Transaction?>? data,
  }) {
    return TransactionResponse(
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

  factory TransactionResponse.fromMap(Map<String, dynamic> map) {
    return TransactionResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null ? Transaction.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionResponse.fromJson(String source) =>
      TransactionResponse.fromMap(json.decode(source));
}
