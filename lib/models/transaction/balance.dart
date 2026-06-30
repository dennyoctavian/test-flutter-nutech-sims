import 'dart:convert';

import 'package:flutter/widgets.dart';

class Balance {
  int? balance;
  Balance({
    this.balance,
  });

  Balance copyWith({
    ValueGetter<int?>? balance,
  }) {
    return Balance(
      balance: balance?.call() ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
    };
  }

  factory Balance.fromMap(Map<String, dynamic> map) {
    return Balance(
      balance: map['balance']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Balance.fromJson(String source) =>
      Balance.fromMap(json.decode(source));

  @override
  String toString() => 'Balance(balance: $balance)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Balance && other.balance == balance;
  }

  @override
  int get hashCode => balance.hashCode;
}
