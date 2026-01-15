import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gorev_yonetimi/core/constants/app_constants.dart';
import 'package:gorev_yonetimi/core/errors/app_exceptions.dart';

/// DeepSeek AI servisi ile iletişim kuran servis sınıfı
class DeepSeekService {
  final String baseUrl;
  final Duration timeout;

  DeepSeekService({String? baseUrl, Duration? timeout})
    : baseUrl = baseUrl ?? AppConstants.aiServiceBaseUrl,
      timeout = timeout ?? AppConstants.apiTimeout;

  /// Belirli bir görev ve kategori için AI tabanlı öneri alır
  Future<String> getTaskRecommendation(
    String taskTitle, {
    String category = "genel",
  }) async {
    // Görev başlığı kontrolü
    if (taskTitle.trim().isEmpty) {
      throw ValidationException('Task title cannot be empty');
    }

    try {
      final uri = Uri.parse('$baseUrl${AppConstants.aiServiceEndpoint}');

      // API isteği gönderiliyor
      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"task": taskTitle, "category": category}),
          )
          .timeout(timeout);
      // Yanıt başarılı
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final suggestion = data["suggestion"] as String?;
        if (suggestion == null || suggestion.isEmpty) {
          throw ApiException('API\'den boş öneri alındı');
        }
        return suggestion;
      } else {
        // Sunucu hata döndürdüğünde
        throw ApiException(
          'API isteği başarısız oldu (Hata Kodu: ${response.statusCode}',
          response.body,
        );
      }
    } on http.ClientException catch (e) {
      // Bağlantı hataları
      throw NetworkException('Ağ bağlantısı başarısız oldu: ${e.message}', e);
    } on FormatException catch (e) {
      // JSON ayrıştırma hataları
      throw ApiException('Geçersiz yanıt formatı: ${e.message}', e);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw NetworkException('Beklenmeyen bir hata oluştu: ${e.toString()}', e);
    }
  }
}
