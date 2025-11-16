import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';

class JwTUtil {
  final SecretKey secretKey = SecretKey('Ubm61RY8kZ7wFVnoUUBUbJMpC2i6gH77');

  String? getUserIdFromToken(String token) {
    try {
      final jwt = JWT.verify(token, secretKey);
      return jwt.payload['id'] as String?;
    } catch (e) {
      return null;
    }
  }

  String generateJwtFromJson(Map<String, dynamic> json) {
    //make JWT from json (payload)
    final jwt = JWT(json);

    //sign with secret key
    final token = jwt.sign(secretKey);

    return token;
  }

  Map<String, dynamic> decodeJwt(String token) {
    try {
      //verification and decode token
      final jwt = JWT.verify(token, secretKey);

      //take the payload as Map<String, dynamic>
      return jwt.payload;
    } catch (e) {
      debugPrint('Error decoding JWT: $e');
      throw Exception('Error decoding JWT: $e');
    }
  }
}
