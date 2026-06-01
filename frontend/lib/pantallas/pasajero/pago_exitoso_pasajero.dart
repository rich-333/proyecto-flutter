import 'package:flutter/material.dart';

class PagoExitosoPasajero extends StatefulWidget {
  final double paidAmount;
  final String time;
  final String date;
  final String route;
  final String? transactionCode;

  const PagoExitosoPasajero({
    super.key,
    required this.paidAmount,
    required this.time,
    required this.date,
    required this.route,
    this.transactionCode,
  });

  @override
  State<PagoExitosoPasajero> createState() => _PagoExitosoPasajeroState();
}

class _PagoExitosoPasajeroState extends State<PagoExitosoPasajero> {
  @override
  void initState() {
    super.initState();
    // Simular vibración de éxito (opcional, solo funciona en dispositivos móviles)
  }

  @override
  Widget build(BuildContext context) {
    // Generar código de transacción si no se proporciona
    final transactionCode = widget.transactionCode ?? 'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    
    // Formatear la hora de manera más clara
    final timeFormatted = widget.time;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // surface
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Animation Container
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing background effect
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Main Check Circle
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981), // success-emerald
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Typography: Header & Amount
                  const Text(
                    'Pago realizado correctamente',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161D19),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bs ${widget.paidAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.02,
                      color: Color(0xFF006C49),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0E9), // surface-container
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFBBCABF).withOpacity(0.3), // outline-variant/30
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Hora
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Color(0xFF3C4A42),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Hora',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            timeFormatted,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF161D19),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        color: Color(0xFFBBCABF),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 16),
                      // Ruta
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_bus,
                                color: Color(0xFF3C4A42),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Ruta',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDE4DD), // surface-variant
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.route,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF161D19),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        color: Color(0xFFBBCABF),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 16),
                      // Código de transacción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                color: Color(0xFF3C4A42),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Código de transacción',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            transactionCode,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF161D19),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Column(
                children: [
                  // Ver recibo (Secondary)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        // Aquí irá la lógica para ver el recibo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ver recibo - Función en desarrollo'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF006C49),
                        side: const BorderSide(
                          color: Color(0xFF006C49),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Ver recibo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Volver al inicio (Primary)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Volver al home (limpia toda la pila de navegación)
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006C49),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: const Text(
                        'Volver al inicio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}