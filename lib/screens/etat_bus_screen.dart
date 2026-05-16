import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class EtatBusScreen extends StatelessWidget {
  const EtatBusScreen({super.key});

  final List<Map<String, dynamic>> _buses = const [
    {
      'id': 'BUS-01',
      'ligne': 'L1',
      'conducteur': 'Ahmed B.',
      'etat': 'En service',
      'position': 'Centre-ville',
      'retard': 0,
    },
    {
      'id': 'BUS-02',
      'ligne': 'L2',
      'conducteur': 'Mohamed K.',
      'etat': 'Retard',
      'position': 'Place Audin',
      'retard': 10,
    },
    {
      'id': 'BUS-03',
      'ligne': 'L3',
      'conducteur': 'Karim M.',
      'etat': 'En panne',
      'position': 'Hussein Dey',
      'retard': 0,
    },
    {
      'id': 'BUS-04',
      'ligne': 'L1',
      'conducteur': 'Youcef A.',
      'etat': 'En service',
      'position': 'El Harrach',
      'retard': 0,
    },
    {
      'id': 'BUS-05',
      'ligne': 'L4',
      'conducteur': 'Omar S.',
      'etat': 'En service',
      'position': 'Bab Ezzouar',
      'retard': 0,
    },
  ];

  Color _etatColor(String etat) {
    switch (etat) {
      case 'En service':
        return AppTheme.secondary;
      case 'Retard':
        return AppTheme.warning;
      case 'En panne':
        return AppTheme.error;
      default:
        return Colors.white38;
    }
  }

  IconData _etatIcon(String etat) {
    switch (etat) {
      case 'En service':
        return Icons.check_circle_outline;
      case 'Retard':
        return Icons.access_time;
      case 'En panne':
        return Icons.build_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.surface,
          leading: const BackButton(color: Colors.white),
          title: const Text(
            'État & Position des Bus',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primary,
            labelColor: AppTheme.primary,
            unselectedLabelColor: Colors.white38,
            tabs: const [
              Tab(icon: Icon(Icons.directions_bus), text: 'État des Bus'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Positions'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildEtatTab(), _buildPositionTab()]),
      ),
    );
  }

  // ══════ ONGLET ÉTAT ══════
  Widget _buildEtatTab() {
    final enService = _buses.where((b) => b['etat'] == 'En service').length;
    final retard = _buses.where((b) => b['etat'] == 'Retard').length;
    final enPanne = _buses.where((b) => b['etat'] == 'En panne').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats
          Row(
            children: [
              _statCard(
                '$enService',
                'En service',
                AppTheme.secondary,
                Icons.check_circle,
              ),
              const SizedBox(width: 10),
              _statCard(
                '$retard',
                'Retard',
                AppTheme.warning,
                Icons.access_time,
              ),
              const SizedBox(width: 10),
              _statCard('$enPanne', 'En panne', AppTheme.error, Icons.build),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Liste des Bus',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          ..._buses.map((b) {
            final color = _etatColor(b['etat'] as String);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _etatIcon(b['etat'] as String),
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              b['id'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                b['ligne'] as String,
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b['conducteur'] as String,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        if (b['retard'] as int > 0)
                          Text(
                            'Retard: ${b['retard']} min',
                            style: TextStyle(
                              color: AppTheme.warning,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      b['etat'] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ══════ ONGLET POSITION ══════
  Widget _buildPositionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte simulée
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E2A40)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: Colors.white24,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Carte en temps réel',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        Text(
                          '(Disponible avec GPS actif)',
                          style: TextStyle(color: Colors.white24, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Positions actuelles',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          ..._buses.map(
            (b) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E2A40)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${b['id']} — Ligne ${b['ligne']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          b['position'] as String,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _etatColor(b['etat'] as String),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _etatColor(
                            b['etat'] as String,
                          ).withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0D1520);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);
    final grid = Paint()
      ..color = const Color(0xFF1A2535)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (double y = 40; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (double x = 40; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
