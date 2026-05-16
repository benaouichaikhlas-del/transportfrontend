import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../screens/welcome_screen.dart';

class ConducteurHomeScreen extends StatefulWidget {
  const ConducteurHomeScreen({super.key});

  @override
  State<ConducteurHomeScreen> createState() => _ConducteurHomeScreenState();
}

class _ConducteurHomeScreenState extends State<ConducteurHomeScreen> {
  int _selectedIndex = 0;
  bool _gpsActif = false;
  bool _enService = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildAccueil(),
          _buildGPS(),
          _buildRetard(),
          _buildPanne(),
          _buildProfil(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: 'GPS'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Retard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Panne',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ═══════ ACCUEIL ═══════
  Widget _buildAccueil() {
    final user = context.read<AuthProvider>().user;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a3a5c), Color(0xFF1a5c4a)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.surface,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bonjour, Conducteur !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
            const SizedBox(height: 20),

            // Statut
            const Text(
              'Statut du service',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _enService ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _enService ? 'En service' : 'Hors service',
                    style: TextStyle(
                      color: _enService ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Ligne 12 — Alger Centre',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions rapides
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
              childAspectRatio: 1.3,
              children: [
                _actionCard(
                  Icons.gps_fixed,
                  'Activer GPS',
                  AppTheme.secondary,
                  () => setState(() => _selectedIndex = 1),
                ),
                _actionCard(
                  Icons.access_time,
                  'Déclarer retard',
                  AppTheme.warning,
                  () => setState(() => _selectedIndex = 2),
                ),
                _actionCard(
                  Icons.build_outlined,
                  'Déclarer panne',
                  AppTheme.error,
                  () => setState(() => _selectedIndex = 3),
                ),
                _actionCard(
                  Icons.event_seat,
                  'Espaces vides',
                  const Color(0xFFb06af0),
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tableau permanences
            const Text(
              'Tableau des permanences',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _permanenceRow('Lun', '08:00-16:00', false),
                  _permanenceRow('Mar', '08:00-16:00', false),
                  _permanenceRow('Mer', '10:00-18:00', false),
                  _permanenceRow('Jeu', '08:00-16:00', false),
                  _permanenceRow('Ven', '08:00-16:00', false),
                  _permanenceRow('Sam', 'Repos', true),
                  _permanenceRow('Dim', 'Repos', true),
                ],
              ),
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
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _permanenceRow(String jour, String horaire, bool repos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            jour,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Spacer(),
          Text(
            horaire,
            style: TextStyle(
              color: repos ? Colors.red : Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════ GPS ═══════
  Widget _buildGPS() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Localisation GPS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => setState(() => _gpsActif = !_gpsActif),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surface,
                  border: Border.all(
                    color: _gpsActif ? AppTheme.secondary : Colors.white24,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gps_fixed,
                      size: 60,
                      color: _gpsActif ? AppTheme.secondary : Colors.white24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _gpsActif ? 'GPS ACTIF' : 'GPS INACTIF',
                      style: TextStyle(
                        color: _gpsActif ? AppTheme.secondary : Colors.white38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _gpsActif = !_gpsActif),
                  icon: Icon(
                    _gpsActif ? Icons.gps_off : Icons.gps_fixed,
                    color: Colors.white,
                  ),
                  label: Text(
                    _gpsActif ? 'Désactiver GPS' : 'Activer GPS',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gpsActif
                        ? Colors.red
                        : AppTheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════ RETARD ═══════
  Widget _buildRetard() {
    final dureeCtrl = TextEditingController();
    final motifCtrl = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Déclarer un retard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: dureeCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Durée du retard (minutes)',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(
                  Icons.timer_outlined,
                  color: Colors.white38,
                ),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: motifCtrl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Motif du retard',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Retard déclaré avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Envoyer la justification',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warning,
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

  // ═══════ PANNE ═══════
  Widget _buildPanne() {
    final descCtrl = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Déclarer une panne',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: descCtrl,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Description de la panne...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Panne déclarée'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.warning_amber, color: Colors.white),
                label: const Text(
                  'Signaler la panne',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
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

  // ═══════ PROFIL ═══════
  Widget _buildProfil() {
    final user = context.read<AuthProvider>().user;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 45,
              backgroundColor: AppTheme.surface,
              child: Icon(Icons.person, size: 50, color: AppTheme.primary),
            ),
            const SizedBox(height: 12),
            const Text(
              'Conducteur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'CONDUCTEUR',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _profilItem(Icons.edit_outlined, 'Modifier compte', Colors.blue),
            const SizedBox(height: 10),
            _profilItem(Icons.delete_outlined, 'Supprimer compte', Colors.red),
            const Spacer(),
            TextButton.icon(
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
              icon: const Icon(Icons.logout, color: Colors.white54),
              label: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.white54),
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
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: color, size: 14),
        ],
      ),
    );
  }
}
