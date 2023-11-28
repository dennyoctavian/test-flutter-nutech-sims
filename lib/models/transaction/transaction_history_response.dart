import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/transaction/transaction_history.dart';

class TransactionHistoryResponse {
  int? status;
  String? message;
  List<TransactionHistory>? data;
  TransactionHistoryResponse({
    this.status,
    this.message,
    this.data,
  });

  TransactionHistoryResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<List<TransactionHistory>?>? data,
  }) {
    return TransactionHistoryResponse(
      status: status?.call() ?? this.status,
      message: message?.call() ?? this.message,
      data: data?.call() ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionHistoryResponse.fromMap(Map<String, dynamic> map) {
    return TransactionHistoryResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data']['records'] != null
          ? List<TransactionHistory>.from(
              map['data']['records']?.map((x) => TransactionHistory.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionHistoryResponse.fromJson(String source) =>
      TransactionHistoryResponse.fromMap(json.decode(source));
}
