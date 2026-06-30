import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sims_denny/models/information/banner.dart';

class BannerResponse {
  int? status;
  String? message;
  List<BannerData>? data;
  BannerResponse({
    this.status,
    this.message,
    this.data,
  });

  BannerResponse copyWith({
    ValueGetter<int?>? status,
    ValueGetter<String?>? message,
    ValueGetter<List<BannerData>?>? data,
  }) {
    return BannerResponse(
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

  factory BannerResponse.fromMap(Map<String, dynamic> map) {
    return BannerResponse(
      status: map['status']?.toInt(),
      message: map['message'],
      data: map['data'] != null
          ? List<BannerData>.from(
              map['data']?.map((x) => BannerData.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerResponse.fromJson(String source) =>
      BannerResponse.fromMap(json.decode(source));
}
