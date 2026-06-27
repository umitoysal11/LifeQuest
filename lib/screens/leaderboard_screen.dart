import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isLocalSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          final location = appState.heroLocation.isNotEmpty ? appState.heroLocation : 'Yerel';
          final players = _isLocalSelected ? appState.getLocalLeaderboard() : appState.getGlobalLeaderboard();
          
          // Find user rank and index in the active list
          final userIndex = players.indexWhere((p) => p['isUser'] == true);
          final userRank = userIndex != -1 ? userIndex + 1 : 42;

          // Split list into Podium (top 3) and remaining list
          final podiumPlayers = players.take(3).toList();
          final listPlayers = players.skip(3).toList();

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: [
                  const SizedBox(height: 12),
                  // Toggle Buttons for Global / Local
                  _buildToggleButtons(location),
                  const SizedBox(height: 24),
                  
                  // Podium of Top 3
                  if (podiumPlayers.isNotEmpty)
                    _buildPodium(podiumPlayers),
                  
                  const SizedBox(height: 24),
                  
                  // Remaining players list
                  if (listPlayers.isNotEmpty)
                    _buildRankingList(listPlayers, 4),

                  const SizedBox(height: 160), // Space for sticky badge and bottom nav
                ],
              ),
              Positioned(
                bottom: 100, // Float above bottom navigation bar
                left: 16,
                right: 16,
                child: _buildStickyUserBadge(userRank, appState.totalXP),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleButtons(String location) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLocalSelected = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !_isLocalSelected ? AppColors.cyanGlow : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'KÜRESEL',
                  style: TextStyle(
                    color: !_isLocalSelected ? AppColors.primaryVoid : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLocalSelected = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isLocalSelected ? AppColors.cyanGlow : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'YEREL (${location.toUpperCase()})',
                  style: TextStyle(
                    color: _isLocalSelected ? AppColors.primaryVoid : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<Map<String, dynamic>> podiumPlayers) {
    // Reorder list for podium display: [Rank 2, Rank 1, Rank 3]
    final ordered = <Map<String, dynamic>?>[null, null, null];
    if (podiumPlayers.length > 0) ordered[1] = podiumPlayers[0]; // 1st
    if (podiumPlayers.length > 1) ordered[0] = podiumPlayers[1]; // 2nd
    if (podiumPlayers.length > 2) ordered[2] = podiumPlayers[2]; // 3rd

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        if (ordered[0] != null)
          Expanded(
            child: _buildPodiumBar(
              rank: 2,
              height: 100,
              color: AppColors.cyanGlow,
              name: ordered[0]!['name'] as String,
              xp: ordered[0]!['xp'] as int,
              isSelf: ordered[0]!['isUser'] as bool,
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 8),

        // 1st Place
        if (ordered[1] != null)
          Expanded(
            child: _buildPodiumBar(
              rank: 1,
              height: 140,
              color: AppColors.goldXP,
              name: ordered[1]!['name'] as String,
              xp: ordered[1]!['xp'] as int,
              isFirst: true,
              isSelf: ordered[1]!['isUser'] as bool,
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 8),

        // 3rd Place
        if (ordered[2] != null)
          Expanded(
            child: _buildPodiumBar(
              rank: 3,
              height: 85,
              color: AppColors.neonPulse,
              name: ordered[2]!['name'] as String,
              xp: ordered[2]!['xp'] as int,
              isSelf: ordered[2]!['isUser'] as bool,
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildPodiumBar({
    required int rank,
    required double height,
    required Color color,
    required String name,
    required int xp,
    bool isFirst = false,
    bool isSelf = false,
  }) {
    return Column(
      children: [
        if (isFirst)
          const Icon(Icons.emoji_events, color: AppColors.goldXP, size: 36)
        else
          const SizedBox(height: 36),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: isSelf ? AppColors.limeSurge : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          '$xp XP',
          style: TextStyle(color: isSelf ? AppColors.limeSurge : color, fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: isSelf ? AppColors.limeSurge.withOpacity(0.15) : color.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: isSelf ? AppColors.limeSurge : color, width: isSelf ? 2 : 1),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: isSelf ? AppColors.limeSurge : color,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList(List<Map<String, dynamic>> players, int startRank) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final p = players[index];
        final rank = startRank + index;
        final isSelf = p['isUser'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelf ? AppColors.limeSurge.withOpacity(0.08) : AppColors.surfaceHigh.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelf ? AppColors.limeSurge : Colors.white.withOpacity(0.05),
              width: isSelf ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    color: isSelf ? AppColors.limeSurge : Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryVoid,
                  border: Border.all(color: isSelf ? AppColors.limeSurge : Colors.white24),
                ),
                child: Icon(Icons.person, color: isSelf ? AppColors.limeSurge : Colors.white70, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'] as String,
                      style: TextStyle(
                        color: isSelf ? AppColors.limeSurge : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (p['title'] as String).toUpperCase(),
                      style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              Text(
                '${p['xp']} XP',
                style: TextStyle(
                  color: isSelf ? AppColors.limeSurge : AppColors.cyanGlow,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyUserBadge(int userRank, int userXp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldXP, width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.goldXP.withOpacity(0.25), blurRadius: 15, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          Text(
            '#$userRank',
            style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(width: 16),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHigh,
              border: Border.all(color: AppColors.goldXP),
            ),
            child: const Icon(Icons.person, color: AppColors.goldXP, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appState.heroName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  appState.heroLocation.toUpperCase(),
                  style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            '$userXp XP',
            style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
