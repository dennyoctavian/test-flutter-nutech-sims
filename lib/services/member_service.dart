import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sims_denny/models/member/login_response.dart';
import 'package:sims_denny/models/member/member_response.dart';
import 'package:sims_denny/models/request_body/register_body.dart';
import 'package:sims_denny/services/base_service.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class MemberService extends BaseService {
  Future<MemberResponse> register(RegisterBody registerBody) async {
    return safeApiCall(
      apiCall: () => dio.post(
        ApiConstants.registration,
        data: registerBody.toMap(),
      ),
      fromMap: (data) => MemberResponse.fromMap(data),
      fallback: (status, message) =>
          MemberResponse(status: status, message: message, data: null),
    );
  }

  Future<LoginResponse> login(String email, String password) async {
    return safeApiCall(
      apiCall: () => dio.post(
        ApiConstants.login,
        data: {"email": email, "password": password},
      ),
      fromMap: (data) => LoginResponse.fromMap(data),
      fallback: (status, message) =>
          LoginResponse(status: status, message: message),
    );
  }

  Future<MemberResponse> getProfile() async {
    return safeApiCall(
      apiCall: () => dio.get(ApiConstants.profile),
      fromMap: (data) => MemberResponse.fromMap(data),
      fallback: (status, message) =>
          MemberResponse(status: status, message: message, data: null),
    );
  }

  Future<MemberResponse> updateProfile(
      String firstName, String lastName) async {
    return safeApiCall(
      apiCall: () => dio.put(
        ApiConstants.profileUpdate,
        data: {"first_name": firstName, "last_name": lastName},
      ),
      fromMap: (data) => MemberResponse.fromMap(data),
      fallback: (status, message) =>
          MemberResponse(status: status, message: message, data: null),
    );
  }

  Future<MemberResponse> updateProfileImage(File file) async {
    String fileName = file.path.split('/').last;
    var fileExt = fileName.split('.').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType("image", fileExt),
      ),
    });

    return safeApiCall(
      apiCall: () => dio.put(
        ApiConstants.profileImage,
        data: formData,
      ),
      fromMap: (data) => MemberResponse.fromMap(data),
      fallback: (status, message) =>
          MemberResponse(status: status, message: message, data: null),
    );
  }
}
