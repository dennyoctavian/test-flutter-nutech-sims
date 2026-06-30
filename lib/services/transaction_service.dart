import 'package:sims_denny/models/transaction/balance_response.dart';
import 'package:sims_denny/models/transaction/transaction_history_response.dart';
import 'package:sims_denny/models/transaction/transaction_response.dart';
import 'package:sims_denny/services/base_service.dart';
import 'package:sims_denny/utils/constants.dart';

class TransactionService extends BaseService {
  Future<BalanceResponse> getBalance() async {
    return safeApiCall(
      apiCall: () => dio.get(ApiConstants.balance),
      fromMap: (data) => BalanceResponse.fromMap(data),
      fallback: (status, message) =>
          BalanceResponse(status: status, message: message),
    );
  }

  Future<BalanceResponse> topup(int totalAmount) async {
    return safeApiCall(
      apiCall: () => dio.post(
        ApiConstants.topup,
        data: {"top_up_amount": totalAmount},
      ),
      fromMap: (data) => BalanceResponse.fromMap(data),
      fallback: (status, message) =>
          BalanceResponse(status: status, message: message),
    );
  }

  Future<TransactionResponse> createTransaction(String serviceCode) async {
    return safeApiCall(
      apiCall: () => dio.post(
        ApiConstants.transaction,
        data: {"service_code": serviceCode},
      ),
      fromMap: (data) => TransactionResponse.fromMap(data),
      fallback: (status, message) =>
          TransactionResponse(status: status, message: message),
    );
  }

  Future<TransactionHistoryResponse> getHistoryTransaction(
      int offset, int limit) async {
    return safeApiCall(
      apiCall: () => dio.get(
        '${ApiConstants.transactionHistory}?offset=$offset&limit=$limit',
      ),
      fromMap: (data) => TransactionHistoryResponse.fromMap(data),
      fallback: (status, message) =>
          TransactionHistoryResponse(status: status, message: message),
    );
  }
}
