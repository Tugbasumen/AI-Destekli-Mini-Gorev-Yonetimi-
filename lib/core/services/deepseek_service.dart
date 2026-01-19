import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _baseUrl = "http://192.168.1.103:5000";
  // Android emulator için: http://10.0.2.2:5000
  // Gerçek cihazdaysan: http://BILGISAYAR_IP:5000

  Future<String> getTaskRecommendation(
    String taskTitle, {
    String category = "genel",
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/get_ai_suggestion"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"task": taskTitle, "category": category}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["suggestion"] ?? "Öneri alınamadı.";
      } else {
        throw Exception("API Hatası: Status ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }
}
