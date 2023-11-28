import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sims_denny/models/member/login_response.dart';
import 'package:sims_denny/models/member/member_response.dart';
import 'package:sims_denny/models/request_body/register_body.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:http_parser/http_parser.dart';

class MemberService {
  final dio = Dio();

  Future<MemberResponse?> register(RegisterBody registerBody) async {
    try {
      final response = await dio.post(
        "${Shared.url}/registration",
        data: registerBody.toMap(),
      );
      return MemberResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return MemberResponse.fromMap(e.response?.data);
        }
      }
      return MemberResponse(status: 500, message: e.toString(), data: null);
    }
  }

  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await dio.post(
        "${Shared.url}/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      return LoginResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return LoginResponse.fromMap(e.response?.data);
        }
      }
      return LoginResponse(status: 500, message: e.toString());
    }
  }

  Future<MemberResponse?> getProfile() async {
    try {
      String? token = await Session.getToken();
      final response = await dio.get(
        "${Shared.url}/profile",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return MemberResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return MemberResponse.fromMap(e.response?.data);
        }
      }
      return MemberResponse(status: 500, message: e.toString());
    }
  }

  Future<MemberResponse?> updateProfile(
      String firstName, String lastName) async {
    try {
      String? token = await Session.getToken();
      final response = await dio.put(
        "${Shared.url}/profile/update",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
        data: {
          "first_name": firstName,
          "last_name": lastName,
        },
      );
      return MemberResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return MemberResponse.fromMap(e.response?.data);
        }
      }
      return MemberResponse(status: 500, message: e.toString());
    }
  }

  Future<MemberResponse?> updateProfileImage(File file) async {
    try {
      String? token = await Session.getToken();
      String fileName = file.path.split('/').last;
      var fileExt = fileName.split('.').last;
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", fileExt),
        ),
      });
      final response = await dio.put(
        "${Shared.url}/profile/image",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            // "Content-Type": "multipart/form-data",
          },
        ),
        data: formData,
      );
      return MemberResponse.fromMap(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return MemberResponse.fromMap(e.response?.data);
        }
      }
      return MemberResponse(status: 500, message: e.toString());
    }
  }
}
