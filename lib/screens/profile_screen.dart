import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedFrequency = 'Haftalık';
  String? _customDate;

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
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 4)),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.cyanGlow),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'PROFİL DETAYLARI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: AppColors.cyanGlow,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceHigh,
                        border: Border.all(
                          color: AppColors.cyanGlow,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(color: AppColors.cyanGlow.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      appState.heroName.toUpperCase(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cyanGlow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cyanGlow),
                      ),
                      child: Text(
                        'LVL ${appState.userLevel}',
                        style: const TextStyle(color: AppColors.cyanGlow, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // User Info Cards
              _buildInfoCard(Icons.cake, 'YAŞ', '${appState.heroAge}'),
              const SizedBox(height: 12),
              _buildInfoCard(Icons.location_on, 'KONUM', appState.heroLocation.isEmpty ? 'Belirtilmedi' : appState.heroLocation),
              const SizedBox(height: 12),
              _buildInfoCard(Icons.work, 'SEKTÖR', appState.heroSector.isEmpty ? 'Belirtilmedi' : appState.heroSector),
              const SizedBox(height: 32),

              // Life Report Frequency
              const Text(
                'YAŞAM RAPORU SIKLIĞI',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              _buildFrequencyOption('Günlük'),
              const SizedBox(height: 12),
              _buildFrequencyOption('Haftalık'),
              const SizedBox(height: 12),
              _buildFrequencyOption('Aylık'),
              const SizedBox(height: 12),
              _buildCustomDateOption(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cyanGlow.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cyanGlow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.cyanGlow, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption(String title) {
    final isSelected = _selectedFrequency == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanGlow.withOpacity(0.1) : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.cyanGlow : AppColors.surfaceLow),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.cyanGlow : Colors.white54,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDateOption() {
    final isSelected = _selectedFrequency == 'Özel Tarih';
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = 'Özel Tarih';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanGlow.withOpacity(0.1) : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.cyanGlow : AppColors.surfaceLow),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.cyanGlow : Colors.white54,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Özel Tarih',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (_customDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Seçilen: $_customDate',
                      style: const TextStyle(color: AppColors.cyanGlow, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month, color: AppColors.cyanGlow),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileDateScreen()),
                );
                if (result != null && result is String) {
                  setState(() {
                    _customDate = result;
                    _selectedFrequency = 'Özel Tarih';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDateScreen extends StatefulWidget {
  const ProfileDateScreen({super.key});

  @override
  State<ProfileDateScreen> createState() => _ProfileDateScreenState();
}

class _ProfileDateScreenState extends State<ProfileDateScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TARİH SEÇİMİ', style: TextStyle(color: AppColors.cyanGlow, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        backgroundColor: AppColors.primaryVoid,
        iconTheme: const IconThemeData(color: AppColors.cyanGlow),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.cyanGlow,
                  onPrimary: AppColors.primaryVoid,
                  surface: AppColors.surfaceHigh,
                  onSurface: Colors.white,
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyanGlow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final formattedDate = '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';
                  Navigator.pop(context, formattedDate);
                },
                child: const Text('ONAYLA', style: TextStyle(color: AppColors.primaryVoid, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
