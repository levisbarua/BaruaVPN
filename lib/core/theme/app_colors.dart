import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0E1A);
  static const Color backgroundSecondary = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF131D33);
  static const Color cardDark = Color(0xFF16203A);
  static const Color cardBorder = Color(0x2E00D2FF);

  // Neon & Glow Accents
  static const Color primaryCyan = Color(0xFF00D2FF);
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color electricViolet = Color(0xFF7928CA);
  static const Color softBlue = Color(0xFF4FACFE);

  // Status Colors
  static const Color connectedGreen = Color(0xFF00F298);
  static const Color connectedGreenGlow = Color(0x6600F298);
  static const Color connectingAmber = Color(0xFFFFB020);
  static const Color connectingAmberGlow = Color(0x66FFB020);
  static const Color disconnectedGray = Color(0xFF62728F);
  static const Color errorRed = Color(0xFFFF4D6D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glassmorphism Fills & Gradients
  static const Color glassFill = Color(0x1AFFFFFF);
  static const Color glassFillDark = Color(0x330F172A);
  static const Color glassBorder = Color(0x26FFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryCyan, primaryBlue],
  );

  static const LinearGradient neonPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryCyan, electricViolet],
  );

  static const LinearGradient connectedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00F298), Color(0xFF00B074)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x261E293B), Color(0x140F172A)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0E1A), Color(0xFF080B14), Color(0xFF05070D)],
  );

  static const LinearGradient buttonPulseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x3300D2FF), Color(0x110066FF)],
  );
}
