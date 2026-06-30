import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sims_denny/models/member/user.dart';
import 'package:sims_denny/services/member_service.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/shared.dart';

class ProfileProvider extends ChangeNotifier {
  User user = User();
  Status status = Status.loading;
  String errorMessage = '';

  final _memberService = MemberService();

  Future<int?> getProfile() async {
    status = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final response = await _memberService.getProfile();
    if (response.status == ApiConstants.success) {
      user = response.data!;
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

  Future<({bool success, String message, int? statusCode})> updateProfile(
      String firstName, String lastName) async {
    status = Status.loading;
    notifyListeners();

    final response = await _memberService.updateProfile(firstName, lastName);
    if (response.status == ApiConstants.success) {
      user = response.data!;
      status = Status.success;
      notifyListeners();
      return (
        success: true,
        message: response.message ?? '',
        statusCode: response.status
      );
    } else {
      if (response.status == ApiConstants.unauthorized) {
        status = Status.error;
        notifyListeners();
        return (
          success: false,
          message: response.message ?? '',
          statusCode: ApiConstants.unauthorized
        );
      } else {
        status = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return (
          success: false,
          message: response.message ?? '',
          statusCode: response.status
        );
      }
    }
  }

  Future<({bool success, String message, int? statusCode})>
      updateProfilePicture(File file) async {
    status = Status.loading;
    notifyListeners();

    final response = await _memberService.updateProfileImage(file);
    if (response.status == ApiConstants.success) {
      user = response.data!;
      status = Status.success;
      notifyListeners();
      return (
        success: true,
        message: response.message ?? '',
        statusCode: response.status
      );
    } else {
      if (response.status == ApiConstants.unauthorized) {
        status = Status.error;
        notifyListeners();
        return (
          success: false,
          message: response.message ?? '',
          statusCode: ApiConstants.unauthorized
        );
      } else {
        status = Status.error;
        errorMessage = response.message ?? '';
        notifyListeners();
        return (
          success: false,
          message: response.message ?? '',
          statusCode: response.status
        );
      }
    }
  }
}
