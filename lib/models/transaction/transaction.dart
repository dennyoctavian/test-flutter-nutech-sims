import 'dart:convert';

import 'package:flutter/widgets.dart';

class Transaction {
  String? invoiceNumber;
  String? serviceCode;
  String? serviceName;
  String? transactionType;
  int? totalAmount;
  String? createdOn;
  Transaction({
    this.invoiceNumber,
    this.serviceCode,
    this.serviceName,
    this.transactionType,
    this.totalAmount,
    this.createdOn,
  });

  Transaction copyWith({
    ValueGetter<String?>? invoiceNumber,
    ValueGetter<String?>? serviceCode,
    ValueGetter<String?>? serviceName,
    ValueGetter<String?>? transactionType,
    ValueGetter<int?>? totalAmount,
    ValueGetter<String?>? createdOn,
  }) {
    return Transaction(
      invoiceNumber: invoiceNumber?.call() ?? this.invoiceNumber,
      serviceCode: serviceCode?.call() ?? this.serviceCode,
      serviceName: serviceName?.call() ?? this.serviceName,
      transactionType: transactionType?.call() ?? this.transactionType,
      totalAmount: totalAmount?.call() ?? this.totalAmount,
      createdOn: createdOn?.call() ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'serviceCode': serviceCode,
      'serviceName': serviceName,
      'transactionType': transactionType,
      'totalAmount': totalAmount,
      'createdOn': createdOn,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      invoiceNumber: map['invoice_number'],
      serviceCode: map['service_code'],
      serviceName: map['service_name'],
      transactionType: map['transaction_type'],
      totalAmount: map['total_amount'],
      createdOn: map['created_on'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(invoiceNumber: $invoiceNumber, serviceCode: $serviceCode, serviceName: $serviceName, transactionType: $transactionType, totalAmount: $totalAmount, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.invoiceNumber == invoiceNumber &&
        other.serviceCode == serviceCode &&
        other.serviceName == serviceName &&
        other.transactionType == transactionType &&
        other.totalAmount == totalAmount &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return invoiceNumber.hashCode ^
        serviceCode.hashCode ^
        serviceName.hashCode ^
        transactionType.hashCode ^
        totalAmount.hashCode ^
        createdOn.hashCode;
  }
}
