import 'package:flutter/material.dart';
import 'pago_exitoso_pasajero.dart';

class ConfirmarPagoPasajero extends StatefulWidget {
  const ConfirmarPagoPasajero({super.key});

  @override
  State<ConfirmarPagoPasajero> createState() => _ConfirmarPagoPasajeroState();
}

class _ConfirmarPagoPasajeroState extends State<ConfirmarPagoPasajero>
    with SingleTickerProviderStateMixin {
  bool isProcessing = false;
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // surface
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              // Top Action Bar (Minimal, Transactional Context)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón cerrar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0E9), // surface-container
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF161D19),
                          size: 24,
                        ),
                      ),
                    ),
                    const Text(
                      'Confirma tu pasaje',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF161D19),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),
              // Main Content Canvas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Central Confirmation Card
                      Center(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 448),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF), // surface-container-lowest
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0), // slate-200
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withOpacity(0.06),
                                blurRadius: 30,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Route Icon
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3EAE3), // surface-container-high
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFFFFFF),
                                      width: 4,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.directions_bus,
                                    color: Color(0xFF006C49),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Header Info
                                const Text(
                                  'Ruta 21',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF161D19),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Sindicato de Transportes Litoral',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF3C4A42),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                // Fare Details Block
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4FBF4), // surface
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFDDE4DD), // surface-container-highest
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // Category
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Categoría',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF3C4A42),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDAE2FD), // secondary-container
                                              borderRadius: BorderRadius.circular(9999),
                                              border: Border.all(
                                                color: const Color(0xFF565E74).withOpacity(0.1),
                                              ),
                                            ),
                                            child: const Text(
                                              'General',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5,
                                                color: Color(0xFF3F465C),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(
                                        color: Color(0xFFF1F5F9),
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 16),
                                      // Amount
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center, // Cambiado para alinear al centro verticalmente
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Tarifa aplicada',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF3C4A42),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Bs 2.00',
                                            style: TextStyle(
                                              fontSize: 18, // Cambiado de 48 a 18 para igualar el tamaño
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.02,
                                              color: Color(0xFF161D19),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Balance Projection
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF6EE), // surface-container-low
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet,
                                            color: Color(0xFF3C4A42),
                                            size: 20,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Saldo restante',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF3C4A42),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Bs 15.50',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF161D19),
                                        ),
                                      ),
                                    ],
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
          // Fixed Bottom Action Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF4FBF4).withOpacity(0),
                    const Color(0xFFF4FBF4).withOpacity(0.9),
                    const Color(0xFFF4FBF4),
                  ],
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isProcessing
                        ? null
                        : () {
                            setState(() {
                              isProcessing = true;
                            });

                            // Simular procesamiento de pago
                            Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                    isProcessing = false;
                                    isPaid = true;
                                });

                                // Navegar a la pantalla de éxito del pago
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => const PagoExitosoPasajero(),
                                    ),
                                );
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaid
                          ? const Color(0xFF10B981)
                          : const Color(0xFF006C49),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isProcessing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Procesando...',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        : isPaid
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    '¡Pagado!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.contactless, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'Pagar Bs 2.00',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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