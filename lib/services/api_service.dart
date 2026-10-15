
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/hotel.dart';
import '../models/destination.dart';

class ApiService {
  // Android Emulator: use 10.0.2.2 for your computer's localhost.
  // Windows desktop: use localhost if the backend runs on your PC.
  static const String baseUrl = 'http://10.0.2.2:8000/api';

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
