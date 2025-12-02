import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  static const String _baseUrl = 'https://bayarbuddy.my.id';
  static const String _sendToUserEndpoint = '/api/notifications/send-to-user';

  /// Send notification to specific user
  ///
  /// Parameters:
  /// - userId: The user ID to send notification to
  /// - title: The notification title
  /// - body: The notification message body
  ///
  /// Returns a map with the response data
  Future<Map<String, dynamic>> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$_sendToUserEndpoint');

      final requestBody = {'user_id': userId, 'title': title, 'body': body};

      debugPrint('Sending notification to: $url');
      debugPrint('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        throw Exception('Failed to send notification. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
      rethrow;
    }
  }

  /// Send notification with additional data payload
  ///
  /// Parameters:
  /// - userId: The user ID to send notification to
  /// - title: The notification title
  /// - body: The notification message body
  /// - data: Additional data to include in notification (for full intent)
  ///
  /// Returns a map with the response data
  Future<Map<String, dynamic>> sendNotificationWithData({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$_sendToUserEndpoint');

      final requestBody = {'user_id': userId, 'title': title, 'body': body, if (data != null) 'data': data};

      debugPrint('Sending notification with data to: $url');
      debugPrint('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        throw Exception('Failed to send notification. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification with data: $e');
      rethrow;
    }
  }
}
