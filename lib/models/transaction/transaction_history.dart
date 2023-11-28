import 'dart:convert';

import 'package:flutter/widgets.dart';

class TransactionHistory {
  String? invoiceNumber;
  String? transactionType;
  String? description;
  int? totalAmount;
  String? createdOn;
  TransactionHistory({
    this.invoiceNumber,
    this.transactionType,
    this.description,
    this.totalAmount,
    this.createdOn,
  });

  TransactionHistory copyWith({
    ValueGetter<String?>? invoiceNumber,
    ValueGetter<String?>? transactionType,
    ValueGetter<String?>? description,
    ValueGetter<int?>? totalAmount,
    ValueGetter<String?>? createdOn,
  }) {
    return TransactionHistory(
      invoiceNumber: invoiceNumber?.call() ?? this.invoiceNumber,
      transactionType: transactionType?.call() ?? this.transactionType,
      description: description?.call() ?? this.description,
      totalAmount: totalAmount?.call() ?? this.totalAmount,
      createdOn: createdOn?.call() ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'transactionType': transactionType,
      'description': description,
      'totalAmount': totalAmount,
      'createdOn': createdOn,
    };
  }

  factory TransactionHistory.fromMap(Map<String, dynamic> map) {
    return TransactionHistory(
      invoiceNumber: map['invoice_number'],
      transactionType: map['transaction_type'],
      description: map['description'],
      totalAmount: map['total_amount'],
      createdOn: map['created_on'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionHistory.fromJson(String source) =>
      TransactionHistory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionHistory(invoiceNumber: $invoiceNumber, transactionType: $transactionType, description: $description, totalAmount: $totalAmount, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionHistory &&
        other.invoiceNumber == invoiceNumber &&
        other.transactionType == transactionType &&
        other.description == description &&
        other.totalAmount == totalAmount &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return invoiceNumber.hashCode ^
        transactionType.hashCode ^
        description.hashCode ^
        totalAmount.hashCode ^
        createdOn.hashCode;
  }
}
