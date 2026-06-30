import 'package:flutter/material.dart';
import 'package:sims_denny/models/transaction/transaction_history.dart';
import 'package:sims_denny/services/transaction_service.dart';
import 'package:sims_denny/utils/shared.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionHistory> transaction = [];
  Status status = Status.loading;
  String errorMessage = '';
  bool hasNextPage = true;
  int offset = 0;
  int limit = 5;

  void getTransaction(BuildContext context) async {
    offset = 0;
    hasNextPage = true;
    status = Status.loading;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    final response =
        await TransactionService().getHistoryTransaction(offset, limit);
    if (response?.status == 0) {
      offset += limit;
      transaction = response!.data!;
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

  void loadMoreTransaction(BuildContext context) async {
    status = Status.loadingMore;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    final response =
        await TransactionService().getHistoryTransaction(offset, limit);
    if (response?.status == 0) {
      if (response?.data?.isEmpty ?? false) {
        hasNextPage = false;
      }
      offset += limit;
      transaction.addAll(response!.data!);
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
