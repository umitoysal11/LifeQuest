import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const LifeQuestApp());
}

class LifeQuestApp extends StatelessWidget {
  const LifeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.primaryVoid,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyanGlow,
          surface: AppColors.surfaceLow,
          background: AppColors.primaryVoid,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const RegisterScreen(),
    );
  }
}

