import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/conducteur_service.dart';

class ConducteursScreen extends StatefulWidget {
  const ConducteursScreen({super.key});

  @override
  State<ConducteursScreen> createState() => _ConducteursScreenState();
}

class _ConducteursScreenState extends State<ConducteursScreen> {
  final _service = ConducteurService();
  List<dynamic> _conducteurs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final token = context.read<AuthProvider>().user!.token;
    final data = await _service.getConducteurs(token);
    setState(() {
      _conducteurs = data;
      _isLoading = false;
    });
  }

  // ══════════════════════════════════════
  // ➕ AJOUTER
  // ══════════════════════════════════════
  Future<void> _showAjouterDialog() async {
    final token = context.read<AuthProvider>().user!.token;
    final nomCtrl = TextEditingController();
    final prenomCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final permisCtrl = TextEditingController();
    final adresseCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    bool obscure = true;

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
              Icon(Icons.person_add, color: AppTheme.primary),
              SizedBox(width: 8),
              Text(
                'Ajouter conducteur',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(nomCtrl, 'Nom *', Icons.person_outline),
                const SizedBox(height: 10),
                _dialogField(prenomCtrl, 'Prénom *', Icons.person_outline),
                const SizedBox(height: 10),
                _dialogField(
                  telCtrl,
                  'Téléphone *',
                  Icons.phone_outlined,
                  type: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                _dialogField(permisCtrl, 'N° Permis *', Icons.badge_outlined),
                const SizedBox(height: 10),
                _dialogField(
                  adresseCtrl,
                  'Adresse',
                  Icons.location_on_outlined,
                ),
                const Divider(color: Colors.white24, height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Accès à l\'application',
                    style: TextStyle(color: AppTheme.primary, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10),
                _dialogField(
                  emailCtrl,
                  'Email *',
                  Icons.email_outlined,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Mot de passe *',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white38,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white38,
                      ),
                      onPressed: () => setS(() => obscure = !obscure),
                    ),
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
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
                final result = await _service.ajouterConducteur(
                  token: token,
                  nom: nomCtrl.text.trim(),
                  prenom: prenomCtrl.text.trim(),
                  tel: telCtrl.text.trim(),
                  numPermis: permisCtrl.text.trim(),
                  adresse: adresseCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  motDePasse: passCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message']),
                    backgroundColor: result['success']
                        ? Colors.green
                        : Colors.red,
                  ),
                );
                if (result['success']) _load();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Ajouter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // ✏️ MODIFIER
  // ══════════════════════════════════════
  Future<void> _showEditDialog(Map c) async {
    final token = context.read<AuthProvider>().user!.token;
    final nomCtrl = TextEditingController(text: c['nom']);
    final prenomCtrl = TextEditingController(text: c['prenom']);
    final telCtrl = TextEditingController(text: c['telephone']);
    final permisCtrl = TextEditingController(text: c['num_permis']);
    final adresseCtrl = TextEditingController(text: c['adresse']);
    final emailCtrl = TextEditingController(text: c['email']);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: AppTheme.warning),
            SizedBox(width: 8),
            Text(
              'Modifier conducteur',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(nomCtrl, 'Nom', Icons.person_outline),
              const SizedBox(height: 10),
              _dialogField(prenomCtrl, 'Prénom', Icons.person_outline),
              const SizedBox(height: 10),
              _dialogField(
                telCtrl,
                'Téléphone',
                Icons.phone_outlined,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              _dialogField(permisCtrl, 'N° Permis', Icons.badge_outlined),
              const SizedBox(height: 10),
              _dialogField(adresseCtrl, 'Adresse', Icons.location_on_outlined),
              const SizedBox(height: 10),
              _dialogField(
                emailCtrl,
                'Email',
                Icons.email_outlined,
                type: TextInputType.emailAddress,
              ),
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
              final result = await _service.modifierConducteur(
                token: token,
                id: c['id'],
                nom: nomCtrl.text.trim(),
                prenom: prenomCtrl.text.trim(),
                tel: telCtrl.text.trim(),
                numPermis: permisCtrl.text.trim(),
                adresse: adresseCtrl.text.trim(),
                email: emailCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message']),
                  backgroundColor: result['success']
                      ? Colors.green
                      : Colors.red,
                ),
              );
              if (result['success']) _load();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Modifier',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  // 🗑️ SUPPRIMER
  // ══════════════════════════════════════
  Future<void> _supprimer(int id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer', style: TextStyle(color: Colors.white)),
        content: Text(
          'Supprimer le conducteur "$nom" ?',
          style: const TextStyle(color: Colors.white70),
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
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final token = context.read<AuthProvider>().user!.token;
    final result = await _service.supprimerConducteur(token, id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
    if (result['success']) _load();
  }

  // ══════════════════════════════════════
  // 🏗️ BUILD
  // ══════════════════════════════════════
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
              'Mes Conducteurs',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${_conducteurs.length} conducteur(s)',
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
        heroTag: 'add_conducteur',
        onPressed: _showAjouterDialog,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _conducteurs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 70, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Aucun conducteur',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _conducteurs.length,
              itemBuilder: (_, i) {
                final c = _conducteurs[i];
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
                      const CircleAvatar(
                        backgroundColor: AppTheme.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${c['nom']} ${c['prenom'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c['email'] ?? '',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            if (c['telephone'] != null)
                              Text(
                                c['telephone'],
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.orange,
                        ),
                        onPressed: () => _showEditDialog(c),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _supprimer(c['id'], c['nom']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _dialogField(
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
