import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class ActiveQuestsScreen extends StatelessWidget {
  const ActiveQuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final quests = appState.activeQuests;

        return Scaffold(
          backgroundColor: AppColors.primaryVoid,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'TÜM AKTİF GÖREVLER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            centerTitle: true,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Background Orbs
              Positioned(
                top: 50,
                left: -100,
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
                right: -100,
                child: Container(
                  width: 250,
                  height: 250,
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
              
              // Quest List
              if (quests.isEmpty)
                const Center(
                  child: Text(
                    'Aktif görev bulunmuyor. Yeni bir görev oluştur!',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                )
              else
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 100, 24, 48),
                  itemCount: quests.length,
                  itemBuilder: (context, index) {
                    final quest = quests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141928), // surface-container
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
                                  const SizedBox(height: 4),
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
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
