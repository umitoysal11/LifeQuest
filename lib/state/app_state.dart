import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Quest {
  final String id;
  final String title;
  final String subtitle;
  final int xp;
  final String category;
  final IconData icon;
  final Color color;
  final String rarity;
  bool isCompleted;

  Quest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.xp,
    required this.category,
    required this.icon,
    required this.color,
    this.rarity = 'Common',
    this.isCompleted = false,
  });

  static String getRarityFromXp(int xp) {
    if (xp <= 25) return 'Common';
    if (xp <= 60) return 'Rare';
    if (xp <= 100) return 'Epic';
    if (xp <= 150) return 'Legendary';
    return 'Mythic';
  }

  static Color getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return Colors.grey;
      case 'Rare':
        return AppColors.cyanGlow;
      case 'Epic':
        return AppColors.neonPulse;
      case 'Legendary':
        return AppColors.goldXP;
      case 'Mythic':
        return const Color(0xFFFF4500);
      default:
        return Colors.grey;
    }
  }
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  
  AppState._internal() {
    // Initialize suggested daily quests once
    _dailyQuests = [
      {'title': 'Yatağını topla', 'xp': 10, 'icon': Icons.bed, 'color': AppColors.limeSurge, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '2 litre su iç', 'xp': 15, 'icon': Icons.water_drop, 'color': AppColors.cyanGlow, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '10 sayfa kitap oku', 'xp': 25, 'icon': Icons.menu_book, 'color': AppColors.neonPulse, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '30 dakika ders çalış', 'xp': 35, 'icon': Icons.school, 'color': Colors.orangeAccent, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': 'Akşam yemeğini evde hazırla', 'xp': 30, 'icon': Icons.restaurant, 'color': AppColors.limeSurge, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '20 dakika yürüyüş yap', 'xp': 20, 'icon': Icons.directions_walk, 'color': AppColors.neonPulse, 'category': 'FİZİKSEL GELİŞİM'},
      {'title': 'Odanı temizle', 'xp': 40, 'icon': Icons.cleaning_services, 'color': Colors.lightBlueAccent, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '15 dakika meditasyon yap', 'xp': 25, 'icon': Icons.self_improvement, 'color': AppColors.cyanGlow, 'category': 'ZİHİNSEL GELİŞİM'},
      {'title': 'Telefonu 1 saat bırak', 'xp': 20, 'icon': Icons.phone_disabled, 'color': Colors.redAccent, 'category': 'ZİHİNSEL GELİŞİM'},
      {'title': 'Günlük yapılacaklar listesini tamamla', 'xp': 50, 'icon': Icons.checklist, 'color': AppColors.goldXP, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': '8 saat uyu', 'xp': 30, 'icon': Icons.nights_stay, 'color': Colors.indigo, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': 'Duolingo / dil çalış', 'xp': 20, 'icon': Icons.language, 'color': AppColors.limeSurge, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': 'Spor yap (30-45 dk)', 'xp': 45, 'icon': Icons.fitness_center, 'color': AppColors.neonPulse, 'category': 'FİZİKSEL GELİŞİM'},
      {'title': 'Bir arkadaşını veya aileni ara', 'xp': 15, 'icon': Icons.phone, 'color': AppColors.cyanGlow, 'category': 'KİŞİSEL GELİŞİM'},
      {'title': 'Şekerli içecek içme', 'xp': 20, 'icon': Icons.no_drinks, 'color': Colors.orangeAccent, 'category': 'KİŞİSEL GELİŞİM'},
    ];
  }

  // Kullanıcı Profil Bilgileri
  String _heroName = 'DIGITAL ALCHEMIST';
  int _heroAge = 0;
  String _heroLocation = '';
  String _heroSector = '';

  String get heroName => _heroName;
  int get heroAge => _heroAge;
  String get heroLocation => _heroLocation;
  String get heroSector => _heroSector;

  void setUserProfile({
    required String name,
    required int age,
    required String location,
    required String sector,
  }) {
    _heroName = name;
    _heroAge = age;
    _heroLocation = location;
    _heroSector = sector;
    notifyListeners();
  }

  int _totalXP = 0;
  int get totalXP => _totalXP;
  
  // Her 100 XP'de 1 seviye atlar
  int get userLevel => (_totalXP / 100).floor(); 

  // Yetenek bazlı XP'ler
  final Map<String, int> _skillXp = {
    'FİZİKSEL GELİŞİM': 0,
    'ZİHİNSEL GELİŞİM': 0,
    'KİŞİSEL GELİŞİM': 0,
  };

  int getSkillXp(String category) => _skillXp[category] ?? 0;
  int getSkillLevel(String category) => (getSkillXp(category) / 100).floor();

  // Tüm görevler
  final List<Quest> _quests = [];

  List<Quest> get activeQuests => _quests.where((q) => !q.isCompleted).toList();

  // Nexus Günlük Önerileri listesi (Persistent)
  late List<Map<String, dynamic>> _dailyQuests;
  List<Map<String, dynamic>> get dailyQuests => _dailyQuests;

  void removeDailyQuest(int index) {
    if (index >= 0 && index < _dailyQuests.length) {
      _dailyQuests.removeAt(index);
      notifyListeners();
    }
  }

  // klan özellikleri
  String? _klanName;
  String _klanDescription = '';
  String _klanLocation = '';
  int _totalKlanXp = 15400;
  int _klanMemberCount = 48;
  String _currentRaidTitle = 'Monoliti Refaktör Et';
  String _currentRaidDesc = 'Hafta sonu mühletinden önce 50.000 satır eski kodu temizle. +2.000 Klan XP ödülü.';
  bool _isKlanLeader = false;

  String? get klanName => _klanName;
  String get klanDescription => _klanDescription;
  String get klanLocation => _klanLocation;
  int get totalKlanXp => _totalKlanXp;
  int get klanMemberCount => _klanMemberCount;
  String get currentRaidTitle => _currentRaidTitle;
  String get currentRaidDesc => _currentRaidDesc;
  bool get isKlanLeader => _isKlanLeader;

  void joinKlan(String name, String location, {bool isLeader = false}) {
    _klanName = name;
    _klanLocation = location;
    _isKlanLeader = isLeader;
    if (isLeader) {
      _totalKlanXp = 0;
      _klanMemberCount = 1;
      _klanDescription = 'Yeni kurulmuş harika bir klan.';
      _currentRaidTitle = 'Klan Başlangıç Görevi';
      _currentRaidDesc = 'İlk üyelerimizi klanımıza katıp klan seviyemizi yükseltelim.';
    } else {
      _totalKlanXp = 15400;
      _klanMemberCount = 48;
      _klanDescription = 'Kod geliştiricileri ve siberpunk maceracılarının klanı.';
    }
    notifyListeners();
  }

  void updateKlan({
    required String name,
    required String desc,
    required String raidTitle,
    required String raidDesc,
  }) {
    _klanName = name;
    _klanDescription = desc;
    _currentRaidTitle = raidTitle;
    _currentRaidDesc = raidDesc;
    notifyListeners();
  }

  void leaveKlan() {
    _klanName = null;
    notifyListeners();
  }

  // Leaderboard mock users (XP starts at 0 initially)
  final List<Map<String, dynamic>> _mockPlayers = [
    {'name': 'Nexus_Lord', 'xp': 0, 'location': 'İzmir', 'title': 'Usta Mimar'},
    {'name': 'Digital_Aura', 'xp': 0, 'location': 'İstanbul', 'title': 'Full-Stack Büyücü'},
    {'name': 'Neo_Smyrna', 'xp': 0, 'location': 'İzmir', 'title': 'Veritabanı Muhafızı'},
    {'name': 'Binary_Babe', 'xp': 0, 'location': 'Ankara', 'title': 'Mantık Simyacısı'},
    {'name': 'Void_Walker', 'xp': 0, 'location': 'İzmir', 'title': 'Kıdemsiz Skript Yazarı'},
    {'name': 'Cyber_Knight', 'xp': 0, 'location': 'Bursa', 'title': 'Siber Savaşçı'},
    {'name': 'Code_Ghost', 'xp': 0, 'location': 'İstanbul', 'title': 'Gölge Kodlayıcı'},
    {'name': 'Byte_Slayer', 'xp': 0, 'location': 'Antalya', 'title': 'Veri Avcısı'},
  ];

  List<Map<String, dynamic>> getGlobalLeaderboard() {
    final list = <Map<String, dynamic>>[];
    // Add mock players
    for (var p in _mockPlayers) {
      list.add({...p, 'isUser': false});
    }
    // Add user
    list.add({
      'name': _heroName,
      'xp': _totalXP,
      'location': _heroLocation,
      'title': 'KAHRAMAN',
      'isUser': true
    });
    // Sort descending
    list.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));
    return list;
  }

  List<Map<String, dynamic>> getLocalLeaderboard() {
    final globalList = getGlobalLeaderboard();
    final userLoc = _heroLocation.toLowerCase().trim();
    if (userLoc.isEmpty) {
      return globalList; // Fallback to global if user location is empty
    }
    // Filter by matching location name
    final filtered = globalList.where((p) {
      final loc = (p['location'] as String).toLowerCase().trim();
      return loc.contains(userLoc) || userLoc.contains(loc);
    }).toList();
    
    // Sort descending
    filtered.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));
    return filtered;
  }

  void completeQuest(String id) {
    final questIndex = _quests.indexWhere((q) => q.id == id);
    if (questIndex != -1 && !_quests[questIndex].isCompleted) {
      final quest = _quests[questIndex];
      quest.isCompleted = true;
      
      _totalXP += quest.xp;
      
      if (_skillXp.containsKey(quest.category)) {
        _skillXp[quest.category] = _skillXp[quest.category]! + quest.xp;
      } else {
        _skillXp[quest.category] = quest.xp;
      }
      
      // If user in clan, add contributor XP
      if (_klanName != null) {
        _totalKlanXp += quest.xp;
      }
      
      notifyListeners();
    }
  }

  void addQuest(Quest quest) {
    _quests.add(quest);
    notifyListeners();
  }
}

final appState = AppState();
