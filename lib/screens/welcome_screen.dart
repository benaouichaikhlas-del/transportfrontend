import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import 'login_screen.dart';
import 'register_choice_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _stations = [
    {
      'name': 'Gare Routière Centrale',
      'lines': ['L1', 'L3'],
      'time': '5 min',
      'dist': '0.3 km',
    },
    {
      'name': 'Place Audin',
      'lines': ['L2'],
      'time': '8 min',
      'dist': '0.7 km',
    },
    {
      'name': 'Hussein Dey',
      'lines': ['L1', 'L4'],
      'time': '12 min',
      'dist': '1.2 km',
    },
    {
      'name': 'El Harrach',
      'lines': ['L3', 'L4'],
      'time': '15 min',
      'dist': '2.1 km',
    },
    {
      'name': 'Bab Ezzouar',
      'lines': ['L2', 'L5'],
      'time': '20 min',
      'dist': '3.4 km',
    },
  ];

  final List<Map<String, dynamic>> _lignes = [
    {'num': 'L1', 'color': const Color(0xFF3B82F6)},
    {'num': 'L2', 'color': const Color(0xFF10B981)},
    {'num': 'L3', 'color': const Color(0xFFF59E0B)},
    {'num': 'L4', 'color': const Color(0xFF8B5CF6)},
    {'num': 'L5', 'color': const Color(0xFFEF4444)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0A0E1A),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // ══════ TOP BAR ══════
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2A40)),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E2A40)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'TransportDZ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Connexion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ══════ BARRE RECHERCHE ══════
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E2A40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une ligne, station...',
                    hintStyle: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF3B82F6),
                      size: 18,
                    ),
                    suffixIcon: Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    isDense: true,
                  ),
                ),
              ),
            ),

            // ══════ FILTRES ══════
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                children: [
                  _chip('Toutes', true),
                  _chip('Bus', false),
                  _chip('Metro', false),
                  _chip('Tram', false),
                  _chip('Proche', false),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ══════ CARTE ══════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1520),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1E2A40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      CustomPaint(painter: _MapPainter(), size: Size.infinite),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF10B981).withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withOpacity(0.6),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'En direct',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF1E2A40)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _lignes
                                .map(
                                  (l) => Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (l['color'] as Color).withOpacity(
                                        0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      l['num'],
                                      style: TextStyle(
                                        color: l['color'] as Color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.my_location_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ══════ ANNONCES ══════
            const _AnnoncesBanner(),

            const SizedBox(height: 10),

            // ══════ STATIONS ══════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.near_me_rounded,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Stations proches',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Liste stations
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemCount: _stations.length,
                itemBuilder: (_, i) => _stationCard(_stations[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════ DRAWER ══════
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111827),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F1E3A), Color(0xFF0A2820)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'TransportDZ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Réseau de transport public',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _drawerItem(Icons.map_rounded, 'Carte', () => Navigator.pop(context)),
          _drawerItem(
            Icons.route_rounded,
            'Lignes',
            () => Navigator.pop(context),
          ),
          _drawerItem(
            Icons.schedule_rounded,
            'Horaires',
            () => Navigator.pop(context),
          ),
          _drawerItem(
            Icons.warning_amber_rounded,
            'Retards & Pannes',
            () => Navigator.pop(context),
            color: const Color(0xFFF59E0B),
          ),
          _drawerItem(
            Icons.info_outline_rounded,
            'Informations',
            () => Navigator.pop(context),
          ),
          const Divider(color: Color(0xFF1E2A40), indent: 20, endIndent: 20),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterChoiceScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.person_add_outlined,
                      color: Color(0xFF10B981),
                      size: 16,
                    ),
                    label: const Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFF10B981).withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    final c = color ?? Colors.white70;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: c, size: 20),
        title: Text(label, style: TextStyle(color: c, fontSize: 14)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _chip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3B82F6) : const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? const Color(0xFF3B82F6) : const Color(0xFF1E2A40),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _stationCard(Map<String, dynamic> s) {
    return GestureDetector(
      onTap: () => _showStationSheet(s),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161D2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E2A40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Color(0xFF3B82F6),
                    size: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    s['time'],
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              s['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF64748B),
                  size: 10,
                ),
                const SizedBox(width: 3),
                Text(
                  s['dist'],
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 6),
                Wrap(
                  spacing: 3,
                  children: (s['lines'] as List<String>)
                      .map(
                        (l) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l,
                            style: const TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStationSheet(Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Color(0xFF3B82F6),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        s['dist'],
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: (s['lines'] as List<String>)
                  .map(
                    (l) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l,
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text(
                  'Connectez-vous pour réserver',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════
// 📢 ANNONCES BANNER
// ══════════════════════════════════════
class _AnnoncesBanner extends StatefulWidget {
  const _AnnoncesBanner();

  @override
  State<_AnnoncesBanner> createState() => _AnnoncesBannerState();
}

class _AnnoncesBannerState extends State<_AnnoncesBanner> {
  List<dynamic> _annonces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await http
          .get(Uri.parse(ApiConstants.annonces))
          .timeout(const Duration(seconds: 10));
      if (r.statusCode == 200) {
        setState(() {
          _annonces = jsonDecode(r.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
          height: 85,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            itemCount: _annonces.length,
            itemBuilder: (_, i) {
              final a = _annonces[i];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161D2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.campaign,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            a['titre'] ?? '',
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
                      a['contenu'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ══════ MAP PAINTER ══════
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0D1520);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final grid = Paint()
      ..color = const Color(0xFF1A2535)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (double y = 50; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (double x = 50; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    final lineData = [
      {
        'color': const Color(0xFF3B82F6),
        'p1': Offset(0, size.height * 0.3),
        'p2': Offset(size.width, size.height * 0.3),
      },
      {
        'color': const Color(0xFF10B981),
        'p1': Offset(size.width * 0.3, 0),
        'p2': Offset(size.width * 0.3, size.height),
      },
      {
        'color': const Color(0xFFF59E0B),
        'p1': Offset(0, size.height * 0.65),
        'p2': Offset(size.width, size.height * 0.65),
      },
      {
        'color': const Color(0xFF8B5CF6),
        'p1': Offset(size.width * 0.65, 0),
        'p2': Offset(size.width * 0.65, size.height),
      },
    ];

    for (final l in lineData) {
      final glow = Paint()
        ..color = (l['color'] as Color).withOpacity(0.12)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawLine(l['p1'] as Offset, l['p2'] as Offset, glow);
      final line = Paint()
        ..color = (l['color'] as Color).withOpacity(0.75)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(l['p1'] as Offset, l['p2'] as Offset, line);
    }

    final sp = Paint();
    final intersections = [
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.65, size.height * 0.3),
      Offset(size.width * 0.3, size.height * 0.65),
      Offset(size.width * 0.65, size.height * 0.65),
    ];
    for (final s in intersections) {
      sp.color = const Color(0xFF1E2A40);
      canvas.drawCircle(s, 7, sp);
      sp.color = Colors.white.withOpacity(0.6);
      canvas.drawCircle(s, 4, sp);
    }

    final active = Offset(size.width * 0.47, size.height * 0.47);
    sp.color = const Color(0xFF3B82F6).withOpacity(0.12);
    canvas.drawCircle(active, 22, sp);
    sp.color = const Color(0xFF3B82F6).withOpacity(0.22);
    canvas.drawCircle(active, 14, sp);
    sp.color = const Color(0xFF3B82F6);
    canvas.drawCircle(active, 7, sp);
    sp.color = Colors.white;
    canvas.drawCircle(active, 3, sp);
  }

  @override
  bool shouldRepaint(_) => false;
}
