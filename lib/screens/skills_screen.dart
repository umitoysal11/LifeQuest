import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.primaryVoid,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Background Orbs
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cyanGlow.withOpacity(0.08),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -100,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonPulse.withOpacity(0.05),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              ListView(
                padding: const EdgeInsets.fromLTRB(24.0, 100.0, 24.0, 128.0),
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.hexagon_outlined, color: AppColors.cyanGlow, size: 32),
                      const SizedBox(width: 12),
                      const Text(
                        'YETENEK\nPROFİLİ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                        ),
                        child: Text(
                          'LVL ${appState.userLevel}',
                          style: const TextStyle(
                            color: AppColors.cyanGlow,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Radar Chart Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.cyanGlow.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'GELİŞMİŞ ANALİTİKLER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyanGlow,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 280,
                          child: RepaintBoundary(
                            child: CustomPaint(
                              size: const Size(280, 280),
                              painter: TriangleRadarChartPainter(
                                fizikselXp: appState.getSkillXp('FİZİKSEL GELİŞİM').toDouble(),
                                zihinselXp: appState.getSkillXp('ZİHİNSEL GELİŞİM').toDouble(),
                                kisiselXp: appState.getSkillXp('KİŞİSEL GELİŞİM').toDouble(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Basic Skills List
                  const Text(
                    'TEMEL YETENEKLER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSkillDetailCard('Kişisel Gelişim', Icons.self_improvement, AppColors.neonPulse, appState.getSkillLevel('KİŞİSEL GELİŞİM'), appState.getSkillXp('KİŞİSEL GELİŞİM')),
                  const SizedBox(height: 12),
                  _buildSkillDetailCard('Fiziksel Gelişim', Icons.fitness_center, AppColors.limeSurge, appState.getSkillLevel('FİZİKSEL GELİŞİM'), appState.getSkillXp('FİZİKSEL GELİŞİM')),
                  const SizedBox(height: 12),
                  _buildSkillDetailCard('Zihinsel Gelişim', Icons.psychology, AppColors.cyanGlow, appState.getSkillLevel('ZİHİNSEL GELİŞİM'), appState.getSkillXp('ZİHİNSEL GELİŞİM')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color, int xp) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        Text(
          '$xp XP',
          style: const TextStyle(color: Colors.white54, fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildSkillDetailCard(String name, IconData icon, Color color, int level, int totalXp) {
    double progress = (totalXp % 100) / 100.0;
    int currentXpInLevel = totalXp % 100;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: color.withOpacity(0.2)),
          left: BorderSide(color: color.withOpacity(0.1)),
          right: const BorderSide(color: Colors.transparent),
          bottom: const BorderSide(color: Colors.transparent),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'LVL $level ($totalXp XP)',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.black,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$currentXpInLevel / 100 XP',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleRadarChartPainter extends CustomPainter {
  final double fizikselXp;
  final double zihinselXp;
  final double kisiselXp;

  TriangleRadarChartPainter({
    required this.fizikselXp,
    required this.zihinselXp,
    required this.kisiselXp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 30;
    const sides = 3;

    final outlinePaint = Paint()
      ..color = AppColors.surfaceHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = AppColors.cyanGlow.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final pathPaint = Paint()
      ..color = AppColors.cyanGlow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Labels
    final labels = ['FİZİKSEL\nGELİŞİM', 'ZİHİNSEL\nGELİŞİM', 'KİŞİSEL\nGELİŞİM'];
    final labelColors = [AppColors.limeSurge, AppColors.cyanGlow, AppColors.neonPulse];

    // Draw concentric triangle guides (5 levels)
    for (int i = 1; i <= 5; i++) {
      final r = radius * (i / 5);
      final guidePath = Path();
      for (int j = 0; j < sides; j++) {
        final angle = (j * 360 / sides - 90) * pi / 180;
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (j == 0) {
          guidePath.moveTo(x, y);
        } else {
          guidePath.lineTo(x, y);
        }
      }
      guidePath.close();
      canvas.drawPath(guidePath, outlinePaint);
    }

    // Draw axis lines and labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int j = 0; j < sides; j++) {
      final angle = (j * 360 / sides - 90) * pi / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), outlinePaint);

      final labelX = center.dx + (radius + 28) * cos(angle);
      final labelY = center.dy + (radius + 28) * sin(angle);

      textPainter.text = TextSpan(
        text: labels[j],
        style: TextStyle(
          color: labelColors[j],
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      );
      textPainter.textAlign = TextAlign.center;
      textPainter.layout();
      textPainter.paint(canvas, Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2));
    }

    // Normalize values: cap at 500 XP for max chart
    const maxXp = 500.0;
    final values = [
      (fizikselXp / maxXp).clamp(0.0, 1.0),
      (zihinselXp / maxXp).clamp(0.0, 1.0),
      (kisiselXp / maxXp).clamp(0.0, 1.0),
    ];

    // Draw data triangle
    final valuePath = Path();
    final points = <Offset>[];
    for (int j = 0; j < sides; j++) {
      final angle = (j * 360 / sides - 90) * pi / 180;
      final r = radius * values[j];
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      points.add(Offset(x, y));
      if (j == 0) {
        valuePath.moveTo(x, y);
      } else {
        valuePath.lineTo(x, y);
      }
    }
    valuePath.close();

    bool hasValues = values.any((v) => v > 0);
    if (hasValues) {
      canvas.drawPath(valuePath, fillPaint);
      canvas.drawPath(valuePath, pathPaint);
    }

    // Draw data points
    final pointColors = [AppColors.limeSurge, AppColors.cyanGlow, AppColors.neonPulse];
    for (int j = 0; j < sides; j++) {
      final pointPaint = Paint()..color = pointColors[j];
      final pointBorderPaint = Paint()
        ..color = AppColors.primaryVoid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(points[j], 6, pointPaint);
      canvas.drawCircle(points[j], 6, pointBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TriangleRadarChartPainter oldDelegate) {
    return oldDelegate.fizikselXp != fizikselXp ||
        oldDelegate.zihinselXp != zihinselXp ||
        oldDelegate.kisiselXp != kisiselXp;
  }
}
