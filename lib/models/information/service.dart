import 'dart:convert';

import 'package:flutter/widgets.dart';

class Service {
  String? serviceCode;
  String? serviceName;
  String? serviceIcon;
  int? serviceTariff;

  Service({
    this.serviceCode,
    this.serviceName,
    this.serviceIcon,
    this.serviceTariff,
  });

  Service copyWith({
    ValueGetter<String?>? serviceCode,
    ValueGetter<String?>? serviceName,
    ValueGetter<String?>? serviceIcon,
    ValueGetter<int?>? serviceTariff,
  }) {
    return Service(
      serviceCode: serviceCode?.call() ?? this.serviceCode,
      serviceName: serviceName?.call() ?? this.serviceName,
      serviceIcon: serviceIcon?.call() ?? this.serviceIcon,
      serviceTariff: serviceTariff?.call() ?? this.serviceTariff,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceCode': serviceCode,
      'serviceName': serviceName,
      'serviceIcon': serviceIcon,
      'serviceTariff': serviceTariff,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceCode: map['service_code'],
      serviceName: map['service_name'],
      serviceIcon: map['service_icon'],
      serviceTariff: map['service_tariff']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) =>
      Service.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Service(serviceCode: $serviceCode, serviceName: $serviceName, serviceIcon: $serviceIcon, serviceTariff: $serviceTariff)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Service &&
        other.serviceCode == serviceCode &&
        other.serviceName == serviceName &&
        other.serviceIcon == serviceIcon &&
        other.serviceTariff == serviceTariff;
  }

  @override
  int get hashCode {
    return serviceCode.hashCode ^
        serviceName.hashCode ^
        serviceIcon.hashCode ^
        serviceTariff.hashCode;
  }
}
