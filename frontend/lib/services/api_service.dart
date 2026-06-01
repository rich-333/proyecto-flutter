import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use different base URL depending on platform (web vs emulator/device)
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    return 'http://10.0.2.2:8000/api';
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static int _parseIntValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsedInt = int.tryParse(value);
      if (parsedInt != null) return parsedInt;
      final parsedDouble = double.tryParse(value);
      return parsedDouble?.toInt() ?? 0;
    }
    return 0;
  }

  static double _parseDoubleValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Passenger Auth
  static Future<Map<String, dynamic>> loginPassenger(String email, String password) async {
    final url = Uri.parse('$baseUrl/passenger/login');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // Passenger Auth - Register
  static Future<Map<String, dynamic>> registerPassenger({
    required String fullName,
    required String ci,
    required String phone,
    required String email,
    required String password,
    required String birthDate,
    required String userType,
    String? documentImage,
    Uint8List? documentImageBytes,
  }) async {
    final url = Uri.parse('$baseUrl/passenger/register');
    
    var request = http.MultipartRequest('POST', url);
    request.fields['full_name'] = fullName;
    request.fields['ci'] = ci;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['birth_date'] = birthDate;
    request.fields['user_type'] = userType;

    if (documentImageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('document_image', documentImageBytes, filename: 'document.jpg'),
      );
    } else if (documentImage != null && documentImage.isNotEmpty && !kIsWeb) {
      request.files.add(
        await http.MultipartFile.fromPath('document_image', documentImage),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

  // Passenger Data
  static Future<Map<String, dynamic>> getPassengerHistory(String month, String year) async {
    final url = Uri.parse('$baseUrl/passenger/history?month=$month&year=$year');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPassengerBalance() async {
    final url = Uri.parse('$baseUrl/passenger/balance');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPassengerRecentActivity() async {
    final url = Uri.parse('$baseUrl/passenger/recent-activity');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> previewPayment(String qrData) async {
    final url = Uri.parse('$baseUrl/passenger/preview-payment');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'qr_data': qrData}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> payTrip(String qrData) async {
    final url = Uri.parse('$baseUrl/passenger/pay-trip');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'qr_data': qrData}),
    );
    return jsonDecode(response.body);
  }

  // Driver Auth
  static Future<Map<String, dynamic>> loginDriver(String driverCode) async {
    final url = Uri.parse('$baseUrl/driver/login');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'driver_code': driverCode}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> logoutDriver() async {
    final url = Uri.parse('$baseUrl/driver/logout');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
    );
    await deleteToken();
    return jsonDecode(response.body);
  }

  // Summary Metrics
  static Future<Map<String, dynamic>> getDailyPassengers() async {
    final url = Uri.parse('$baseUrl/driver/summary/passengers');
    final response = await http.get(url, headers: await _getHeaders());
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (result['status'] != true) {
      throw Exception(result['message'] ?? 'Error cargando pasajeros diarios');
    }
    result['data'] = _parseIntValue(result['data']);
    return result;
  }

  static Future<Map<String, dynamic>> getDailyCollected() async {
    final url = Uri.parse('$baseUrl/driver/summary/collected');
    final response = await http.get(url, headers: await _getHeaders());
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (result['status'] != true) {
      throw Exception(result['message'] ?? 'Error cargando total recaudado');
    }
    result['data'] = _parseDoubleValue(result['data']);
    return result;
  }

  static Future<Map<String, dynamic>> getBreakdown() async {
    final url = Uri.parse('$baseUrl/driver/summary/breakdown');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getRecentPayments() async {
    final url = Uri.parse('$baseUrl/driver/payments/recent');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  // Notifications
  static Future<Map<String, dynamic>> getUnreadNotifications() async {
    final url = Uri.parse('$baseUrl/driver/notifications/unread');
    final response = await http.get(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(int id) async {
    final url = Uri.parse('$baseUrl/driver/notifications/$id/read');
    final response = await http.post(url, headers: await _getHeaders());
    return jsonDecode(response.body);
  }
}
