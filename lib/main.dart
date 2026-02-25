// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/login_screen.dart';

void main() {
  runApp(
    // ProviderScope is required by Riverpod — it stores all provider state.
    const ProviderScope(
      child: DarazApp(),
    ),
  );
}

class DarazApp extends StatelessWidget {
  const DarazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daraz Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE63329), // Daraz red
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
