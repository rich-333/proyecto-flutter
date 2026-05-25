import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chofer_theme.dart';
import 'dashboard_chofer.dart';

class LoginChofer extends StatefulWidget {
  const LoginChofer({super.key});

  @override
  State<LoginChofer> createState() => _LoginChoferState();
}

class _LoginChoferState extends State<LoginChofer>
    with TickerProviderStateMixin {
  static const int _pinLen = 5;
  String _pin = '';
  bool _hasError = false;
  bool _isLoading = false;

  List<AnimationController> _dotCtrl = [];
  List<Animation<double>> _dotAnim = [];
  late AnimationController _btnCtrl;
  late Animation<double> _btnAnim;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _dotCtrl = List.generate(
      _pinLen,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
      ),
    );
    _dotAnim = _dotCtrl
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 1.35,
          ).animate(CurvedAnimation(parent: c, curve: Curves.elasticOut)),
        )
        .toList();

    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _btnAnim = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    for (final c in _dotCtrl) c.dispose();
    _btnCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _add(String n) {
    if (_pin.length >= _pinLen || _isLoading) return;
    HapticFeedback.lightImpact();
    final idx = _pin.length;
    setState(() {
      _pin += n;
      _hasError = false;
    });
    _dotCtrl[idx].forward().then((_) => _dotCtrl[idx].reverse());
    if (_pin.length == _pinLen) _btnCtrl.repeat(reverse: true);
  }

  void _del() {
    if (_pin.isEmpty || _isLoading) return;
    HapticFeedback.selectionClick();
    final idx = _pin.length - 1;
    setState(() {
      _pin = _pin.substring(0, idx);
      _hasError = false;
    });
    _dotCtrl[idx].reverse();
    if (_pin.length < _pinLen) {
      _btnCtrl.stop();
      _btnCtrl.reset();
    }
  }

  Future<void> _login() async {
    if (_pin.length != _pinLen || _isLoading) return;
    HapticFeedback.heavyImpact();
    setState(() => _isLoading = true);
    _btnCtrl.stop();
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (_pin == '12345') {
      Navigator.pushReplacementNamed(context, '/chofer/dashboard');
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      HapticFeedback.vibrate();
      _shakeCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _pin = '';
          _hasError = false;
        });
        for (final c in _dotCtrl) c.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChoferThemeProvider.of(context);
    final t = CT(theme.isDark);
    final complete = _pin.length == _pinLen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: t.bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: (e) {
            if (e is! KeyDownEvent) return;
            final digits = {
              LogicalKeyboardKey.digit0: '0',
              LogicalKeyboardKey.digit1: '1',
              LogicalKeyboardKey.digit2: '2',
              LogicalKeyboardKey.digit3: '3',
              LogicalKeyboardKey.digit4: '4',
              LogicalKeyboardKey.digit5: '5',
              LogicalKeyboardKey.digit6: '6',
              LogicalKeyboardKey.digit7: '7',
              LogicalKeyboardKey.digit8: '8',
              LogicalKeyboardKey.digit9: '9',
            };
            if (digits.containsKey(e.logicalKey))
              _add(digits[e.logicalKey]!);
            else if (e.logicalKey == LogicalKeyboardKey.backspace)
              _del();
            else if (e.logicalKey == LogicalKeyboardKey.enter)
              _login();
          },
          child: Stack(
            children: [
              // ── Orbes decorativos (modo oscuro) ──────────────────────────
              if (t.isDark) ...[
                Positioned(
                  top: -MediaQuery.of(context).size.height * 0.2,
                  left: -MediaQuery.of(context).size.width * 0.1,
                  child: _GlowOrb(
                    size: MediaQuery.of(context).size.width * 0.9,
                    color: t.primary.withValues(alpha: 0.06),
                    blur: 120,
                  ),
                ),
                Positioned(
                  bottom: -MediaQuery.of(context).size.height * 0.1,
                  right: -MediaQuery.of(context).size.width * 0.1,
                  child: _GlowOrb(
                    size: MediaQuery.of(context).size.width * 0.6,
                    color: t.emerald.withValues(alpha: 0.06),
                    blur: 100,
                  ),
                ),
              ],

              // ── Botón toggle tema (esquina superior derecha) ──────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16,
                child: _ThemeToggleBtn(t: t, onTap: theme.toggle),
              ),

              // ── Contenido principal ──────────────────────────────────────
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      children: [
                        _buildHeader(t),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                _buildPinArea(t, complete),
                                const SizedBox(height: 28),
                                _buildKeypad(t),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        _buildFooter(t, complete),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(CT t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: t.isDark
                  ? t.surfaceCont.withValues(alpha: 0.15)
                  : const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: t.outline.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: t.emerald.withValues(alpha: t.isDark ? 0.1 : 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              color: t.isDark
                  ? const Color(0xFF6FFBBE)
                  : const Color(0xFF002113),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 350),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: t.isDark ? Colors.white : t.primary,
              letterSpacing: -0.01,
            ),
            child: const Text(
              'Panel del Conductor',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 350),
            style: TextStyle(
              fontSize: 15,
              color: t.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            child: const Text(
              'Ingrese su Código de Chofer',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ── Área PIN ───────────────────────────────────────────────────────────────
  Widget _buildPinArea(CT t, bool complete) {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(_shakeAnim.value, 0),
        child: child,
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 72,
            decoration: BoxDecoration(
              color: t.pinBoxBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: _hasError
                    ? t.errorRed
                    : complete
                    ? t.emerald
                    : t.outline,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLen, (i) {
                final filled = i < _pin.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ScaleTransition(
                    scale: _dotAnim[i],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasError
                            ? t.errorRed
                            : filled
                            ? t.dotFilled
                            : t.dotEmpty,
                        boxShadow: filled && !_hasError
                            ? [
                                BoxShadow(
                                  color: t.dotFilled.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          if (_hasError) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Código inválido. Intente nuevamente.',
                style: TextStyle(
                  fontSize: 12,
                  color: t.errorRed,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.05,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Teclado ────────────────────────────────────────────────────────────────
  Widget _buildKeypad(CT t) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        ...[
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
        ].map((n) => _NumBtn(label: '$n', onTap: () => _add('$n'), t: t)),
        const SizedBox.shrink(),
        _NumBtn(label: '0', onTap: () => _add('0'), t: t),
        _DelBtn(onTap: _del, t: t),
      ],
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────
  Widget _buildFooter(CT t, bool complete) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: t.bg,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: complete && !_isLoading
                ? _btnAnim
                : const AlwaysStoppedAnimation(1.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: complete ? 1.0 : 0.5,
              child: SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton.icon(
                  onPressed: complete && !_isLoading ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.emerald,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: t.primary,
                    disabledForegroundColor: Colors.white,
                    elevation: complete ? 6 : 2,
                    shadowColor: t.emerald.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login_rounded, size: 22),
                  label: Text(
                    _isLoading ? 'Verificando...' : 'Iniciar Jornada',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.support_agent_rounded, size: 18, color: t.primary),
            label: Text(
              'Necesito ayuda',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: t.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle tema ────────────────────────────────────────────────────────────────
class _ThemeToggleBtn extends StatelessWidget {
  final CT t;
  final VoidCallback onTap;
  const _ThemeToggleBtn({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 44,
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
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ── Botón numérico ─────────────────────────────────────────────────────────────
class _NumBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final CT t;
  const _NumBtn({required this.label, required this.onTap, required this.t});
  @override
  State<_NumBtn> createState() => _NumBtnState();
}

class _NumBtnState extends State<_NumBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _pressed ? t.keyBgPressed : t.keyBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.keyBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: t.keyText,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Botón borrar ───────────────────────────────────────────────────────────────
class _DelBtn extends StatefulWidget {
  final VoidCallback onTap;
  final CT t;
  const _DelBtn({required this.onTap, required this.t});
  @override
  State<_DelBtn> createState() => _DelBtnState();
}

class _DelBtnState extends State<_DelBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _pressed ? t.keyBgPressed : t.keyBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.keyBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_rounded,
            size: 28,
            color: _pressed ? t.keyText : t.delColor,
          ),
        ),
      ),
    );
  }
}

// ── Orbe decorativo ────────────────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;
  const _GlowOrb({required this.size, required this.color, required this.blur});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: const SizedBox.expand(),
      ),
    );
  }
}
