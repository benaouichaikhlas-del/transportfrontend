import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/demande_model.dart';
import '../services/proprietaire_service.dart';
import 'attente_screen.dart';

class RegisterProprietaireScreen extends StatefulWidget {
  const RegisterProprietaireScreen({super.key});

  @override
  State<RegisterProprietaireScreen> createState() =>
      _RegisterProprietaireScreenState();
}

class _RegisterProprietaireScreenState
    extends State<RegisterProprietaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  final _service = ProprietaireService();

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _adresseCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await _service.demanderInscription(
      DemandeModel(
        nom: _nomCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        tel: _telCtrl.text.trim(),
        adresse: _adresseCtrl.text.trim(),
        motDePasse: _passCtrl.text.trim(),
      ),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AttenteScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Inscription Propriétaire',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(
                Icons.business_outlined,
                size: 70,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 8),
              const Text(
                'Votre demande sera examinée par un administrateur',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _field(_nomCtrl, 'Nom complet', Icons.person_outline),
              const SizedBox(height: 12),
              _field(
                _emailCtrl,
                'Email',
                Icons.email_outlined,
                type: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _field(
                _telCtrl,
                'Téléphone',
                Icons.phone_outlined,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _field(_adresseCtrl, 'Adresse', Icons.location_on_outlined),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                style: const TextStyle(color: Colors.white),
                decoration:
                    AppTheme.inputDecoration(
                      'Mot de passe',
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 caractères' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obscure,
                style: const TextStyle(color: Colors.white),
                decoration: AppTheme.inputDecoration(
                  'Confirmer mot de passe',
                  Icons.lock_outline,
                ),
                validator: (v) =>
                    v != _passCtrl.text ? 'Mots de passe différents' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: AppTheme.primaryButton(),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Envoyer la demande',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String l,
    IconData i, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: AppTheme.inputDecoration(l, i),
      validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
    );
  }
}
