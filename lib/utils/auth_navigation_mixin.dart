import 'package:flutter/material.dart';
import 'package:sims_denny/utils/constants.dart';

/// Mixin to handle common auth-related navigation in pages.
mixin AuthNavigationMixin<T extends StatefulWidget> on State<T> {
  void handleUnauthorized(int? statusCode) {
    if (statusCode == ApiConstants.unauthorized && mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}
