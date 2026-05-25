import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PROVEEDOR DE TEMA GLOBAL PARA PANTALLAS DEL CHOFER
// Uso: ChoferThemeProvider.of(context).isDark
//      ChoferThemeProvider.of(context).toggle()
// ══════════════════════════════════════════════════════════════════════════════

class ChoferThemeProvider extends InheritedNotifier<ChoferThemeNotifier> {
  const ChoferThemeProvider({
    super.key,
    required ChoferThemeNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ChoferThemeNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ChoferThemeProvider>();
    assert(provider != null, 'No ChoferThemeProvider found in context');
    return provider!.notifier!;
  }
}

class ChoferThemeNotifier extends ChangeNotifier {
  bool _isDark = true; // Oscuro por defecto (diseño original)

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setDark(bool value) {
    if (_isDark != value) {
      _isDark = value;
      notifyListeners();
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOKENS DE COLOR
// ══════════════════════════════════════════════════════════════════════════════
class CT {
  final bool isDark;
  const CT(this.isDark);

  // Fondos
  Color get bg => isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  Color get surface =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFF4FBF4);
  Color get surfaceCont =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFE8F0E9);
  Color get card =>
      isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
  Color get cardBorder =>
      isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0);

  // Textos
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF161D19);
  Color get textSecondary =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF3C4A42);
  Color get textHint =>
      isDark ? const Color(0xFF64748B) : const Color(0xFF6C7A71);

  // Marca
  Color get primary => const Color(0xFF006C49);
  Color get primaryFixed =>
      isDark ? const Color(0xFF6FFBBE) : const Color(0xFF006C49);
  Color get primaryFixedDim => const Color(0xFF4EDEA3);
  Color get emerald => const Color(0xFF10B981);
  Color get infoBlue => const Color(0xFF3B82F6);
  Color get amber => const Color(0xFFF59E0B);
  Color get errorRed => const Color(0xFFEF4444);
  Color get errorDark => const Color(0xFFBA1A1A);

  // Teclado / PIN
  Color get keyBg =>
      isDark ? Colors.white.withValues(alpha: 0.07) : const Color(0xFFF4FBF4);
  Color get keyBgPressed =>
      isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFDDE4DD);
  Color get keyBorder =>
      isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE2E8F0);
  Color get keyText => isDark ? Colors.white : const Color(0xFF161D19);
  Color get delColor =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF3C4A42);

  // PIN dots
  Color get dotFilled =>
      isDark ? const Color(0xFF6FFBBE) : const Color(0xFF10B981);
  Color get dotEmpty => const Color(0xFFBBCABF);
  Color get pinBoxBg =>
      isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE8F0E9);

  // Nav bar
  Color get navBg => isDark ? const Color(0xFF0F172A) : const Color(0xFFE8F0E9);
  Color get navBorder =>
      isDark ? const Color(0xFF6C7A71) : const Color(0xFFBBCABF);
  Color get navInactive =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF3C4A42);
  Color get navActiveBg => const Color(0xFF10B981);
  Color get navActiveText => const Color(0xFF002113);

  // Outline
  Color get outline =>
      isDark ? const Color(0xFF6C7A71) : const Color(0xFFBBCABF);

  // Botón toggle esquina
  Color get toggleBg =>
      isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE8F0E9);
  Color get toggleIcon =>
      isDark ? const Color(0xFF6FFBBE) : const Color(0xFF006C49);
}
