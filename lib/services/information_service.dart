import 'package:dio/dio.dart';
import 'package:sims_denny/models/information/banner_response.dart';
import 'package:sims_denny/models/information/service_response.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';

class InformationService {
  final dio = Dio();
  Future<BannerResponse?> getBanner() async {
    try {
      String? token = await Session.getToken();
      final response = await dio.get(
        "${Shared.url}/banner",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return BannerResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return BannerResponse.fromMap(e.response?.data);
        }
      }
      return BannerResponse(status: 500, message: e.toString());
    }
  }

  Future<ServiceResponse?> getService() async {
    try {
      String? token = await Session.getToken();
      final response = await dio.get(
        "${Shared.url}/services",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return ServiceResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return ServiceResponse.fromMap(e.response?.data);
        }
      }
      return ServiceResponse(status: 500, message: e.toString());
    }
  }
}
