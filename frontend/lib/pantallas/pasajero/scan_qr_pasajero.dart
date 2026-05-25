import 'package:flutter/material.dart';
import 'confirmar_pago_pasajero.dart';

class ScanQrPasajero extends StatefulWidget {
  const ScanQrPasajero({super.key});

  @override
  State<ScanQrPasajero> createState() => _ScanQrPasajeroState();
}

class _ScanQrPasajeroState extends State<ScanQrPasajero>
    with SingleTickerProviderStateMixin {
  bool flashOn = false;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // surface-navy
      body: Stack(
        children: [
          // Simulación de cámara (fondo con imagen simulada)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A2A3A),
                  const Color(0xFF0F172A),
                  const Color(0xFF0A0F1A),
                ],
              ),
            ),
            child: const Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
          ),
          // UI Overlay Controls
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                margin: const EdgeInsets.only(top: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withOpacity(0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    // Flashlight Toggle
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          flashOn = !flashOn;
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: flashOn
                              ? const Color(0xFF10B981).withOpacity(0.9)
                              : const Color(0xFF0F172A).withOpacity(0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Icon(
                          flashOn ? Icons.flashlight_off : Icons.flashlight_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Scanner Frame & Cutout
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scanner Frame
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(15, 23, 42, 0.7),
                        blurRadius: 0,
                        spreadRadius: 4000,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // High-tech Corner Reticles
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF10B981), width: 4),
                              left: BorderSide(color: Color(0xFF10B981), width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF10B981), width: 4),
                              right: BorderSide(color: Color(0xFF10B981), width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF10B981), width: 4),
                              left: BorderSide(color: Color(0xFF10B981), width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF10B981), width: 4),
                              right: BorderSide(color: Color(0xFF10B981), width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      // Subtle internal border
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      // Animated Emerald Scan Line
                      AnimatedBuilder(
                        animation: _scanController,
                        builder: (context, child) {
                          return Positioned(
                            left: 0,
                            right: 0,
                            top: _scanController.value * 280,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.8),
                                    blurRadius: 12,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Instructions Text
                Column(
                  children: [
                    Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Escanea el código QR del vehículo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Apunta la cámara al código para pagar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFBEC6E0), // secondary-fixed-dim
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Botón Continuar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                            onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ConfirmarPagoPasajero(),
                                    ),
                                );
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}