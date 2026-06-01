import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/api_service.dart';
import 'chofer_theme.dart';
import 'notificacion_pago_chofer.dart';

// ── Modelos ────────────────────────────────────────────────────────────────────
// Removidos por el modelo dinamico del backend

// ── Widget Principal ───────────────────────────────────────────────────────────
class DashboardChofer extends StatefulWidget {
  const DashboardChofer({super.key});
  @override
  State<DashboardChofer> createState() => _DashboardChoferState();
}

class _DashboardChoferState extends State<DashboardChofer>
    with SingleTickerProviderStateMixin {
  int _navIdx = 0;
  late AnimationController _pingCtrl;

  List<dynamic> _recentPayments = [];
  bool _isLoadingPayments = true;
  Timer? _notificationTimer;
  int _dailyPassengers = 0;
  double _dailyCollected = 0.0;
  String? _dailyStatsError;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    _pingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _loadRecentPayments();
    _loadDailyStats();
    _startNotificationPolling();
  }

  Future<void> _loadDailyStats() async {
    try {
      final passRes = await ApiService.getDailyPassengers();
      final colRes = await ApiService.getDailyCollected();
      if (mounted) {
        setState(() {
          _dailyPassengers = (passRes['data'] as num?)?.toInt() ?? 0;
          _dailyCollected = (colRes['data'] as num?)?.toDouble() ?? 0.0;
          _dailyStatsError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _dailyStatsError = e.toString();
        });
      }
      debugPrint('Error cargando estadísticas diarias: $e');
    }
  }

  void _startNotificationPolling() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final res = await ApiService.getUnreadNotifications();
        if (res['data'] != null) {
          List<dynamic> notifications = res['data'];
          for (var notif in notifications) {
            String monto = 'Notificación';
            // Parse message optionally to get monto or just use message
            // Wait, we need to show notification
            showPagoOverlay(
              context,
              monto: notif['message'] ?? 'Pago Recibido',
              tipo: notif['type'] ?? 'General',
            );
            await ApiService.markNotificationAsRead(notif['id']);
          }
          if (notifications.isNotEmpty && mounted) {
            _loadRecentPayments();
          }
        }
      } catch (e) {
        // ignore errors
      }
    });
  }

  Future<void> _loadRecentPayments() async {
    try {
      final res = await ApiService.getRecentPayments();
      if (mounted) {
        setState(() {
          _recentPayments = res['data'] ?? [];
          _isLoadingPayments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPayments = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pingCtrl.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

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
        body: wide ? _wideLayout(t, theme) : _narrowLayout(t, theme),
        bottomNavigationBar: wide ? null : _buildBottomNav(t),
      ),
    );
  }

  // ── Layout ancho (tablet/desktop) ──────────────────────────────────────────
  Widget _wideLayout(CT t, ChoferThemeNotifier theme) {
    return Row(
      children: [
        _SideNav(
          t: t,
          theme: theme,
          pingCtrl: _pingCtrl,
          onNavTap: (i) => setState(() => _navIdx = i),
          navIdx: _navIdx,
        ),
        Expanded(
          child: Column(
            children: [
              _TopBarWide(t: t, theme: theme, pingCtrl: _pingCtrl),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _mainContent(t)),
                    SizedBox(
                      width: 400,
                      child: _PagosPanel(t: t, pagos: _recentPayments, isLoading: _isLoadingPayments),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Layout estrecho (móvil) ────────────────────────────────────────────────
  Widget _narrowLayout(CT t, ChoferThemeNotifier theme) {
    return Column(
      children: [
        _TopBarMobile(t: t, theme: theme, pingCtrl: _pingCtrl),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                _StatsGrid(t: t, passengers: _dailyPassengers, collected: _dailyCollected),
                if (_dailyStatsError != null) ...[
                  const SizedBox(height: 12),
                  _StatsErrorMessage(error: _dailyStatsError!),
                ],
                const SizedBox(height: 16),
                _MapCard(t: t),
                const SizedBox(height: 16),
                SizedBox(
                  height: 480,
                  child: _PagosPanel(t: t, pagos: _recentPayments, isLoading: _isLoadingPayments),
                ),
                // Botón Finalizar Turno (móvil)
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/chofer/resumen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.receipt_long),
                    label: const Text(
                      'Finalizar Turno',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mainContent(CT t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _StatsGrid(t: t, passengers: _dailyPassengers, collected: _dailyCollected),
          if (_dailyStatsError != null) ...[
            const SizedBox(height: 12),
            _StatsErrorMessage(error: _dailyStatsError!),
          ],
          const SizedBox(height: 16),
          _MapCard(t: t),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/chofer/resumen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.receipt_long),
              label: const Text(
                'Finalizar Turno',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom nav (móvil) ─────────────────────────────────────────────────────
  Widget _buildBottomNav(CT t) {
    final items = [
      (Icons.dashboard_rounded, 'Principal'),
      (Icons.history_rounded, 'Historial'),
      (Icons.account_balance_wallet_rounded, 'Billetera'),
      (Icons.settings_rounded, 'Ajustes'),
    ];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: t.navBg,
        border: Border(top: BorderSide(color: t.navBorder, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = _navIdx == i;
              return GestureDetector(
                onTap: () => setState(() => _navIdx = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
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
                        items[i].$1,
                        size: 22,
                        color: active ? t.navActiveText : t.navInactive,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: active ? t.navActiveText : t.navInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ══ Top Bar Móvil ═════════════════════════════════════════════════════════════
class _TopBarMobile extends StatelessWidget {
  final CT t;
  final ChoferThemeNotifier theme;
  final AnimationController pingCtrl;
  const _TopBarMobile({
    required this.t,
    required this.theme,
    required this.pingCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(
          bottom: BorderSide(
            color: t.navBorder.withValues(alpha: 0.5),
            width: 0.5,
          ),
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
                Icon(Icons.menu, color: t.primaryFixed, size: 26),
                const SizedBox(width: 10),
                Text(
                  'Panel del Conductor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: t.primaryFixed,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                _StatusPill(t: t, ctrl: pingCtrl),
                const SizedBox(width: 8),
                _ThemeToggle(t: t, onTap: theme.toggle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══ Top Bar Ancho ═════════════════════════════════════════════════════════════
class _TopBarWide extends StatelessWidget {
  final CT t;
  final ChoferThemeNotifier theme;
  final AnimationController pingCtrl;
  const _TopBarWide({
    required this.t,
    required this.theme,
    required this.pingCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 54,
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(
          bottom: BorderSide(
            color: t.navBorder.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              'Panel del Conductor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: t.primaryFixed,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            _StatusPill(t: t, ctrl: pingCtrl),
            const SizedBox(width: 12),
            _ThemeToggle(t: t, onTap: theme.toggle),
          ],
        ),
      ),
    );
  }
}

// ══ Side Nav (desktop) ════════════════════════════════════════════════════════
class _SideNav extends StatelessWidget {
  final CT t;
  final ChoferThemeNotifier theme;
  final AnimationController pingCtrl;
  final int navIdx;
  final ValueChanged<int> onNavTap;
  const _SideNav({
    required this.t,
    required this.theme,
    required this.pingCtrl,
    required this.navIdx,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.timer_rounded, 'Turno Actual'),
      (Icons.bar_chart_rounded, 'Estadísticas'),
      (Icons.route_rounded, 'Rutas'),
      (Icons.support_agent_rounded, 'Soporte'),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: 260,
      decoration: BoxDecoration(
        color: t.isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          right: BorderSide(color: t.navBorder.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Perfil
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: t.surfaceCont,
                    child: Icon(Icons.person, color: t.textSecondary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Juan Pérez',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: t.textPrimary,
                          ),
                        ),
                        Text(
                          'ID: 44291',
                          style: TextStyle(
                            fontSize: 13,
                            color: t.textSecondary,
                          ),
                        ),
                        Text(
                          'Unidad 42 - Línea Verde',
                          style: TextStyle(
                            fontSize: 11,
                            color: t.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: t.navBorder.withValues(alpha: 0.4), height: 1),
            // Items de nav
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ...List.generate(items.length, (i) {
                      final active = navIdx == i;
                      return GestureDetector(
                        onTap: () => onNavTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(
                                    0xFFDAE2FD,
                                  ).withValues(alpha: t.isDark ? 0.15 : 1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                items[i].$1,
                                size: 22,
                                color: active ? t.primary : t.textSecondary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                items[i].$2,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: active ? t.primary : t.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    // Cerrar sesión
                    GestureDetector(
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/chofer',
                        (_) => false,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 22, color: t.errorDark),
                            const SizedBox(width: 12),
                            Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                fontSize: 14,
                                color: t.errorDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Toggle tema
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 4),
                      child: GestureDetector(
                        onTap: theme.toggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: t.toggleBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                t.isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                size: 20,
                                color: t.toggleIcon,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                t.isDark ? 'Modo Claro' : 'Modo Oscuro',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: t.toggleIcon,
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
            ),
          ],
        ),
      ),
    );
  }
}

// ══ Status Pill ═══════════════════════════════════════════════════════════════
class _StatusPill extends StatelessWidget {
  final CT t;
  final AnimationController ctrl;
  const _StatusPill({required this.t, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: t.emerald.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: t.emerald.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.5, end: 1.6).animate(
                    CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.emerald.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.emerald,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'EN SERVICIO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: t.emerald,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══ Theme Toggle Button ════════════════════════════════════════════════════════
class _ThemeToggle extends StatelessWidget {
  final CT t;
  final VoidCallback onTap;
  const _ThemeToggle({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: t.toggleBg,
          shape: BoxShape.circle,
          border: Border.all(color: t.outline.withValues(alpha: 0.3)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            t.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(t.isDark),
            color: t.toggleIcon,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ══ Stats Grid ════════════════════════════════════════════════════════════════
class _StatsGrid extends StatelessWidget {
  final CT t;
  final int passengers;
  final double collected;
  const _StatsGrid({required this.t, required this.passengers, required this.collected});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final two = c.maxWidth > 480;
        final cards = [
          _StatCard(
            t: t,
            label: 'Total Recaudado',
            value: 'Bs ${collected.toStringAsFixed(2)}',
            valueColor: t.isDark ? const Color(0xFF6FFBBE) : t.primary,
            badge: '+12% vs ayer',
            badgeColor: t.emerald,
            badgeIcon: Icons.trending_up,
            bgIcon: Icons.account_balance_wallet,
            bgColor: t.isDark ? const Color(0xFF6FFBBE) : t.primary,
          ),
          _StatCard(
            t: t,
            label: 'Pasajeros',
            value: passengers.toString(),
            valueColor: t.infoBlue,
            badge: 'Capacidad al 65%',
            badgeColor: t.textSecondary,
            badgeIcon: Icons.directions_bus,
            bgIcon: Icons.groups,
            bgColor: t.infoBlue,
          ),
        ];
        if (two)
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
            ],
          );
        return Column(
          children: [cards[0], const SizedBox(height: 12), cards[1]],
        );
      },
    );
  }
}

class _StatsErrorMessage extends StatelessWidget {
  final String error;
  const _StatsErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        'Error cargando métricas: $error',
        style: TextStyle(color: Colors.red.shade700, fontSize: 13),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final CT t;
  final String label, value, badge;
  final Color valueColor, badgeColor, bgColor;
  final IconData badgeIcon, bgIcon;
  const _StatCard({
    required this.t,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.badge,
    required this.badgeColor,
    required this.badgeIcon,
    required this.bgIcon,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
        boxShadow: t.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -12,
            child: Icon(
              bgIcon,
              size: 100,
              color: bgColor.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 13, color: badgeColor),
                    const SizedBox(width: 4),
                    Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        color: badgeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══ Mapa ══════════════════════════════════════════════════════════════════════
class _MapCard extends StatefulWidget {
  final CT t;
  const _MapCard({required this.t});
  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: t.isDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0D1B2A),
                        Color(0xFF1B2A3B),
                        Color(0xFF0A2218),
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE8F0E9),
                        Color(0xFFF0F7F0),
                        Color(0xFFE0EDE5),
                      ],
                    ),
            ),
          ),
          CustomPaint(size: Size.infinite, painter: _GridPainter(t.isDark)),
          CustomPaint(size: Size.infinite, painter: _RoutePainter()),
          // Gradientes
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [t.bg.withValues(alpha: 0.6), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [t.bg.withValues(alpha: 0.5), Colors.transparent],
                ),
              ),
            ),
          ),
          // Información
          Positioned(
            top: 14,
            left: 14,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruta 42 - Centro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: t.textPrimary,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Próxima Parada: Plaza Murillo (2 min)',
                  style: TextStyle(
                    fontSize: 13,
                    color: t.isDark ? const Color(0xFF6FFBBE) : t.primary,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ubicación (modo claro)
          if (!t.isDark)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: t.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.near_me, color: t.infoBlue, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Av. 16 de Julio',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: t.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Botón ubicación
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: t.bg.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: t.navBorder.withValues(alpha: 0.4)),
                ),
                child: Icon(Icons.my_location, color: t.textPrimary, size: 18),
              ),
            ),
          ),
          // Marcador
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF006C49).withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981),
                      border: Border.all(color: t.bg, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.6),
                          blurRadius: 14,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.navigation, color: t.bg, size: 13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  const _GridPainter(this.isDark);
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (double y = 0; y < s.height; y += 38)
      c.drawLine(Offset(0, y), Offset(s.width, y), p);
    for (double x = 0; x < s.width; x += 56)
      c.drawLine(Offset(x, 0), Offset(x, s.height), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final path = Path()
      ..moveTo(s.width * 0.1, s.height * 0.8)
      ..cubicTo(
        s.width * 0.25,
        s.height * 0.55,
        s.width * 0.35,
        s.height * 0.4,
        s.width * 0.5,
        s.height * 0.5,
      )
      ..cubicTo(
        s.width * 0.65,
        s.height * 0.6,
        s.width * 0.75,
        s.height * 0.3,
        s.width * 0.9,
        s.height * 0.2,
      );
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.55)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.12)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ══ Panel de Pagos ═════════════════════════════════════════════════════════════
class _PagosPanel extends StatelessWidget {
  final CT t;
  final List<dynamic> pagos;
  final bool isLoading;
  const _PagosPanel({required this.t, required this.pagos, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: t.isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
        boxShadow: t.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Header
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: t.isDark ? t.bg.withValues(alpha: 0.5) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: t.navBorder.withValues(alpha: 0.3)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Últimos Pagos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: t.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'VER TODOS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : pagos.isEmpty
                    ? Center(child: Text('Sin pagos recientes', style: TextStyle(color: t.textSecondary)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: pagos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _PagoTile(t: t, p: pagos[i]),
                      ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.isDark ? t.bg : Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: t.navBorder.withValues(alpha: 0.3)),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: t.textPrimary,
                  side: BorderSide(color: t.navBorder.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ver Historial Completo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagoTile extends StatelessWidget {
  final CT t;
  final dynamic p;
  const _PagoTile({required this.t, required this.p});

  @override
  Widget build(BuildContext context) {
    final type = p['user_type_at_time'] ?? 'General';
    final isEstudiante = type.toLowerCase().contains('estudiante');
    final isTercera = type.toLowerCase().contains('tercera');
    final color = isEstudiante ? t.infoBlue : (isTercera ? t.amber : t.emerald);
    final icon = isEstudiante ? Icons.school : (isTercera ? Icons.elderly : Icons.person);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.isDark ? t.bg : const Color(0xFFF4FBF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: t.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pasajero $type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p['created_at'] != null ? p['created_at'].toString().split('T')[1].substring(0, 5) : '',
                  style: TextStyle(fontSize: 12, color: t.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+ Bs ${double.tryParse(p['amount_paid']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: t.isDark ? t.primaryFixed : t.primary,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: t.isDark
                      ? t.surfaceCont.withValues(alpha: 0.3)
                      : const Color(0xFFE8F0E9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 10,
                    color: t.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
