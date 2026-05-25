import 'package:flutter/material.dart';
import 'chofer_theme.dart';

class ResumenJornadaChofer extends StatelessWidget {
  const ResumenJornadaChofer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ChoferThemeProvider.of(context);
    final t = CT(theme.isDark);
    final wide = MediaQuery.of(context).size.width >= 900;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: t.bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: wide
            ? Row(
                children: [
                  _SideNav(t: t, theme: theme),
                  Expanded(child: _buildContent(context, t, theme)),
                ],
              )
            : Column(
                children: [
                  _TopBar(t: t, theme: theme),
                  Expanded(child: _buildContent(context, t, theme)),
                ],
              ),
        bottomNavigationBar: wide ? null : _buildBottomNav(t),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CT t, ChoferThemeNotifier theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Text(
            'Resumen de Jornada',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: t.isDark ? const Color(0xFF4EDEA3) : t.primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hoy, 24 de Octubre de 2023',
            style: TextStyle(fontSize: 16, color: t.textSecondary),
          ),
          const SizedBox(height: 24),

          // ── Stats bento ────────────────────────────────────────────────────
          LayoutBuilder(
            builder: (_, c) {
              final two = c.maxWidth > 500;
              return Column(
                children: [
                  // Fila 1
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _HeroStatCard(
                          t: t,
                          label: 'Ingresos Totales',
                          value: 'Bs. 485.50',
                          valueColor: t.emerald,
                          height: 130,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (two) ...[
                        Expanded(
                          child: _IconStatCard(
                            t: t,
                            icon: Icons.schedule_rounded,
                            iconColor: t.infoBlue,
                            value: '8h 14m',
                            label: 'Duración',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _IconStatCard(
                            t: t,
                            icon: Icons.route_rounded,
                            iconColor: t.amber,
                            value: '12',
                            label: 'Viajes',
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!two) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _IconStatCard(
                            t: t,
                            icon: Icons.schedule_rounded,
                            iconColor: t.infoBlue,
                            value: '8h 14m',
                            label: 'Duración',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _IconStatCard(
                            t: t,
                            icon: Icons.route_rounded,
                            iconColor: t.amber,
                            value: '12',
                            label: 'Viajes',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // ── Desglose ────────────────────────────────────────────────────────
          Text(
            'Desglose de Pasajeros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: t.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _DesgloseTile(
            t: t,
            icon: Icons.group,
            iconColor: t.isDark ? const Color(0xFF4EDEA3) : t.primary,
            label: 'General',
            count: '142',
            total: 'Bs. 284.00',
            totalColor: t.isDark ? const Color(0xFF4EDEA3) : t.primary,
          ),
          const SizedBox(height: 10),
          _DesgloseTile(
            t: t,
            icon: Icons.school,
            iconColor: t.infoBlue,
            label: 'Estudiante',
            count: '85',
            total: 'Bs. 85.00',
            totalColor: t.infoBlue,
          ),
          const SizedBox(height: 10),
          _DesgloseTile(
            t: t,
            icon: Icons.elderly,
            iconColor: t.amber,
            label: 'Tercera Edad',
            count: '32',
            total: 'Bs. 48.00',
            totalColor: t.amber,
          ),

          const SizedBox(height: 28),

          // ── Acciones ────────────────────────────────────────────────────────
          LayoutBuilder(
            builder: (_, c) {
              final row = c.maxWidth > 500;
              final finBtn = SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/chofer',
                    (_) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: t.primary.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.done_all),
                  label: const Text(
                    'Finalizar Jornada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              );
              final repBtn = SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: t.primary,
                    side: BorderSide(color: t.outline.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Enviar Reporte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              );

              if (row) {
                return Row(
                  children: [
                    Expanded(child: repBtn),
                    const SizedBox(width: 14),
                    Expanded(child: finBtn),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [finBtn, const SizedBox(height: 10), repBtn],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(CT t) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: t.navBg,
        border: Border(
          top: BorderSide(color: t.navBorder.withValues(alpha: 0.4)),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Principal',
                active: false,
                t: t,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'Historial',
                active: true,
                t: t,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Billetera',
                active: false,
                t: t,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Ajustes',
                active: false,
                t: t,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final CT t;
  final ChoferThemeNotifier theme;
  const _TopBar({required this.t, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(
          bottom: BorderSide(color: t.navBorder.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: t.primaryFixed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumen de Jornada',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: t.primaryFixed,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: theme.toggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: t.toggleBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: t.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        t.isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        key: ValueKey(t.isDark),
                        color: t.toggleIcon,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Side Nav ───────────────────────────────────────────────────────────────────
class _SideNav extends StatelessWidget {
  final CT t;
  final ChoferThemeNotifier theme;
  const _SideNav({required this.t, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: 240,
      decoration: BoxDecoration(
        color: t.isDark ? const Color(0xFF0A1628) : Colors.white,
        border: Border(
          right: BorderSide(color: t.navBorder.withValues(alpha: 0.3)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: t.primaryFixed,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Resumen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.primaryFixed,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: theme.toggle,
                    child: Icon(
                      t.isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: t.toggleIcon,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: t.navBorder.withValues(alpha: 0.3)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  _SideItem(
                    icon: Icons.bar_chart,
                    label: 'Estadísticas',
                    active: true,
                    t: t,
                  ),
                  _SideItem(
                    icon: Icons.route,
                    label: 'Rutas',
                    active: false,
                    t: t,
                  ),
                  _SideItem(
                    icon: Icons.support_agent,
                    label: 'Soporte',
                    active: false,
                    t: t,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/chofer',
                  (_) => false,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: t.errorDark, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: t.errorDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final CT t;
  const _SideItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFDAE2FD).withValues(alpha: t.isDark ? 0.15 : 1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: active ? t.primary : t.textSecondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? t.primary : t.textSecondary,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat cards ─────────────────────────────────────────────────────────────────
class _HeroStatCard extends StatelessWidget {
  final CT t;
  final String label, value;
  final Color valueColor;
  final double height;
  const _HeroStatCard({
    required this.t,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
        boxShadow: t.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: t.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconStatCard extends StatelessWidget {
  final CT t;
  final IconData icon;
  final Color iconColor;
  final String value, label;
  const _IconStatCard({
    required this.t,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
        boxShadow: t.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: t.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: t.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesgloseTile extends StatelessWidget {
  final CT t;
  final IconData icon;
  final Color iconColor;
  final String label, count, total;
  final Color totalColor;
  const _DesgloseTile({
    required this.t,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.count,
    required this.total,
    required this.totalColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: t.isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: t.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: t.textPrimary,
              ),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              color: t.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 90,
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: totalColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final CT t;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: active
            ? BoxDecoration(
                color: t.navActiveBg,
                borderRadius: BorderRadius.circular(999),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? t.navActiveText : t.navInactive,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? t.navActiveText : t.navInactive,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
