import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'skills_screen.dart';
import 'active_quests_screen.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToQuests;
  
  const HomeScreen({super.key, this.onNavigateToQuests});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Orbs
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 384,
            height: 384,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cyanGlow.withOpacity(0.1),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 160,
          right: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonPulse.withOpacity(0.1),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: MediaQuery.of(context).size.width / 4,
          child: Container(
            width: 256,
            height: 256,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.limeSurge.withOpacity(0.05),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        
        // Main Content
        ListView(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 128.0),
          children: [
            const SkillGrid(),
            const SizedBox(height: 48),
            ActiveQuestList(onAddQuestTap: onNavigateToQuests),
          ],
        ),
      ],
    );
  }
}

class SkillGrid extends StatelessWidget {
  const SkillGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final skills = [
          {
            'name': 'Kişisel Gelişim',
            'key': 'KİŞİSEL GELİŞİM',
            'level': appState.getSkillLevel('KİŞİSEL GELİŞİM'),
            'xp': appState.getSkillXp('KİŞİSEL GELİŞİM'),
            'progress': (appState.getSkillXp('KİŞİSEL GELİŞİM') % 100) / 100.0,
            'icon': Icons.self_improvement,
            'color': AppColors.neonPulse
          },
          {
            'name': 'Fiziksel Gelişim',
            'key': 'FİZİKSEL GELİŞİM',
            'level': appState.getSkillLevel('FİZİKSEL GELİŞİM'),
            'xp': appState.getSkillXp('FİZİKSEL GELİŞİM'),
            'progress': (appState.getSkillXp('FİZİKSEL GELİŞİM') % 100) / 100.0,
            'icon': Icons.fitness_center,
            'color': AppColors.limeSurge
          },
          {
            'name': 'Zihinsel Gelişim',
            'key': 'ZİHİNSEL GELİŞİM',
            'level': appState.getSkillLevel('ZİHİNSEL GELİŞİM'),
            'xp': appState.getSkillXp('ZİHİNSEL GELİŞİM'),
            'progress': (appState.getSkillXp('ZİHİNSEL GELİŞİM') % 100) / 100.0,
            'icon': Icons.psychology,
            'color': AppColors.cyanGlow
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TEMEL YETENEKLER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cyanGlow.withOpacity(0.7),
                    letterSpacing: 2.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SkillsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cyanGlow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'DETAYLARI GÖR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.cyanGlow,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.cyanGlow.withOpacity(0.8),
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...skills.map((skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(color: AppColors.cyanGlow.withOpacity(0.2)),
                        left: BorderSide(color: AppColors.cyanGlow.withOpacity(0.1)),
                        right: const BorderSide(color: Colors.transparent),
                        bottom: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: (skill['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            skill['icon'] as IconData,
                            color: skill['color'] as Color,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (skill['name'] as String).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    'LVL ${skill['level']} (${skill['xp']} XP)',
                                    style: TextStyle(
                                      color: skill['color'] as Color,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: skill['progress'] as double,
                                  backgroundColor: Colors.black, // surface-container-lowest
                                  valueColor: AlwaysStoppedAnimation<Color>(skill['color'] as Color),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}

class ActiveQuestList extends StatelessWidget {
  final VoidCallback? onAddQuestTap;
  const ActiveQuestList({super.key, this.onAddQuestTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final quests = appState.activeQuests.take(3).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.view_agenda, color: AppColors.cyanGlow, size: 32),
                    const SizedBox(width: 8),
                    const Text(
                      'AKTİF ANA\nGÖREVLER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ActiveQuestsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cyanGlow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'TÜMÜNÜ GÖR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.cyanGlow,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.cyanGlow.withOpacity(0.8),
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (quests.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Aktif görev bulunmuyor. Yeni bir görev oluştur!',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              )
            else
              ...quests.map((quest) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141928), // surface-container
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: quest.color.withOpacity(0.2)),
                          ),
                          child: Icon(
                            quest.icon,
                            color: quest.color, 
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quest.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                quest.subtitle,
                                style: const TextStyle(
                                  color: Color(0xFFA7AABB),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+${quest.xp} XP',
                              style: const TextStyle(
                                color: AppColors.goldXP,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'YETENEK: ${quest.category}',
                              style: const TextStyle(
                                color: Color(0xFFA7AABB),
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => appState.completeQuest(quest.id),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.limeSurge.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.limeSurge.withOpacity(0.5)),
                            ),
                            child: const Icon(Icons.check, color: AppColors.limeSurge, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 8),
            InkWell(
              onTap: onAddQuestTap ?? () {},
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyanGlow.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle, color: AppColors.cyanGlow, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'YENİ GÖREV OLUŞTUR',
                      style: TextStyle(
                        color: AppColors.cyanGlow,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
