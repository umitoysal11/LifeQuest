import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  late ConfettiController _confettiController;
  int _acceptedEpicQuests = 0;

  final List<Map<String, dynamic>> _epicQuests = [
    {'title': '2 saat full odak çalış', 'xp': 200, 'category': 'ZİHİNSEL GELİŞİM'},
    {'title': 'Tüm günlük görevleri bitir', 'xp': 180, 'category': 'KİŞİSEL GELİŞİM'},
    {'title': '10.000 adım yürü', 'xp': 170, 'category': 'FİZİKSEL GELİŞİM'},
    {'title': '1 gün sosyal medya kullanma', 'xp': 200, 'category': 'ZİHİNSEL GELİŞİM'},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEXUS ASİSTANI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildMonthlyMetrics(),
                  const SizedBox(height: 32),
                  _buildForgottenRituals(),
                  const SizedBox(height: 32),
                  _buildProactiveAICard(),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [AppColors.limeSurge, AppColors.cyanGlow, AppColors.goldXP],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildMonthlyMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyanGlow.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aylık İlerleme',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kazanılan XP', style: TextStyle(color: Colors.white70)),
              Text('${appState.totalXP}', style: const TextStyle(color: AppColors.goldXP, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (appState.totalXP % 1000) / 1000.0,
              backgroundColor: AppColors.primaryVoid,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyanGlow),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgottenRituals() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonPulse),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.neonPulse),
              SizedBox(width: 8),
              Text(
                'UNUTULAN RİTÜELLER',
                style: TextStyle(color: AppColors.neonPulse, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz analiz edilmediğin için unutulan ritüelin yok. Seni daha tanımıyorum.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProactiveAICard() {
    final bool isLimitReached = _acceptedEpicQuests >= 3;
    final currentQuest = isLimitReached ? _epicQuests.last : _epicQuests[_acceptedEpicQuests];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surfaceHigh, AppColors.cyanGlow.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyanGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEXUS SANA ÖZEL BİR GÖREV OLUŞTURDU',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryVoid,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, color: AppColors.cyanGlow, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentQuest['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text('+${currentQuest['xp']} XP', style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLimitReached ? null : () {
                appState.addQuest(Quest(
                  id: 'epic_${DateTime.now().millisecondsSinceEpoch}',
                  title: currentQuest['title'] as String,
                  subtitle: 'Nexus Destansı Önerisi',
                  xp: currentQuest['xp'] as int,
                  category: currentQuest['category'] as String,
                  icon: Icons.auto_awesome,
                  color: AppColors.cyanGlow,
                ));
                setState(() {
                  _acceptedEpicQuests++;
                });
                _confettiController.play();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Destansı görev ana ekrana eklendi!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isLimitReached ? AppColors.surfaceLow : AppColors.cyanGlow,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                isLimitReached ? 'GÜNLÜK DESTANSI GÖREV SINIRINI DOLDURDUNUZ' : 'DESTANSI GÖREVİ KABUL ET ->',
                style: TextStyle(
                  color: isLimitReached ? Colors.white54 : AppColors.primaryVoid, 
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
