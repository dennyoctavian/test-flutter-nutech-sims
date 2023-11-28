import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:sims_denny/provider/user_provider.dart';

class Shared {
  static String url = "https://take-home-test-api.nutech-integrasi.app";
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
    // Get the size of the file in bytes
    int fileSize = await imageFile.length();

    // Convert bytes to kilobytes
    double fileSizeKB = fileSize / 1024;

    // Check if the file size is within the specified limit
    if (fileSizeKB <= maxSizeKB) {
      return true; // Valid size
    } else {
      return false; // Size exceeds the limit
    }
  }

  static Future<void> changeImageProfile(
      BuildContext context, UserProvider value) async {
    XFile? mediaFileList;
    File? image;
    final ImagePicker picker = ImagePicker();
    mediaFileList = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (mediaFileList != null) {
      if ((mediaFileList.path.split('/').last.toLowerCase().contains(".jpg")) ||
          (mediaFileList.path.split('/').last.toLowerCase().contains(".jpeg") ||
              (mediaFileList.path
                  .split('/')
                  .last
                  .toLowerCase()
                  .contains(".png")))) {
        image = File(mediaFileList.path);
        bool isLimit = await Shared.isImageSizeValid(image, 100);
        if (!isLimit) {
          // ignore: use_build_context_synchronously
          showSnackBar(context, "Ukuran gambar terlalu besar Max 100kb");
        } else {
          // ignore: use_build_context_synchronously
          value.updateProfilePicture(image, context);
        }
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "File harus .jpg atau .png atau .jpeg");
      }
    }
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

showSnackBar(BuildContext context, String message, {bool isSuccess = false}) {
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
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  ));
}
