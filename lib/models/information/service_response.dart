import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/information/service.dart';

class ServiceResponse {
  int? status;
  String? message;
  List<Service>? data;
  ServiceResponse({
    this.status,
    this.message,
    this.data,
  });

  ServiceResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<List<Service>?>? data,
  }) {
    return ServiceResponse(
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

  factory ServiceResponse.fromMap(Map<String, dynamic> map) {
    return ServiceResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null
          ? List<Service>.from(map['data']?.map((x) => Service.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceResponse.fromJson(String source) =>
      ServiceResponse.fromMap(json.decode(source));
}
