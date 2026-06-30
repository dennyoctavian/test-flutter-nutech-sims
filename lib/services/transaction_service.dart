import 'package:dio/dio.dart';
import 'package:sims_denny/models/transaction/balance_response.dart';
import 'package:sims_denny/models/transaction/transaction_history_response.dart';
import 'package:sims_denny/models/transaction/transaction_response.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';

class TransactionService {
  final dio = Dio();
  Future<BalanceResponse?> getBalance() async {
    try {
      String? token = await Session.getToken();
      final response = await dio.get(
        "${Shared.url}/balance",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return BalanceResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return BalanceResponse.fromMap(e.response?.data);
        }
      }
      return BalanceResponse(status: 500, message: e.toString());
    }
  }

  Future<BalanceResponse?> topup(int totalAmount) async {
    try {
      String? token = await Session.getToken();
      final response = await dio.post(
        "${Shared.url}/topup",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: {"top_up_amount": totalAmount},
      );
      return BalanceResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return BalanceResponse.fromMap(e.response?.data);
        }
      }
      return BalanceResponse(status: 500, message: e.toString());
    }
  }

  Future<TransactionResponse?> createTransaction(String serviceCode) async {
    try {
      String? token = await Session.getToken();
      final response = await dio.post(
        "${Shared.url}/transaction",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: {"service_code": serviceCode},
      );
      print(response.data);
      return TransactionResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return TransactionResponse.fromMap(e.response?.data);
        }
      }
      return TransactionResponse(status: 500, message: e.toString());
    }
  }

  Future<TransactionHistoryResponse?> getHistoryTransaction(
      int offset, int limit) async {
    try {
      String? token = await Session.getToken();
      final response = await dio.get(
        "${Shared.url}/transaction/history?offset=$offset&limit=$limit",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return TransactionHistoryResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return TransactionHistoryResponse.fromMap(e.response?.data);
        }
      }
      return TransactionHistoryResponse(status: 500, message: e.toString());
    }
  }
}
