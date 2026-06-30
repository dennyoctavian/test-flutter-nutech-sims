import 'dart:convert';

import 'package:flutter/widgets.dart';

class BannerData {
  String? bannerName;
  String? bannerImage;
  String? description;

  BannerData({
    this.bannerName,
    this.bannerImage,
    this.description,
  });

  BannerData copyWith({
    ValueGetter<String?>? bannerName,
    ValueGetter<String?>? bannerImage,
    ValueGetter<String?>? description,
  }) {
    return BannerData(
      bannerName: bannerName?.call() ?? this.bannerName,
      bannerImage: bannerImage?.call() ?? this.bannerImage,
      description: description?.call() ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bannerName': bannerName,
      'bannerImage': bannerImage,
      'description': description,
    };
  }

  factory BannerData.fromMap(Map<String, dynamic> map) {
    return BannerData(
      bannerName: map['banner_name'],
      bannerImage: map['banner_image'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerData.fromJson(String source) =>
      BannerData.fromMap(json.decode(source));

  @override
  String toString() =>
      'Banner(bannerName: $bannerName, bannerImage: $bannerImage, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BannerData &&
        other.bannerName == bannerName &&
        other.bannerImage == bannerImage &&
        other.description == description;
  }

  @override
  int get hashCode =>
      bannerName.hashCode ^ bannerImage.hashCode ^ description.hashCode;
}
