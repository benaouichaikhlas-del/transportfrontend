import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/theme/app_theme.dart';
import '../core/constants/api_constants.dart';
import 'login_screen.dart';

class RegisterVisiteurScreen extends StatefulWidget {
  const RegisterVisiteurScreen({super.key});

  @override
  State<RegisterVisiteurScreen> createState() => _RegisterVisiteurScreenState();
}

class _RegisterVisiteurScreenState extends State<RegisterVisiteurScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.inscrireVisiteur),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nom': _nomCtrl.text.trim(),
              'email': _emailCtrl.text.trim(),
              'tel': _telCtrl.text.trim(),
              'adresse': '',
              'mot_de_passe': _passCtrl.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      setState(() => _isLoading = false);
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {'message': response.body};
      }
      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Compte créé !'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(
              savedEmail: _emailCtrl.text.trim(),
              savedPassword: _passCtrl.text.trim(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Erreur'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur de connexion au serveur'),
          backgroundColor: Colors.red,
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
          'Inscription Visiteur',
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
                Icons.person_outline,
                size: 70,
                color: AppTheme.secondary,
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
                  onPressed: _isLoading ? null : _register,
                  style: AppTheme.primaryButton(color: AppTheme.secondary),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "S'inscrire",
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
