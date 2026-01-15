class AppConstants {
  AppConstants._();

  // API Configuration
  static const String aiServiceBaseUrl = "http://192.168.1.104:5000";
  static const String aiServiceEndpoint = "/get_ai_suggestion";

  // Android emulator için: http://10.0.2.2:5000
  // Gerçek cihazdaysan: http://BILGISAYAR_IP:5000

  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 90);

  // Task Validation
  static const int minTaskTitleLength = 1;
  static const int maxTaskTitleLength = 200;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
}
