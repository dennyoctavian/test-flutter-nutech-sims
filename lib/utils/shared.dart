import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:sims_denny/provider/profile_provider.dart';
import 'package:sims_denny/utils/constants.dart';

class Shared {
  static RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
  static var formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  static formatDate(DateTime myDate) {
    String formattedDate =
        DateFormat('dd MMMM yyyy HH:mm z', 'id_ID').format(myDate);
    return formattedDate;
  }

  static Future<bool> isImageSizeValid(File imageFile, int maxSizeKB) async {
    int fileSize = await imageFile.length();
    double fileSizeKB = fileSize / 1024;
    return fileSizeKB <= maxSizeKB;
  }

  /// Pick and validate image, then call provider to upload.
  /// Returns result record for the widget to handle navigation/snackbar.
  static Future<({bool success, String message, int? statusCode})?> changeImageProfile(
      ProfileProvider profileProvider) async {
    XFile? mediaFileList;
    File? image;
    final ImagePicker picker = ImagePicker();
    mediaFileList = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (mediaFileList != null) {
      final fileName = mediaFileList.path.split('/').last.toLowerCase();
      if (fileName.contains(".jpg") ||
          fileName.contains(".jpeg") ||
          fileName.contains(".png")) {
        image = File(mediaFileList.path);
        bool isLimit = await Shared.isImageSizeValid(image, 100);
        if (!isLimit) {
          return (
            success: false,
            message: AppStrings.imageTooLarge,
            statusCode: null
          );
        } else {
          return await profileProvider.updateProfilePicture(image);
        }
      } else {
        return (
          success: false,
          message: AppStrings.invalidImageFormat,
          statusCode: null
        );
      }
    }
    return null;
  }
}

enum Status { loading, success, error, loadingMore }

TextStyle logoTextStyle = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
TextStyle titleTextStyle = GoogleFonts.poppins(
  fontSize: 25,
  fontWeight: FontWeight.w700,
);
TextStyle linkTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Colors.red,
);
TextStyle normalTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.grey,
);

TextStyle titleHeader = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

TextStyle backHeader = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

void showSnackBar(BuildContext context, String message,
    {bool isSuccess = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 30,
    ),
    content: Text(
      message,
      style: normalTextStyle.copyWith(
        color: isSuccess ? Colors.green : Colors.red,
      ),
    ),
    backgroundColor: isSuccess ? Colors.green[50] : Colors.red[50],
    action: SnackBarAction(
      label: 'x',
      textColor: isSuccess ? Colors.green : Colors.red,
      onPressed: () {},
    ),
  ));
}
