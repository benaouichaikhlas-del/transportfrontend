import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/admin_service.dart';
import 'welcome_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _service = AdminService();
  List<dynamic> _demandes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDemandes();
  }

  Future<void> _loadDemandes() async {
    setState(() => _isLoading = true);
    final token = context.read<AuthProvider>().user!.token;
    final data = await _service.getDemandes(token);
    setState(() {
      _demandes = data;
      _isLoading = false;
    });
  }

  Future<void> _action(int id, bool accepter) async {
    final nom = _demandes.firstWhere((d) => d['id'] == id)['nom'];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          accepter ? 'Accepter $nom ?' : 'Refuser $nom ?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: accepter ? Colors.green : Colors.red,
            ),
            child: Text(
              accepter ? 'Accepter' : 'Refuser',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    _showLoading();
    final token = context.read<AuthProvider>().user!.token;
    final result = accepter
        ? await _service.accepter(token, id)
        : await _service.refuser(token, id);
    if (!mounted) return;
    Navigator.pop(context);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              result['success'] ? Icons.check_circle : Icons.error,
              color: result['success'] ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              result['message'],
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: result['success'] ? Colors.green : Colors.red,
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
    _loadDemandes();
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        backgroundColor: AppTheme.surface,
        content: Row(
          children: [
            CircularProgressIndicator(color: AppTheme.primary),
            SizedBox(width: 20),
            Text('Traitement...', style: TextStyle(color: Colors.white)),
          ],
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Espace Admin',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${_demandes.where((d) => d['statut'] == 'en_attente').length} en attente',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadDemandes,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              // كل مكان فيه WelcomeScreen بعد logout بدله بـ:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _demandes.isEmpty
          ? const Center(
              child: Text(
                'Aucune demande',
                style: TextStyle(color: Colors.white38),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDemandes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _demandes.length,
                itemBuilder: (_, i) {
                  final d = _demandes[i];
                  final statut = d['statut'] ?? 'en_attente';
                  final color = statut == 'accepte'
                      ? Colors.green
                      : statut == 'refuse'
                      ? Colors.red
                      : AppTheme.warning;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              d['nom'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              statut.toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          d['email'] ?? '',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          d['tel'] ?? '',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        if (statut == 'en_attente') ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _action(d['id'], true),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Accepter'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _action(d['id'], false),
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Refuser'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
