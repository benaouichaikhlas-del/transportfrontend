import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../core/constants/api_constants.dart';
import '../providers/auth_provider.dart';

class LignesHorairesScreen extends StatefulWidget {
  const LignesHorairesScreen({super.key});
  @override
  State<LignesHorairesScreen> createState() => _LignesHorairesScreenState();
}

class _LignesHorairesScreenState extends State<LignesHorairesScreen> {
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
      final r = await http.get(
        Uri.parse(ApiConstants.lignes),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (r.statusCode == 200) setState(() => _lignes = jsonDecode(r.body));
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _showAjouterDialog() async {
    final numCtrl = TextEditingController();
    final nomCtrl = TextEditingController();
    final debutCtrl = TextEditingController(text: '06:00');
    final finCtrl = TextEditingController(text: '22:00');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.route, color: AppTheme.primary),
            SizedBox(width: 8),
            Text(
              'Ajouter une ligne',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(numCtrl, 'Numéro (ex: L1)', Icons.tag),
            const SizedBox(height: 10),
            _field(nomCtrl, 'Nom (ex: Centre → Est)', Icons.route),
            const SizedBox(height: 10),
            _field(debutCtrl, 'Heure début (HH:MM)', Icons.schedule),
            const SizedBox(height: 10),
            _field(finCtrl, 'Heure fin (HH:MM)', Icons.schedule_outlined),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final r = await http.post(
                Uri.parse(ApiConstants.lignes),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $_token',
                },
                body: jsonEncode({
                  'numero': numCtrl.text.trim(),
                  'nom': nomCtrl.text.trim(),
                  'heure_debut': debutCtrl.text.trim(),
                  'heure_fin': finCtrl.text.trim(),
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
            child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _supprimer(int id) async {
    final r = await http.delete(
      Uri.parse('${ApiConstants.lignes}/$id'),
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

  final List<Color> _colors = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.warning,
    const Color(0xFFb06af0),
    AppTheme.error,
  ];

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
              'Lignes & Horaires',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${_lignes.length} ligne(s)',
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
        heroTag: 'add_ligne',
        onPressed: _showAjouterDialog,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _lignes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.route, size: 70, color: Colors.white24),
                  SizedBox(height: 16),
                  Text('Aucune ligne', style: TextStyle(color: Colors.white38)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lignes.length,
              itemBuilder: (_, i) {
                final l = _lignes[i];
                final c = _colors[i % _colors.length];
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: c.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            l['numero'],
                            style: TextStyle(
                              color: c,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l['nom'] ?? l['numero'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: Colors.white38,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${l['heure_debut'] ?? '--'} → ${l['heure_fin'] ?? '--'}',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => _supprimer(l['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon) {
    return TextField(
      controller: c,
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
