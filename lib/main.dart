import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const KantinBuSariApp());
}

class KantinBuSariApp extends StatelessWidget {
  const KantinBuSariApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Skema warna baru bernuansa Deep Forest Pine & Warm Terracotta (elegan, tidak pasaran)
    const primaryColor = Color(0xFF0F4C3A); // Deep Pine Green
    const secondaryColor = Color(0xFFE05A47); // Warm Terracotta

    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0), // Soft warm alabaster
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF162A20),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFEBE6DC), width: 1),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
