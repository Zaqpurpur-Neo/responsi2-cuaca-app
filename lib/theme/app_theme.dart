import 'package:flutter/material.dart';

class AppTheme {
  // Identitas warna: Teal/Biru Laut sebagai utama, Kuning hangat sebagai aksen
  static const Color primaryColor = Color(0xFF00838F);
  static const Color accentColor = Color(0xFFFFCA28);

  // Tema Terang (Light Mode)
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: accentColor,
    );
    return _buildTheme(colorScheme);
  }

  // Tema Gelap (Dark Mode)
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: accentColor,
    );
    return _buildTheme(colorScheme);
  }

  // Fungsi internal untuk membangun ThemeData (menghindari duplikasi kode)
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography: Suhu sangat besar & tipis, teks body mudah dibaca
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w200,
          letterSpacing: -2,
        ),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      ),

      // CardThemeData: Sudut sangat membulat (28), tanpa shadow tajam, warna permukaan lembut
      // PERBAIKAN: CardTheme -> CardThemeData (Flutter 3.22+)
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        color: colorScheme.surface,
      ),

      // InputDecorationTheme: Search bar berbentuk pil (rounded)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),

      // AppBarTheme: Area atas yang lega (toolbarHeight besar), judul besar, tanpa shadow
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 80, // Memberikan ruang kosong yang lega di atas
        titleSpacing: 24,
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // NavigationBarTheme: Gaya M3 dengan sudut membulat
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      // ChipTheme: Bentuk pil (stadium)
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
