
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/hotel.dart';
import '../models/destination.dart';

class ApiService {
  // Override when launching with --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
  // Android Emulator: 10.0.2.2 reaches the host computer.
  // Windows desktop / Chrome: use http://127.0.0.1:8000/api.
  // A physical phone needs your computer's LAN IP address.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );


  static const Duration timeout = Duration(seconds: 15);

  Future<List<Hotel>> getHotels() async {
    final response = await http
        .get(Uri.parse('$baseUrl/hotels'))
        .timeout(timeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data =
      decoded is List ? decoded : decoded['data'] as List<dynamic>;

      return data
          .map((item) => Hotel.fromJson(
        Map<String, dynamic>.from(item as Map),
      ))
          .toList();
    }

    throw Exception('Failed to load hotels: ${response.statusCode}');
  }

  Future<List<Destination>> getDestinations() async {
    final response = await http
        .get(Uri.parse('$baseUrl/destinations'))
        .timeout(timeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data =
      decoded is List ? decoded : decoded['data'] as List<dynamic>;

      return data
          .map((item) => Destination.fromJson(
        Map<String, dynamic>.from(item as Map),
      ))
          .toList();
    }

    throw Exception(
      'Failed to load destinations: ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> generateItinerary({
    required String destination,
    required int days,
    required String interests,
  }) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/itineraries'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'destination': destination,
        'days': days,
        'interests': interests,
      }),
    )
        .timeout(timeout);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body) as Map,
      );
    }

    throw Exception(
      'Failed to generate itinerary: ${response.statusCode}',
    );
  }
}
