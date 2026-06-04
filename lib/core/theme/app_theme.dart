import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Top-level getter to provide theme
ThemeData get lightTheme => _buildLightTheme();

// Core palette — Dark Luxury
const Color primaryColor = Color(0xFFD4AF37); // Antique Gold
const Color primaryLight = Color(0xFFEDD96A);
const Color primaryDark = Color(0xFFAA8C2C);

const Color backgroundDark = Color(0xFF0D0D0F); // Near-black
const Color surfaceDark = Color(0xFF181820); // Dark surface
const Color surfaceElevated = Color(0xFF21212D); // Cards
const Color surfaceHighlight = Color(0xFF2A2A38); // Hover/selected

const Color accentGreen = Color(0xFF00E5A0); // Mint green
const Color accentRed = Color(0xFFFF5252);
const Color accentBlue = Color(0xFF5B9CF6);

const Color textPrimary = Color(0xFFF0EFE8); // Warm white
const Color textSecondary = Color(0xFF9E9DAD); // Muted lavender-grey
const Color textTertiary = Color(0xFF5C5B6E);
const Color dividerColor = Color(0xFF252535);
const Color borderColor = Color(0xFF2D2D3F);

// Category colors — jewel tones
const Color categoryFood = Color(0xFFFF6B6B);
const Color categoryTravel = Color(0xFF4ECDC4);
const Color categoryShopping = Color(0xFFD4AF37);
const Color categoryBills = Color(0xFF95E1D3);
const Color categoryHealth = Color(0xFF8B82F6);
const Color categoryEntertainment = Color(0xFFFF9F43);
const Color categoryGroceries = Color(0xFF55EFC4);
const Color categoryFuel = Color(0xFFFF7675);

const Color backgroundColor = backgroundDark;
const Color surfaceColor = surfaceElevated;
const Color errorColor = accentRed;
const Color successColor = accentGreen;

ThemeData _buildLightTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Color(0xFF0D0D0F),
        secondary: accentBlue,
        onSecondary: Colors.white,
        tertiary: accentGreen,
        error: accentRed,
        onError: Colors.white,
        surface: surfaceElevated,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: backgroundDark,
        foregroundColor: textPrimary,
        centerTitle: false,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.15,
        ),
        displaySmall: GoogleFonts.dmSerifDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: const Color(0xFF0D0D0F),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Color(0xFF0D0D0F),
        elevation: 12,
      ),
    );
