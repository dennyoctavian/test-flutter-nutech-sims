import 'package:dio/dio.dart';
import 'package:sims_denny/services/dio_client.dart';
import 'package:sims_denny/utils/constants.dart';

/// Base service class that provides shared Dio instance and error handling.
abstract class BaseService {
  final Dio dio = DioClient.instance;

  /// Wraps API calls with consistent error handling.
  /// [apiCall] - the actual API call to execute
  /// [fromMap] - factory to parse success/error response body
  /// [fallback] - factory to create a fallback response on network/unknown errors
  Future<T> safeApiCall<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic> data) fromMap,
    required T Function(int status, String message) fallback,
  }) async {
    try {
      final response = await apiCall();
      return fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        return fromMap(e.response!.data);
      }
      return fallback(ApiConstants.internalError, e.message ?? 'Network error');
    } catch (e) {
      return fallback(ApiConstants.internalError, e.toString());
    }
  }
}
