import 'package:flutter/material.dart';
import 'package:sims_denny/models/information/banner.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/services/information_service.dart';
import 'package:sims_denny/utils/shared.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerData> banners = [];
  Status status = Status.loading;
  String errorMessage = '';

  void getBanner(BuildContext context) async {
    status = Status.loading;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    final response = await InformationService().getBanner();
    if (response?.status == 0) {
      banners = response!.data!;
      status = Status.success;
      notifyListeners();
    } else {
      if (response?.status == 108) {
        // log out
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        status = Status.error;
        errorMessage = response?.message ?? '';
        notifyListeners();
      }
    }
  }
}

class ServicesProvider extends ChangeNotifier {
  List<Service> services = [];
  Status status = Status.loading;
  String errorMessage = '';

  void getServices(BuildContext context) async {
    status = Status.loading;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    final response = await InformationService().getService();
    if (response?.status == 0) {
      services = response!.data!;
      status = Status.success;
      notifyListeners();
    } else {
      if (response?.status == 108) {
        // log out
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        status = Status.error;
        errorMessage = response?.message ?? '';
        notifyListeners();
      }
    }
  }
}
