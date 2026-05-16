import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../core/constants/api_constants.dart';
import '../providers/auth_provider.dart';

class AffectationScreen extends StatefulWidget {
  const AffectationScreen({super.key});
  @override
  State<AffectationScreen> createState() => _AffectationScreenState();
}

class _AffectationScreenState extends State<AffectationScreen> {
  List<dynamic> _affectations = [];
  List<dynamic> _conducteurs = [];
  List<dynamic> _vehicules = [];
  List<dynamic> _lignes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String get _token => context.read<AuthProvider>().user!.token;

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        http.get(
          Uri.parse(ApiConstants.affectati1ons),
          headers: {'Authorization': 'Bearer $_token'},
        ),
        http.get(
          Uri.parse(ApiConstants.conducteurs),
          headers: {'Authorization': 'Bearer $_token'},
        ),
        http.get(
          Uri.parse(ApiConstants.vehicules),
          headers: {'Authorization': 'Bearer $_token'},
        ),
        http.get(
          Uri.parse(ApiConstants.lignes),
          headers: {'Authorization': 'Bearer $_token'},
        ),
      ]);
      setState(() {
        _affectations = jsonDecode(results[0].body);
        _conducteurs = jsonDecode(results[1].body);
        _vehicules = jsonDecode(results[2].body);
        _lignes = jsonDecode(results[3].body);
      });
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _showAjouterDialog() async {
    int? selectedConducteur;
    int? selectedVehicule;
    int? selectedLigne;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.link, color: AppTheme.primary),
              SizedBox(width: 8),
              Text(
                'Nouvelle affectation',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dropdown(
                'Conducteur',
                _conducteurs
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['id'] as int,
                        child: Text(
                          '${c['nom']} ${c['prenom'] ?? ''}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                selectedConducteur,
                (v) => setS(() => selectedConducteur = v),
              ),
              const SizedBox(height: 10),
              _dropdown(
                'Véhicule',
                _vehicules
                    .map(
                      (v) => DropdownMenuItem(
                        value: v['id'] as int,
                        child: Text(
                          '${v['marque']} — ${v['immatriculation']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                selectedVehicule,
                (v) => setS(() => selectedVehicule = v),
              ),
              const SizedBox(height: 10),
              _dropdown(
                'Ligne (optionnel)',
                _lignes
                    .map(
                      (l) => DropdownMenuItem(
                        value: l['id'] as int,
                        child: Text(
                          l['numero'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                selectedLigne,
                (v) => setS(() => selectedLigne = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedConducteur == null || selectedVehicule == null)
                  return;
                Navigator.pop(ctx);
                final r = await http.post(
                  Uri.parse(ApiConstants.affectati1ons),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $_token',
                  },
                  body: jsonEncode({
                    'conducteur_id': selectedConducteur,
                    'vehicule_id': selectedVehicule,
                    'ligne_id': selectedLigne,
                  }),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(jsonDecode(r.body)['message']),
                    backgroundColor: r.statusCode == 201
                        ? Colors.green
                        : Colors.red,
                  ),
                );
                if (r.statusCode == 201) _load();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Affecter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<DropdownMenuItem<int>> items,
    int? value,
    void Function(int?) onChanged,
  ) {
    return DropdownButtonFormField<int>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: AppTheme.background,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Affectations',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${_affectations.length} affectation(s)',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _load,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_affectation',
        onPressed: _showAjouterDialog,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.link, color: Colors.white),
        label: const Text('Affecter', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _affectations.isEmpty
          ? const Center(
              child: Text(
                'Aucune affectation',
                style: TextStyle(color: Colors.white38),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _affectations.length,
              itemBuilder: (_, i) {
                final a = _affectations[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.link,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${a['conducteur_nom']} ${a['conducteur_prenom'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${a['marque']} — ${a['immatriculation']}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            if (a['ligne_numero'] != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Ligne ${a['ligne_numero']}',
                                  style: const TextStyle(
                                    color: AppTheme.secondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () async {
                          final r = await http.delete(
                            Uri.parse(
                              '${ApiConstants.affectati1ons}/${a['id']}',
                            ),
                            headers: {'Authorization': 'Bearer $_token'},
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(jsonDecode(r.body)['message']),
                              backgroundColor: r.statusCode == 200
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                          if (r.statusCode == 200) _load();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
