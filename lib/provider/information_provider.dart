import 'package:flutter/material.dart';
import 'package:sims_denny/models/information/banner.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/services/information_service.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/shared.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerData> banners = [];
  Status status = Status.loading;
  String errorMessage = '';

  final _informationService = InformationService();

  Future<int?> getBanner() async {
    status = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response = await _informationService.getBanner();
    if (response.status == ApiConstants.success) {
      banners = response.data ?? [];
      status = Status.success;
      notifyListeners();
      return ApiConstants.success;
    } else {
      if (response.status == ApiConstants.unauthorized) {
        status = Status.error;
        notifyListeners();
        return ApiConstants.unauthorized;
      } else {
        status = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return response.status;
      }
    }
  }
}

class ServicesProvider extends ChangeNotifier {
  List<Service> services = [];
  Status status = Status.loading;
  String errorMessage = '';

  final _informationService = InformationService();

  Future<int?> getServices() async {
    status = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response = await _informationService.getService();
    if (response.status == ApiConstants.success) {
      services = response.data ?? [];
      status = Status.success;
      notifyListeners();
      return ApiConstants.success;
    } else {
      if (response.status == ApiConstants.unauthorized) {
        status = Status.error;
        notifyListeners();
        return ApiConstants.unauthorized;
      } else {
        status = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return response.status;
      }
    }
  }
}
