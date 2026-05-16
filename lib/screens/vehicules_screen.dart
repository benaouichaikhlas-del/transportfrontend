import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../core/constants/api_constants.dart';
import '../providers/auth_provider.dart';

class VehiculesScreen extends StatefulWidget {
  const VehiculesScreen({super.key});
  @override
  State<VehiculesScreen> createState() => _VehiculesScreenState();
}

class _VehiculesScreenState extends State<VehiculesScreen> {
  List<dynamic> _vehicules = [];
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
      final r = await http.get(
        Uri.parse(ApiConstants.vehicules),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (r.statusCode == 200) setState(() => _vehicules = jsonDecode(r.body));
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _showAjouterDialog({Map? vehicule}) async {
    final marqueCtrl = TextEditingController(text: vehicule?['marque'] ?? '');
    final modeleCtrl = TextEditingController(text: vehicule?['modele'] ?? '');
    final immatCtrl = TextEditingController(
      text: vehicule?['immatriculation'] ?? '',
    );
    final capaciteCtrl = TextEditingController(
      text: vehicule?['capacite']?.toString() ?? '30',
    );
    String etat = vehicule?['etat'] ?? 'actif';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.directions_bus, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                vehicule == null ? 'Ajouter véhicule' : 'Modifier véhicule',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(marqueCtrl, 'Marque', Icons.directions_bus),
                const SizedBox(height: 10),
                _field(modeleCtrl, 'Modèle', Icons.info_outline),
                const SizedBox(height: 10),
                _field(immatCtrl, 'Immatriculation', Icons.badge_outlined),
                const SizedBox(height: 10),
                _field(
                  capaciteCtrl,
                  'Capacité',
                  Icons.event_seat,
                  type: TextInputType.number,
                ),
                const SizedBox(height: 10),
                if (vehicule != null) ...[
                  DropdownButtonFormField<String>(
                    value: etat,
                    dropdownColor: AppTheme.background,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'État',
                      labelStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['actif', 'en panne', 'en maintenance']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setS(() => etat = v!),
                  ),
                ],
              ],
            ),
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
                Navigator.pop(ctx);
                final body = {
                  'marque': marqueCtrl.text.trim(),
                  'modele': modeleCtrl.text.trim(),
                  'immatriculation': immatCtrl.text.trim(),
                  'capacite': int.tryParse(capaciteCtrl.text) ?? 30,
                  'etat': etat,
                };
                http.Response r;
                if (vehicule == null) {
                  r = await http.post(
                    Uri.parse(ApiConstants.vehicules),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $_token',
                    },
                    body: jsonEncode(body),
                  );
                } else {
                  r = await http.put(
                    Uri.parse('${ApiConstants.vehicules}/${vehicule['id']}'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $_token',
                    },
                    body: jsonEncode(body),
                  );
                }
                if (!mounted) return;
                final msg = jsonDecode(r.body)['message'];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: r.statusCode < 300
                        ? Colors.green
                        : Colors.red,
                  ),
                );
                if (r.statusCode < 300) _load();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                vehicule == null ? 'Ajouter' : 'Modifier',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _supprimer(int id) async {
    final r = await http.delete(
      Uri.parse('${ApiConstants.vehicules}/$id'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(jsonDecode(r.body)['message']),
        backgroundColor: r.statusCode == 200 ? Colors.green : Colors.red,
      ),
    );
    if (r.statusCode == 200) _load();
  }

  Color _etatColor(String etat) {
    switch (etat) {
      case 'actif':
        return AppTheme.secondary;
      case 'en panne':
        return AppTheme.error;
      default:
        return AppTheme.warning;
    }
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
              'Mes Véhicules',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${_vehicules.length} véhicule(s)',
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
        heroTag: 'add_vehicule',
        onPressed: () => _showAjouterDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _vehicules.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus_outlined,
                    size: 70,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun véhicule',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _vehicules.length,
              itemBuilder: (_, i) {
                final v = _vehicules[i];
                final etat = v['etat'] ?? 'actif';
                final c = _etatColor(etat);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_bus,
                          color: AppTheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${v['marque']} ${v['modele'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              v['immatriculation'] ?? '',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    etat,
                                    style: TextStyle(
                                      color: c,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.event_seat,
                                  color: Colors.white38,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${v['capacite']} places',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () => _showAjouterDialog(vehicule: v),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () => _supprimer(v['id']),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _field(
    TextEditingController c,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
