import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../core/constants/api_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'welcome_screen.dart';

class PassagerHomeScreen extends StatefulWidget {
  const PassagerHomeScreen({super.key});

  @override
  State<PassagerHomeScreen> createState() => _PassagerHomeScreenState();
}

class _PassagerHomeScreenState extends State<PassagerHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildAccueil(),
          _buildReservation(),
          _buildSignalement(),
          _buildEvaluation(),
          _buildProfil(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_seat_outlined),
              label: 'Réserver',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report_outlined),
              label: 'Signaler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              label: 'Évaluer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // ══════════ ACCUEIL PASSAGER ══════════
  Widget _buildAccueil() {
    // ✅ تم التصحيح: استخدام watch بدلاً من read
    final user = context.watch<AuthProvider>().user;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a3a5c), Color(0xFF1a4a3a)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppTheme.surface,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bonjour, Passager !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rechercher une ligne ou station...',
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Actions rapides',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _actionCard(
                  Icons.event_seat_outlined,
                  'Réserver une place',
                  AppTheme.primary,
                  () => setState(() => _selectedIndex = 1),
                ),
                _actionCard(
                  Icons.report_outlined,
                  'Signaler un problème',
                  AppTheme.error,
                  () => setState(() => _selectedIndex = 2),
                ),
                _actionCard(
                  Icons.star_outline,
                  'Évaluer une ligne',
                  AppTheme.warning,
                  () => setState(() => _selectedIndex = 3),
                ),
                _actionCard(
                  Icons.access_time,
                  'Voir les horaires',
                  AppTheme.secondary,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Alertes en temps réel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _alertCard(
              'L1',
              'Retard de 10 min — Zone Centre',
              AppTheme.warning,
              Icons.access_time,
            ),
            const SizedBox(height: 8),
            _alertCard(
              'L3',
              'Panne signalée — En cours de résolution',
              AppTheme.error,
              Icons.build,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alertCard(String ligne, String msg, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              ligne,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Icon(icon, color: color, size: 16),
        ],
      ),
    );
  }

  // ══════════ RÉSERVATION ══════════
  Widget _buildReservation() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Réserver une place',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _selectField('Choisir la ligne', Icons.directions_bus),
            const SizedBox(height: 12),
            _selectField('Station de départ', Icons.trip_origin),
            const SizedBox(height: 12),
            _selectField('Station d\'arrivée', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _selectField('Date et heure', Icons.calendar_today_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Réservation confirmée !'),
                    backgroundColor: Colors.green,
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Confirmer la réservation',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: AppTheme.primaryButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectField(String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 20),
          const SizedBox(width: 12),
          Text(hint, style: const TextStyle(color: Colors.white38)),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
        ],
      ),
    );
  }

  // ══════════ SIGNALEMENT ══════════
  Widget _buildSignalement() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Signaler un problème',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _problemChip('Retard', Icons.access_time, AppTheme.warning),
                _problemChip('Panne', Icons.build, AppTheme.error),
                _problemChip('Surcharge', Icons.people, AppTheme.primary),
                _problemChip('Autre', Icons.more_horiz, Colors.white54),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Décrivez le problème...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Problème signalé, merci !'),
                    backgroundColor: Colors.green,
                  ),
                ),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Envoyer le signalement',
                  style: TextStyle(color: Colors.white),
                ),
                style: AppTheme.primaryButton(color: AppTheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _problemChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  // ══════════ ÉVALUATION ══════════
  Widget _buildEvaluation() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Évaluer les lignes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _evalCard('L1', 'Centre → El Harrach', 4, AppTheme.primary),
                  _evalCard('L2', 'Audin → Bab Ezzouar', 3, AppTheme.secondary),
                  _evalCard('L3', 'Centrale → Hussein', 5, AppTheme.warning),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _evalCard(String num, String name, int stars, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  num,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < stars ? Icons.star : Icons.star_border,
                color: AppTheme.warning,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Laissez un feedback...',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════ PROFIL ══════════
  Widget _buildProfil() {
    // ✅ تم التصحيح: استخدام watch بدلاً من read
    final user = context.watch<AuthProvider>().user;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 45,
              backgroundColor: AppTheme.surface,
              child: Icon(Icons.person, size: 50, color: AppTheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PASSAGER',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _profilItem(Icons.edit_outlined, 'Modifier compte', Colors.blue),
            const SizedBox(height: 10),
            _profilItem(Icons.history, 'Mes réservations', AppTheme.primary),
            const SizedBox(height: 10),
            _profilItem(
              Icons.notifications_outlined,
              'Notifications',
              AppTheme.warning,
            ),
            const SizedBox(height: 10),
            _profilItem(Icons.delete_outline, 'Supprimer compte', Colors.red),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilItem(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        ],
      ),
    );
  }
}

class _AnnoncesBanner extends StatefulWidget {
  const _AnnoncesBanner();

  @override
  State<_AnnoncesBanner> createState() => _AnnoncesBannerState();
}

class _AnnoncesBannerState extends State<_AnnoncesBanner> {
  List<Map<String, dynamic>> _annonces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  Future<void> _loadAnnonces() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.annonces))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _annonces = data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Erreur annonces: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _annonces.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: Color(0xFFF59E0B),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Annonces',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: _annonces.length,
            itemBuilder: (_, i) => _buildAnnonceCard(_annonces[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnonceCard(Map<String, dynamic> annonce) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign, color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  annonce['titre'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            annonce['contenu'] ?? '',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
