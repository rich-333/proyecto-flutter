import 'package:flutter/material.dart';
import 'chofer_theme.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Pantalla de notificación de pago recibido
// Se puede mostrar como ruta: Navigator.pushNamed(context, '/chofer/notificacion-pago',
//   arguments: {'monto': 'Bs 2.00', 'nombre': 'Carlos Ruiz', 'tipo': 'General'})
// O como overlay sobre el dashboard llamando showPagoOverlay()
// ══════════════════════════════════════════════════════════════════════════════

/// Muestra la notificación de pago como overlay encima de la pantalla actual
void showPagoOverlay(
  BuildContext context, {
  required String monto,
  String nombre = '',
  String tipo = 'General',
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Pago',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim, _) {
      final theme = ChoferThemeProvider.of(context);
      return NotificacionPagoChofer(
        monto: monto,
        nombre: nombre,
        tipo: tipo,
        isDark: theme.isDark,
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(
            begin: 0.92,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
  );
}

class NotificacionPagoChofer extends StatefulWidget {
  final String monto;
  final String nombre;
  final String tipo;
  final bool isDark;

  const NotificacionPagoChofer({
    super.key,
    required this.monto,
    this.nombre = '',
    this.tipo = 'General',
    this.isDark = true,
  });

  @override
  State<NotificacionPagoChofer> createState() => _NotificacionPagoChoferState();
}

class _NotificacionPagoChoferState extends State<NotificacionPagoChofer>
    with TickerProviderStateMixin {
  late AnimationController _checkCtrl;
  late AnimationController _progressCtrl;
  late Animation<double> _checkAnim;
  late Animation<double> _progressAnim;

  static const Duration _autoDismiss = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkAnim = CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);
    _checkCtrl.forward();

    _progressCtrl = AnimationController(vsync: this, duration: _autoDismiss);
    _progressAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_progressCtrl);
    _progressCtrl.forward();
    _progressCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted)
        Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    _progressCtrl.stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = CT(widget.isDark);
    final bg = widget.isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.92)
        : const Color(0xFFF4FBF4).withValues(alpha: 0.92);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Fondo blur
          GestureDetector(
            onTap: _dismiss,
            child: Container(color: bg),
          ),

          // Contenido central
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: t.emerald.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: t.emerald.withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Botón cerrar ──────────────────────────────────────
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: _dismiss,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: t.surfaceCont.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: t.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Check animado ─────────────────────────────────────
                      ScaleTransition(
                        scale: _checkAnim,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: t.emerald.withValues(alpha: 0.15),
                            border: Border.all(
                              color: t.emerald.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: t.emerald,
                            size: 72,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Texto ─────────────────────────────────────────────
                      Text(
                        'Pago Recibido',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: t.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.monto,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: t.emerald,
                          letterSpacing: -1.5,
                          height: 1,
                        ),
                      ),

                      if (widget.nombre.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: t.surfaceCont.withValues(
                              alpha: t.isDark ? 0.3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: t.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                color: t.textSecondary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.nombre,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: t.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: t.emerald.withValues(alpha: 0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CONFIRMADO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: t.emerald.withValues(alpha: 0.7),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Barra de progreso auto-dismiss ────────────────────
                      AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (_, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressAnim.value,
                            minHeight: 4,
                            backgroundColor: t.outline.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              t.emerald,
                            ),
                          ),
                        ),
                      ),
                    ],
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
