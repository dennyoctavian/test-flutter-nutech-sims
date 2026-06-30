import 'package:sims_denny/models/information/banner_response.dart';
import 'package:sims_denny/models/information/service_response.dart';
import 'package:sims_denny/services/base_service.dart';
import 'package:sims_denny/utils/constants.dart';

class InformationService extends BaseService {
  Future<BannerResponse> getBanner() async {
    return safeApiCall(
      apiCall: () => dio.get(ApiConstants.banner),
      fromMap: (data) => BannerResponse.fromMap(data),
      fallback: (status, message) =>
          BannerResponse(status: status, message: message),
    );
  }

  Future<ServiceResponse> getService() async {
    return safeApiCall(
      apiCall: () => dio.get(ApiConstants.services),
      fromMap: (data) => ServiceResponse.fromMap(data),
      fallback: (status, message) =>
          ServiceResponse(status: status, message: message),
    );
  }
}
