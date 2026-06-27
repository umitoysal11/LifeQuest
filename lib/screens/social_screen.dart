import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  // Controller for creating a klan
  final TextEditingController _createNameController = TextEditingController();
  final TextEditingController _createDescController = TextEditingController();
  bool _isCreatingKlanFormActive = false;

  // Controllers for editing a klan (only if leader)
  bool _isEditingKlan = false;
  late TextEditingController _editNameController;
  late TextEditingController _editDescController;
  late TextEditingController _editRaidTitleController;
  late TextEditingController _editRaidDescController;

  @override
  void initState() {
    super.initState();
    _editNameController = TextEditingController();
    _editDescController = TextEditingController();
    _editRaidTitleController = TextEditingController();
    _editRaidDescController = TextEditingController();
  }

  @override
  void dispose() {
    _createNameController.dispose();
    _createDescController.dispose();
    _editNameController.dispose();
    _editDescController.dispose();
    _editRaidTitleController.dispose();
    _editRaidDescController.dispose();
    super.dispose();
  }

  void _initEditControllers() {
    _editNameController.text = appState.klanName ?? '';
    _editDescController.text = appState.klanDescription;
    _editRaidTitleController.text = appState.currentRaidTitle;
    _editRaidDescController.text = appState.currentRaidDesc;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        if (appState.klanName == null) {
          return _buildNoKlanScreen();
        }

        if (_isEditingKlan) {
          return _buildEditKlanScreen();
        }

        return _buildKlanDetailsScreen();
      },
    );
  }

  // --- 1. NO KLAN SCREEN ---
  Widget _buildNoKlanScreen() {
    final location = appState.heroLocation.isNotEmpty ? appState.heroLocation : 'Bilinmeyen Konum';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'KLAN MERKEZİ',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Bölgendeki bir klana katıl veya kendi klanını kurarak yüksel!',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          if (!_isCreatingKlanFormActive) ...[
            // Suggested Clans based on location
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.cyanGlow, size: 20),
                const SizedBox(width: 8),
                Text(
                  'BÖLGENDEN KLANLAR ($location)',
                  style: const TextStyle(
                    color: AppColors.cyanGlow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSuggestedKlanCard(
              name: '${location} Koderler Klanı',
              xp: 15400,
              members: 48,
              level: 15,
            ),
            const SizedBox(height: 16),
            _buildSuggestedKlanCard(
              name: 'Siber Koruyucular Guild',
              xp: 8200,
              members: 14,
              level: 8,
            ),
            const SizedBox(height: 40),

            // Button to toggle create klan form
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isCreatingKlanFormActive = true;
                  _createNameController.clear();
                  _createDescController.clear();
                });
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('YENİ KLAN OLUŞTUR', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyanGlow,
                foregroundColor: AppColors.primaryVoid,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ] else ...[
            // Create Klan Form
            _buildCreateKlanForm(),
          ],
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSuggestedKlanCard({
    required String name,
    required int xp,
    required int members,
    required int level,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyanGlow.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyanGlow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                ),
                child: const Text(
                  'MYTHIC GUILD',
                  style: TextStyle(color: AppColors.cyanGlow, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Lv. $level',
                style: const TextStyle(color: AppColors.goldXP, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Toplam Klan XP: $xp',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(width: 16),
              Text(
                'Üyeler: $members/50',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                appState.joinKlan(name, appState.heroLocation);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name klanına başarıyla katıldınız!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeSurge,
                foregroundColor: AppColors.primaryVoid,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('KLANA KATIL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateKlanForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyanGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'KLAN OLUŞTUR',
            style: TextStyle(color: AppColors.cyanGlow, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Klan Name Input
          const Text('KLAN ADI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _createNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryVoid,
              hintText: 'Örn: İzmir Siber Birlik klanı',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          // Klan Description Input
          const Text('KLAN AÇIKLAMASI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _createDescController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryVoid,
              hintText: 'Klanınızın amacını ve kurallarını belirtin...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isCreatingKlanFormActive = false;
                    });
                  },
                  child: const Text('İPTAL', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final name = _createNameController.text.trim();
                    if (name.isNotEmpty) {
                      appState.joinKlan(name, appState.heroLocation, isLeader: true);
                      setState(() {
                        _isCreatingKlanFormActive = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$name klanı başarıyla oluşturuldu!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeSurge,
                    foregroundColor: AppColors.primaryVoid,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('OLUŞTUR', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. KLAN DETAILS SCREEN ---
  Widget _buildKlanDetailsScreen() {
    final name = appState.klanName ?? '';
    final membersCount = appState.klanMemberCount;
    final totalXp = appState.totalKlanXp;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1. Klan Header Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cyanGlow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cyanGlow.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'MYTHIC GUILD',
                      style: TextStyle(color: AppColors.cyanGlow, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.limeSurge,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Toplam Klan XP: ', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      Text('$totalXp', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle, color: Colors.white24, size: 6),
                      const SizedBox(width: 8),
                      const Icon(Icons.group, color: Colors.white54, size: 16),
                      const SizedBox(width: 4),
                      Text('$membersCount/50 Üye', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('15. SV İLERLEMESİ', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('15,400 / 20,000 XP', style: TextStyle(color: Colors.white54, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 15400 / 20000,
                      minHeight: 8,
                      backgroundColor: AppColors.primaryVoid,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.limeSurge),
                    ),
                  ),
                ],
              ),
              // Leader Settings Trigger Button
              if (appState.isKlanLeader)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.cyanGlow),
                    onPressed: () {
                      _initEditControllers();
                      setState(() {
                        _isEditingKlan = true;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Mevcut Baskın Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.neonPulse.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MEVCUT BASKIN',
                style: TextStyle(color: AppColors.neonPulse, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                appState.currentRaidTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                appState.currentRaidDesc,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              // Participant Avatars
              Row(
                children: [
                  _buildMiniAvatar(Colors.orange),
                  Transform.translate(offset: const Offset(-8, 0), child: _buildMiniAvatar(Colors.purple)),
                  Transform.translate(offset: const Offset(-16, 0), child: _buildMiniAvatar(Colors.green)),
                  Transform.translate(
                    offset: const Offset(-24, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryVoid,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceHigh, width: 1.5),
                      ),
                      child: const Text('+12', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Aktif Katılımcılar',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Haftalık Sıralama Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: const [
              Icon(Icons.emoji_events_outlined, color: AppColors.cyanGlow, size: 36),
              SizedBox(height: 12),
              Text(
                'HAFTALIK SIRALAMA',
                style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              SizedBox(height: 6),
              Text(
                '1.',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 4. Klan Üyeleri List
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'KLAN ÜYELERİ',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Text('Sırala: Katkı', style: TextStyle(color: AppColors.cyanGlow, fontSize: 12)),
                  Icon(Icons.arrow_drop_down, color: AppColors.cyanGlow, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Mock Members
        _buildMemberRow('Hero_99', 'USTA MİMAR', 1200, true),
        const SizedBox(height: 12),
        _buildMemberRow('Digital_Aura', 'FULL-STACK BÜYÜCÜ', 980, true),
        const SizedBox(height: 12),
        // Insert user dynamically
        _buildMemberRow(appState.heroName, 'KAHRAMAN', appState.totalXP, true, isSelf: true),
        const SizedBox(height: 12),
        _buildMemberRow('Neo_Smyrna', 'VERİTABANI MUHAFIZI', 850, false),
        const SizedBox(height: 12),
        _buildMemberRow('Binary_Babe', 'MANTIK SİMYACISI', 720, true),
        const SizedBox(height: 12),
        _buildMemberRow('Void_Walker', 'KIDEMSİZ SKRİPT YAZARI', 450, false),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.15)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'TÜM $membersCount ÜYEYİ GÖRÜNTÜLE',
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
            ),
          ),
        ),

        const SizedBox(height: 24),
        // Leave Klan option
        TextButton.icon(
          onPressed: () {
            appState.leaveKlan();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Klandan ayrıldınız.')),
            );
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.redAccent, size: 18),
          label: const Text('KLANDAN AYRIL', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildMiniAvatar(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceHigh, width: 1.5),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 12),
    );
  }

  Widget _buildMemberRow(String name, String role, int xp, bool isActive, {bool isSelf = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withOpacity(isSelf ? 0.8 : 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelf ? AppColors.limeSurge.withOpacity(0.5) : Colors.white.withOpacity(0.05),
          width: isSelf ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryVoid,
                  border: Border.all(color: isSelf ? AppColors.limeSurge : Colors.white24),
                ),
                child: Icon(Icons.person, color: isSelf ? AppColors.limeSurge : Colors.white70, size: 20),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceHigh, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isSelf ? AppColors.limeSurge : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$xp XP',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Text(
                'BU HAFTA',
                style: TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. EDIT KLAN DETAILS SCREEN (LEADER ONLY) ---
  Widget _buildEditKlanScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'KLAN DETAYLARINI DÜZENLE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.cyanGlow,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Klan Name
          const Text('KLAN ADI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _editNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceHigh,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          // Klan Description
          const Text('KLAN AÇIKLAMASI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _editDescController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceHigh,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          // Raid Title
          const Text('MEVCUT BASKIN ADI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _editRaidTitleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceHigh,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          // Raid Description
          const Text('MEVCUT BASKIN AÇIKLAMASI', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _editRaidDescController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceHigh,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isEditingKlan = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('İPTAL', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final name = _editNameController.text.trim();
                    if (name.isNotEmpty) {
                      appState.updateKlan(
                        name: name,
                        desc: _editDescController.text.trim(),
                        raidTitle: _editRaidTitleController.text.trim(),
                        raidDesc: _editRaidDescController.text.trim(),
                      );
                      setState(() {
                        _isEditingKlan = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Klan değişiklikleri kaydedildi!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeSurge,
                    foregroundColor: AppColors.primaryVoid,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('KAYDET', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
