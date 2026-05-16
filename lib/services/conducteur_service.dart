import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class ConducteurService {
  // ===================== GET =====================
  Future<List<dynamic>> getConducteurs(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConstants.conducteurs),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print("GET ERROR: ${response.statusCode} ${response.body}");
      return [];
    } catch (e) {
      print("GET EXCEPTION: $e");
      return [];
    }
  }

  // ===================== ADD =====================
  Future<Map<String, dynamic>> ajouterConducteur({
    required String token,
    required String nom,
    required String prenom,
    required String tel,
    required String numPermis,
    required String adresse,
    required String email,
    required String motDePasse,
  }) async {
    try {
      final url = ApiConstants.conducteurs;

      final body = jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'telephone': tel,
        'num_permis': numPermis,
        'adresse': adresse,
        'email': email,
        'mot_de_passe': motDePasse,
      });

      print("=== AJOUT CONDUCTEUR ===");
      print("URL: $url");
      print("BODY: $body");

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? 'OK',
      };
    } catch (e) {
      print("ADD ERROR: $e");
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // ===================== ✏️ UPDATE (NEW) =====================
  Future<Map<String, dynamic>> modifierConducteur({
    required String token,
    required int id,
    required String nom,
    required String prenom,
    required String tel,
    required String numPermis,
    required String adresse,
    required String email,
  }) async {
    try {
      final url = '${ApiConstants.conducteurs}/$id';

      final body = jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'telephone': tel,
        'num_permis': numPermis,
        'adresse': adresse,
        'email': email,
      });

      print("=== MODIFIER CONDUCTEUR ===");
      print("URL: $url");
      print("BODY: $body");

      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'OK',
      };
    } catch (e) {
      print("UPDATE ERROR: $e");
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // ===================== DELETE =====================
  Future<Map<String, dynamic>> supprimerConducteur(String token, int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConstants.conducteurs}/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'OK',
      };
    } catch (e) {
      print("DELETE ERROR: $e");
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }
}
