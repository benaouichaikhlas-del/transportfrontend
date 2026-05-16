import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class AdminService {
  Future<List<dynamic>> getDemandes(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConstants.adminDemandes),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> accepter(String token, int id) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConstants.adminDemandes}/$id/accepter'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  Future<Map<String, dynamic>> refuser(String token, int id) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConstants.adminDemandes}/$id/refuser'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }
}
