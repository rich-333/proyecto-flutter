import 'package:flutter/material.dart';
import 'pago_exitoso_pasajero.dart';
import '../../services/api_service.dart';

class ConfirmarPagoPasajero extends StatefulWidget {
  final String qrData;

  const ConfirmarPagoPasajero({super.key, required this.qrData});

  @override
  State<ConfirmarPagoPasajero> createState() => _ConfirmarPagoPasajeroState();
}

class _ConfirmarPagoPasajeroState extends State<ConfirmarPagoPasajero>
    with SingleTickerProviderStateMixin {
  bool isProcessing = false;
  bool isPaid = false;
  bool isLoading = true;
  String? errorMessage;

  // Data from API
  String route = '';
  String line = '';
  String userType = '';
  double fareApplied = 0.0;
  double currentBalance = 0.0;
  double remainingBalance = 0.0;
  bool canPay = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentPreview();
  }

  Future<void> _loadPaymentPreview() async {
    try {
      final response = await ApiService.previewPayment(widget.qrData);
      
      if (mounted) {
        setState(() {
          route = response['route'] ?? 'Ruta desconocida';
          line = response['line'] ?? '';
          userType = response['user_type'] ?? 'General';
          fareApplied = (response['fare_applied'] ?? 0.0).toDouble();
          currentBalance = (response['current_balance'] ?? 0.0).toDouble();
          remainingBalance = (response['remaining_balance_after_payment'] ?? 0.0).toDouble();
          canPay = response['can_pay'] ?? false;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error al cargar la información del pago: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final response = await ApiService.payTrip(widget.qrData);
      
      if (mounted) {
        setState(() {
          isProcessing = false;
          isPaid = true;
        });

        // Navegar a la pantalla de éxito del pago con los datos
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PagoExitosoPasajero(
                  paidAmount: (response['paid_amount'] ?? 0.0).toDouble(),
                  time: response['time'] ?? '--:--',
                  date: response['date'] ?? '',
                  route: response['route'] ?? 'Ruta desconocida',
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Error al procesar el pago: $e';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage ?? 'Error desconocido')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4FBF4),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF10B981),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4FBF4),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // background
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
                                // Header Info - Route and Line
                                Text(
                                  line,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF161D19),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  route,
                                  style: const TextStyle(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                              border: Border.all(
                                                color: const Color(0xFF565E74)
                                                    .withOpacity(0.1),
                                              ),
                                            ),
                                            child: Text(
                                              userType
                                                  .replaceAll('_', ' ')
                                                  .toUpperCase(),
                                              style: const TextStyle(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                          Text(
                                            'Bs ${fareApplied.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 18,
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
                                    color: canPay
                                        ? const Color(0xFFEEF6EE) // surface-container-low
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet,
                                            color: canPay
                                                ? const Color(0xFF3C4A42)
                                                : Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Saldo restante',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: canPay
                                                  ? const Color(0xFF3C4A42)
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Bs ${remainingBalance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: canPay
                                              ? const Color(0xFF161D19)
                                              : Colors.red,
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
                    onPressed: (isProcessing || !canPay) ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !canPay
                          ? Colors.grey
                          : isPaid
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
                            : !canPay
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.warning, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        'Saldo insuficiente',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.contactless, size: 24),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Pagar Bs ${fareApplied.toStringAsFixed(2)}',
                                        style: const TextStyle(
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