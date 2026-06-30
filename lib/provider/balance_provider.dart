import 'package:flutter/material.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/services/transaction_service.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/shared.dart';

class BalanceProvider extends ChangeNotifier {
  int balance = 0;
  Status statusBalance = Status.loading;
  String errorMessage = '';

  final _transactionService = TransactionService();

  Future<int?> getBalance() async {
    statusBalance = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response = await _transactionService.getBalance();
    if (response.status == ApiConstants.success) {
      balance = response.data?.balance ?? 0;
      statusBalance = Status.success;
      notifyListeners();
      return ApiConstants.success;
    } else {
      if (response.status == ApiConstants.unauthorized) {
        statusBalance = Status.error;
        notifyListeners();
        return ApiConstants.unauthorized;
      } else {
        statusBalance = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return response.status;
      }
    }
  }

  Future<({bool success, int? statusCode, int amount})> topup(
      int totalAmount) async {
    statusBalance = Status.loading;
    notifyListeners();

    final response = await _transactionService.topup(totalAmount);
    if (response.status == ApiConstants.success) {
      statusBalance = Status.success;
      balance = response.data?.balance ?? 0;
      notifyListeners();
      return (
        success: true,
        statusCode: response.status,
        amount: totalAmount
      );
    } else {
      if (response.status == ApiConstants.unauthorized) {
        statusBalance = Status.error;
        notifyListeners();
        return (
          success: false,
          statusCode: ApiConstants.unauthorized,
          amount: totalAmount
        );
      } else {
        statusBalance = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return (
          success: false,
          statusCode: response.status,
          amount: totalAmount
        );
      }
    }
  }

  Future<({bool success, int? statusCode})> payment(Service service) async {
    statusBalance = Status.loading;
    notifyListeners();

    final response = await _transactionService
        .createTransaction(service.serviceCode ?? '');
    if (response.status == ApiConstants.success) {
      statusBalance = Status.success;
      balance -= response.data?.totalAmount ?? 0;
      notifyListeners();
      return (success: true, statusCode: response.status);
    } else {
      if (response.status == ApiConstants.unauthorized) {
        statusBalance = Status.error;
        notifyListeners();
        return (success: false, statusCode: ApiConstants.unauthorized);
      } else {
        statusBalance = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return (success: false, statusCode: response.status);
      }
    }
  }
}
