import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import 'main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  late AnimationController _nameBorderController;
  late AnimationController _locationBorderController;
  late AnimationController _passwordBorderController;

  int _selectedAge = 18;
  String? _selectedSector;

  final List<String> _sectors = [
    'Teknoloji',
    'Sağlık',
    'Eğitim',
    'Sanat',
    'Spor',
    'Hizmet',
    'Güvenlik',
    'Ticaret',
    'Ulaşım',
    'Serbest Çalışan',
    'Öğrenci',
  ];

  @override
  void initState() {
    super.initState();
    _nameBorderController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _locationBorderController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _passwordBorderController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) _nameBorderController.forward();
      else _nameBorderController.reverse();
    });

    _locationFocus.addListener(() {
      if (_locationFocus.hasFocus) _locationBorderController.forward();
      else _locationBorderController.reverse();
    });

    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) _passwordBorderController.forward();
      else _passwordBorderController.reverse();
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _locationFocus.dispose();
    _passwordFocus.dispose();
    _nameBorderController.dispose();
    _locationBorderController.dispose();
    _passwordBorderController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryVoid,
      body: Stack(
        children: [
          // Background Orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyanGlow.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.limeSurge.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo / Title
                    const Text(
                      'LIFEQUEST',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.cyanGlow,
                        letterSpacing: 4.0,
                        shadows: [
                          Shadow(
                            color: AppColors.cyanGlow,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SİSTEME KAYIT',
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.white54,
                        letterSpacing: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Character Name Input
                    _buildAnimatedInputField(
                      hint: 'KAHRAMANIN ADI',
                      icon: Icons.person_outline,
                      focusNode: _nameFocus,
                      animation: _nameBorderController,
                      controller: _nameController,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    ),
                    const SizedBox(height: 24),
                    
                    // Age Selector
                    _buildAgeSelector(),
                    const SizedBox(height: 24),

                    // Location Input
                    _buildAnimatedInputField(
                      hint: 'BAŞLANGIÇ DİYARI (KONUM)',
                      icon: Icons.location_on_outlined,
                      focusNode: _locationFocus,
                      animation: _locationBorderController,
                      controller: _locationController,
                    ),
                    const SizedBox(height: 24),

                    // Sector Selector
                    _buildSectorSelector(),
                    const SizedBox(height: 24),

                    // Password Input
                    _buildAnimatedInputField(
                      hint: 'ŞİFRE',
                      icon: Icons.lock_outline,
                      focusNode: _passwordFocus,
                      animation: _passwordBorderController,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 64),

                    // Primary Button (Power Cell)
                    GestureDetector(
                      onTap: () {
                        String name = _nameController.text.trim();
                        if (name.isEmpty) name = 'DIGITAL ALCHEMIST';
                        
                        appState.setUserProfile(
                          name: name,
                          age: _selectedAge,
                          location: _locationController.text.trim(),
                          sector: _selectedSector ?? 'Öğrenci',
                        );

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainNavigationScreen(heroName: name),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.cyanGlow, Color(0xFF00F1FE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyanGlow.withOpacity(0.3),
                              blurRadius: 32,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'KAYIT OL',
                            style: TextStyle(
                              color: AppColors.primaryVoid,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.cake_outlined, color: Color(0xFF515463), size: 20),
          const SizedBox(width: 12),
          const Text(
            'YAŞ',
            style: TextStyle(
              color: Color(0xFF515463),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          DropdownButton<int>(
            value: _selectedAge,
            dropdownColor: AppColors.surfaceHigh,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.cyanGlow),
            items: List.generate(83, (i) => i + 13).map((age) {
              return DropdownMenuItem<int>(
                value: age,
                child: Text('$age'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() { _selectedAge = val; });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectorSelector() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.work_outline, color: Color(0xFF515463), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSector,
                isExpanded: true,
                hint: const Text(
                  'SEKTÖR SEÇ',
                  style: TextStyle(
                    color: Color(0xFF515463),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                dropdownColor: AppColors.surfaceHigh,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.cyanGlow),
                items: _sectors.map((sector) {
                  return DropdownMenuItem<String>(
                    value: sector,
                    child: Text(sector),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() { _selectedSector = val; });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedInputField({
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required AnimationController animation,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.black, // surface-container-lowest
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF515463), // inverse-on-surface
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF515463), size: 20),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        // Animated Bottom Border
        Stack(
          children: [
            Container(height: 2, color: AppColors.surfaceHigh, width: double.infinity),
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: animation.value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2,
                    color: AppColors.limeSurge,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
