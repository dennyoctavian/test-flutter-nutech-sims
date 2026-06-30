class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://take-home-test-api.nutech-integrasi.app';

  // API Status Codes
  static const int success = 0;
  static const int unauthorized = 108;
  static const int internalError = 500;

  // Endpoints
  static const String registration = '/registration';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String profileUpdate = '/profile/update';
  static const String profileImage = '/profile/image';
  static const String balance = '/balance';
  static const String topup = '/topup';
  static const String transaction = '/transaction';
  static const String transactionHistory = '/transaction/history';
  static const String banner = '/banner';
  static const String services = '/services';
}

class AppStrings {
  AppStrings._();

  // Validation messages
  static const String fieldRequired = 'Field ini wajib diisi';
  static const String invalidEmail = 'Masukkan email yang valid';
  static const String passwordMismatch = 'Password tidak sama';
  static const String minTopup = 'Minimal Top Up Rp 10.000';
  static const String maxTopup = 'Maksimal Top Up Rp 1.000.000';
  static const String imageTooLarge = 'Ukuran gambar terlalu besar Max 100kb';
  static const String invalidImageFormat = 'File harus .jpg atau .png atau .jpeg';

  // Null profile image URL pattern
  static const String nullProfileImageUrl =
      'https://minio.nutech-integrasi.app/take-home-test/null';
}
