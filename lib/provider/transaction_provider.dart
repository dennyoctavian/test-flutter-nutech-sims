import 'package:flutter/material.dart';
import 'package:sims_denny/models/transaction/transaction_history.dart';
import 'package:sims_denny/services/transaction_service.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/shared.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionHistory> transaction = [];
  Status status = Status.loading;
  String errorMessage = '';
  bool hasNextPage = true;
  int offset = 0;
  int limit = 5;

  final _transactionService = TransactionService();

  Future<int?> getTransaction() async {
    offset = 0;
    hasNextPage = true;
    status = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response =
        await _transactionService.getHistoryTransaction(offset, limit);
    if (response.status == ApiConstants.success) {
      offset += limit;
      transaction = response.data ?? [];
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

  Future<int?> loadMoreTransaction() async {
    status = Status.loadingMore;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response =
        await _transactionService.getHistoryTransaction(offset, limit);
    if (response.status == ApiConstants.success) {
      if (response.data?.isEmpty ?? true) {
        hasNextPage = false;
      }
      offset += limit;
      transaction.addAll(response.data ?? []);
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
