import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'quest_board_screen.dart';
import 'skills_screen.dart';
import 'social_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import '../widgets/companion_overlay.dart';
import '../state/app_state.dart';

class MainNavigationScreen extends StatefulWidget {
  final String heroName;

  const MainNavigationScreen({super.key, this.heroName = 'DIGITAL ALCHEMIST'});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _companionInitialized = false;

  List<Widget> get _screens => [
    HomeScreen(
      onNavigateToQuests: () {
        setState(() {
          _currentIndex = 1;
        });
      },
    ),
    const QuestBoardScreen(),
    const SkillsScreen(),
    const SocialScreen(),
    const LeaderboardScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_companionInitialized) {
      _companionInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CompanionOverlay.show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryVoid.withOpacity(0.8),
            border: Border(bottom: BorderSide(color: AppColors.cyanGlow.withOpacity(0.1))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surfaceHigh,
                                    border: Border.all(
                                      color: AppColors.cyanGlow.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.cyanGlow.withOpacity(0.3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                    size: 24,
                                  ),
                                ),
                                Positioned(
                                  bottom: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.cyanGlow,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.primaryVoid),
                                    ),
                                    child: AnimatedBuilder(
                                      animation: appState,
                                      builder: (context, _) {
                                        return Text(
                                          'LVL ${appState.userLevel}',
                                          style: const TextStyle(
                                            color: AppColors.primaryVoid,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.heroName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'LIFEQUEST',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: AppColors.cyanGlow,
                          shadows: [
                            Shadow(
                              color: AppColors.cyanGlow.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '0 GÜNLÜK SERİ',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.surfaceLow.withOpacity(0.9),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.cyanGlow.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanGlow.withOpacity(0.15),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home, 'Ana'),
                  _buildNavItem(1, Icons.sports_martial_arts, 'Görevler'),
                  _buildNavItem(2, Icons.bolt, 'Yetenekler'),
                  _buildNavItem(3, Icons.group, 'Sosyal'),
                  _buildNavItem(4, Icons.leaderboard, 'Sıralama'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconData, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanGlow.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected ? AppColors.cyanGlow : const Color(0xFFE2E4F6).withOpacity(0.4),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.cyanGlow : const Color(0xFFE2E4F6).withOpacity(0.4),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
