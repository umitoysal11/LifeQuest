import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class QuestBoardScreen extends StatefulWidget {
  const QuestBoardScreen({super.key});

  @override
  State<QuestBoardScreen> createState() => _QuestBoardScreenState();
}

class _QuestBoardScreenState extends State<QuestBoardScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _questController = TextEditingController();
  bool _showDecisionCard = false;
  int _generatedXp = 45;
  String _generatedCategory = 'KİŞİSEL GELİŞİM';
  String _generatedRarity = 'Rare';
  String _savedQuestTitle = '';
  bool _isEditingDecisionCard = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _questController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submitQuest() {
    if (_questController.text.trim().isEmpty) return;

    setState(() {
      _savedQuestTitle = _questController.text.trim();
      _generatedXp = 45; // Default initial value
      _generatedCategory = 'KİŞİSEL GELİŞİM';
      _generatedRarity = Quest.getRarityFromXp(45);
      _showDecisionCard = true;
      _isEditingDecisionCard = false;
    });
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Yeni Görev Oluştur',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildInputField(),
            const SizedBox(height: 16),
            if (_showDecisionCard) _buildDecisionCard(),
            const SizedBox(height: 32),
            const Text(
              'NEXUS Günlük Öneriler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildDailyQuestsGrid(),
            const SizedBox(height: 100),
          ],
        );
      }
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLow),
      ),
      child: TextField(
        controller: _questController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Bugün hangi canavarı alt edeceğiz?...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: AppColors.cyanGlow),
            onPressed: _submitQuest,
          ),
        ),
        onSubmitted: (_) => _submitQuest(),
      ),
    );
  }

  Widget _buildDecisionCard() {
    final rarityColor = Quest.getRarityColor(_generatedRarity);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: rarityColor),
          boxShadow: [
            BoxShadow(color: rarityColor.withOpacity(0.2), blurRadius: 20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome, color: rarityColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _isEditingDecisionCard ? _buildEditForm(rarityColor) : _buildStaticInfo(rarityColor),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingDecisionCard ? Icons.check_circle_outline : Icons.edit,
                    color: AppColors.cyanGlow,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditingDecisionCard = !_isEditingDecisionCard;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Accept Quest Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  appState.addQuest(
                    Quest(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _savedQuestTitle,
                      subtitle: 'Özel Görev',
                      xp: _generatedXp,
                      category: _generatedCategory,
                      icon: Icons.auto_awesome,
                      color: Quest.getRarityColor(_generatedRarity),
                      rarity: _generatedRarity,
                    ),
                  );
                  setState(() {
                    _showDecisionCard = false;
                    _questController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Görev ana ekrana eklendi! +$_generatedXp XP Kazandırdı')),
                  );
                },
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text(
                  'GÖREVİ KABUL ET',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.limeSurge,
                  foregroundColor: AppColors.primaryVoid,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticInfo(Color rarityColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_generatedRarity Görev Algılandı',
          style: TextStyle(color: rarityColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          _savedQuestTitle,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryVoid,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.goldXP),
              ),
              child: Text(
                '+$_generatedXp XP',
                style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryVoid,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rarityColor.withOpacity(0.5)),
              ),
              child: Text(
                _generatedRarity,
                style: TextStyle(color: rarityColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Kategori: $_generatedCategory',
          style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEditForm(Color rarityColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Görev Özelliklerini Düzenle',
          style: TextStyle(color: AppColors.cyanGlow, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        // XP Selection Row
        Row(
          children: [
            const Text(
              'XP: ',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_generatedXp > 10) {
                    _generatedXp = (_generatedXp - 5).clamp(10, 200);
                    _generatedRarity = Quest.getRarityFromXp(_generatedXp);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonPulse.withOpacity(0.5)),
                ),
                child: const Icon(Icons.remove, color: AppColors.neonPulse, size: 16),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$_generatedXp',
              style: const TextStyle(color: AppColors.goldXP, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_generatedXp < 200) {
                    _generatedXp = (_generatedXp + 5).clamp(10, 200);
                    _generatedRarity = Quest.getRarityFromXp(_generatedXp);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.limeSurge.withOpacity(0.5)),
                ),
                child: const Icon(Icons.add, color: AppColors.limeSurge, size: 16),
              ),
            ),
            const SizedBox(width: 12),
            // Rarity Badge (Updating live based on selection)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryVoid,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rarityColor.withOpacity(0.5)),
              ),
              child: Text(
                _generatedRarity,
                style: TextStyle(color: rarityColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Category Dropdown Selection
        Row(
          children: [
            const Text(
              'Kategori: ',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _generatedCategory,
                    dropdownColor: AppColors.surfaceHigh,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.cyanGlow),
                    items: ['FİZİKSEL GELİŞİM', 'ZİHİNSEL GELİŞİM', 'KİŞİSEL GELİŞİM'].map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _generatedCategory = val;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyQuestsGrid() {
    final dailyList = appState.dailyQuests;

    if (dailyList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Tüm günlük görevleri ekledin! 🎉',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: dailyList.length,
      itemBuilder: (context, index) {
        final q = dailyList[index];
        final rarity = Quest.getRarityFromXp(q['xp'] as int);
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (q['color'] as Color).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (q['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(q['icon'] as IconData, color: q['color'] as Color, size: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      final removed = dailyList[index];
                      appState.addQuest(
                        Quest(
                          id: 'daily_${DateTime.now().millisecondsSinceEpoch}_$index',
                          title: removed['title'] as String,
                          subtitle: 'Günlük Öneri',
                          xp: removed['xp'] as int,
                          category: removed['category'] as String,
                          icon: removed['icon'] as IconData,
                          color: removed['color'] as Color,
                          rarity: Quest.getRarityFromXp(removed['xp'] as int),
                        ),
                      );
                      appState.removeDailyQuest(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${removed['title']} ana görevlere eklendi!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cyanGlow.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.add, color: AppColors.cyanGlow, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                q['title'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Category Label
              Text(
                q['category'] as String,
                style: TextStyle(
                  color: (q['color'] as Color).withOpacity(0.7),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+${q['xp']} XP',
                    style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Quest.getRarityColor(rarity).withOpacity(0.15),
                      border: Border.all(color: Quest.getRarityColor(rarity).withOpacity(0.4)),
                    ),
                    child: Text(
                      rarity,
                      style: TextStyle(color: Quest.getRarityColor(rarity), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
