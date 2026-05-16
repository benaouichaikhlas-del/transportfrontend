import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'welcome_screen.dart';
import 'conducteurs_screen.dart';
import 'vehicules_screen.dart';
import 'lignes_horaires_screen.dart';
import 'affectation_screen.dart';
import 'annonces_screen.dart';
import 'gerer_compte_screen.dart';
import 'etat_bus_screen.dart';

class ProprietaireHomeScreen extends StatelessWidget {
  const ProprietaireHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileCard(user?.email ?? ''),
            const SizedBox(height: 30),
            _buildMenuCards(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // 📱 APP BAR
  // ═══════════════════════════════════════════════
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.surface,
      centerTitle: true,
      title: const Text(
        'Espace Propriétaire',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent),
          tooltip: 'Déconnexion',
          onPressed: () => _handleLogout(context),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // 👤 PROFILE CARD
  // ═══════════════════════════════════════════════
  Widget _buildProfileCard(String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: AppTheme.background,
            child: Icon(Icons.business, size: 50, color: AppTheme.primary),
          ),
          const SizedBox(height: 14),
          Text(
            email,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'PROPRIÉTAIRE',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // 📋 MENU CARDS
  // ═══════════════════════════════════════════════
  Widget _buildMenuCards(BuildContext context) {
    return Column(
      children: [
        // 1. Véhicules
        _card(
          context,
          Icons.local_shipping,
          'Mes Véhicules',
          'Gérer votre flotte de véhicules',
          AppTheme.primary,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VehiculesScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // 2. Conducteurs
        _card(
          context,
          Icons.people_outline,
          'Mes Conducteurs',
          'Gérer votre équipe de conducteurs',
          AppTheme.secondary,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConducteursScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // 3. Lignes & Horaires
        _card(
          context,
          Icons.route,
          'Lignes & Horaires',
          'Planifier les trajets et horaires',
          AppTheme.warning,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LignesHorairesScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // 4. Affectations
        _card(
          context,
          Icons.link,
          'Affectations',
          'Assigner conducteurs aux lignes',
          const Color(0xFFb06af0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AffectationScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // 5. Annonces
        _card(
          context,
          Icons.campaign,
          'Annonces',
          'Publier des annonces',
          AppTheme.error,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnnoncesScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // ✅ 6. Gérer Compte (جديد!)
        _card(
          context,
          Icons.manage_accounts,
          'Gérer Compte',
          'Modifier ou supprimer votre compte',
          Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GererCompteScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // ✅ 7. État & Position des Bus (جديد!)
        _card(
          context,
          Icons.directions_bus_outlined,
          'État & Position des Bus',
          'Voir l\'état et la position en temps réel',
          const Color(0xFF06b6d4),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EtatBusScreen()),
          ),
        ),

        const SizedBox(height: 14),

        // 8. Statistiques (قريباً)
        _card(
          context,
          Icons.bar_chart,
          'Statistiques',
          'Revenus et rapports',
          Colors.greenAccent,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // 🎴 CARD WIDGET
  // ═══════════════════════════════════════════════
  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              onTap != null ? Icons.arrow_forward_ios : Icons.lock_outline,
              color: onTap != null ? Colors.white24 : Colors.white12,
              size: onTap != null ? 15 : 18,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // 🔧 HELPERS
  // ═══════════════════════════════════════════════
  void _handleLogout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }
}
