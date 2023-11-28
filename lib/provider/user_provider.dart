import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sims_denny/components/alert_dialog_custom.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/models/member/user.dart';
import 'package:sims_denny/services/member_service.dart';
import 'package:sims_denny/services/transaction_service.dart';
import 'package:sims_denny/utils/shared.dart';

class UserProvider extends ChangeNotifier {
  User user = User();
  int balance = 0;
  Status status = Status.loading;
  Status statusBalance = Status.loading;
  String errorMessage = '';
  String errorMessageBalance = '';

  void getProfile(BuildContext context) async {
    status = Status.loading;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    final response = await MemberService().getProfile();
    if (response?.status == 0) {
      user = response!.data!;
      status = Status.success;
      notifyListeners();
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        status = Status.error;
        errorMessage = response?.message ?? '';
        notifyListeners();
      }
    }
  }

  void updateProfile(
      String firstName, String lastName, BuildContext context) async {
    status = Status.loading;
    notifyListeners();
    final response = await MemberService().updateProfile(firstName, lastName);
    if (response?.status == 0) {
      user = response!.data!;
      status = Status.success;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showSnackBar(context, response.message ?? "", isSuccess: true);
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        status = Status.error;
        errorMessage = response?.message ?? '';
        // ignore: use_build_context_synchronously
        showSnackBar(
          context,
          response?.message ?? "",
        );
        notifyListeners();
      }
    }
  }

  void updateProfilePicture(File file, BuildContext context) async {
    status = Status.loading;
    notifyListeners();
    final response = await MemberService().updateProfileImage(file);
    if (response?.status == 0) {
      user = response!.data!;
      status = Status.success;
      // ignore: use_build_context_synchronously
      showSnackBar(context, response.message ?? "", isSuccess: true);
      notifyListeners();
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        status = Status.error;
        errorMessage = response?.message ?? '';
        // ignore: use_build_context_synchronously
        showSnackBar(context, response?.message ?? "");
        notifyListeners();
      }
    }
  }

  void getBalance(BuildContext context) async {
    statusBalance = Status.loading;

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    final response = await TransactionService().getBalance();
    if (response?.status == 0) {
      balance = response!.data?.balance ?? 0;
      statusBalance = Status.success;
      notifyListeners();
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        statusBalance = Status.error;
        errorMessageBalance = response?.message ?? '';
        notifyListeners();
      }
    }
  }

  void topup(int totalAmount, BuildContext context) async {
    statusBalance = Status.loading;
    notifyListeners();
    final response = await TransactionService().topup(totalAmount);
    if (response?.status == 0) {
      statusBalance = Status.success;
      balance = response!.data?.balance ?? 0;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showSuccessOrFailed(context, balanceTopup: totalAmount);
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        statusBalance = Status.error;
        errorMessageBalance = response?.message ?? '';
        notifyListeners();
        // ignore: use_build_context_synchronously
        showSuccessOrFailed(context,
            balanceTopup: totalAmount, isSuccess: false);
      }
    }
  }

  void payment(Service service, BuildContext context) async {
    statusBalance = Status.loading;
    notifyListeners();
    final response =
        await TransactionService().createTransaction(service.serviceCode ?? '');
    if (response?.status == 0) {
      statusBalance = Status.success;

      balance -= response!.data?.totalAmount ?? 0;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showSuccessOrFailed(context, service: service);
    } else {
      if (response?.status == 108) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        statusBalance = Status.error;
        errorMessageBalance = response?.message ?? '';
        notifyListeners();
        // ignore: use_build_context_synchronously
        showSuccessOrFailed(context, service: service, isSuccess: false);
      }
    }
  }
}
