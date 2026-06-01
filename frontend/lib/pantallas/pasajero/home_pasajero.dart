import 'package:flutter/material.dart';
import 'historial_pasajero.dart';
import 'perfil_pasajero.dart';
import 'scan_qr_pasajero.dart'; 
import '../../services/api_service.dart';

class HomePasajero extends StatefulWidget {
  const HomePasajero({super.key});

  @override
  State<HomePasajero> createState() => _HomePasajeroState();  
}

class _HomePasajeroState extends State<HomePasajero> {
  bool _isLoadingBalance = true;
  bool _isLoadingRecentActivity = true;
  double _balance = 0.0;
  List<dynamic> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _loadRecentActivity();
  }

  Future<void> _loadBalance() async {
    try {
      final passengerBalance = await ApiService.getPassengerBalance();

      if(mounted) {
        setState(() {
          _balance = double.parse((passengerBalance['data'] ?? 0).toString());
          _isLoadingBalance = false;
        });
      }
    }
    catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBalance = false;
        });
      }
    }
  }

  Future<void> _loadRecentActivity() async {
    try {
      final passengerRecentActivity = await ApiService.getPassengerRecentActivity();

      if (mounted) {
        setState(() {
          _recentActivity = passengerRecentActivity['data'] ?? [];
          _isLoadingRecentActivity = false;
        });
      }
    }
    catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRecentActivity = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // background
      body: SafeArea(
        child: Column(
          children: [
            // TopAppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF4FBF4), // surface
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE3EAE3),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFDDE4DD),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF006C49),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Transito Pay',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF006C49),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0E9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF006C49),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Wallet Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -40,
                            top: -40,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 40,
                                    color: const Color(0xFF10B981).withOpacity(0.3),
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: -40,
                            bottom: -40,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFF006C49).withOpacity(0.3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 40,
                                    color: const Color(0xFF006C49).withOpacity(0.3),
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saldo disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFBEC6E0),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Bs',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6FFBBE),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLoadingBalance ? '...' : _balance.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.02,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6FFBBE),
                                          foregroundColor: const Color(0xFF0F172A),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_circle, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'Recargar',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
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
                    ),
                    const SizedBox(height: 32),
                    // Scan Button Area
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanQrPasajero(),
                                ),
                              );
                            },
                            child: Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.5),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFFF4FBF4).withOpacity(0.5),
                                  width: 4,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Escanear',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Recent Trips
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Viajes recientes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF161D19),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HistorialPasajero(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Ver todos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.05,
                                  color: Color(0xFF006C49),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_isLoadingRecentActivity)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF10B981),
                            ),
                          )
                        else if (_recentActivity.isEmpty)
                          const Center(
                            child: Text(
                              'Sin actividad reciente',
                              style: TextStyle(
                                color: Color(0xFF3C4A42),
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentActivity.length,
                            itemBuilder: (context, index) {
                              final activity = _recentActivity[index];
                              final isTopUp = activity['type'] == 'recarga';
                              
                              return Column(
                                children: [
                                  _buildTripItem(
                                    icon: isTopUp
                                        ? Icons.account_balance_wallet
                                        : Icons.directions_bus,
                                    title: isTopUp
                                        ? 'Recarga'
                                        : activity['line'] ?? 'Viaje',
                                    route:
                                      '${activity['route']}',
                                    subtitle:
                                        '${activity['date']}, ${activity['time']}',
                                    amount: isTopUp
                                        ? '+ Bs ${activity['amount'].toStringAsFixed(2)}'
                                        : '- Bs ${activity['amount'].abs().toStringAsFixed(2)}',
                                    tag: isTopUp
                                        ? ''
                                        : (activity['user_type'] ?? 'General')
                                            .replaceAll('_', ' '),
                                    isTopUp: isTopUp,
                                  ),
                                  if (index < _recentActivity.length - 1)
                                    const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // BottomNavBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0E9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home (Active)
                _buildNavItem(Icons.home, 'Home', true, context),
                // Scan
                _buildNavItem(Icons.qr_code_scanner, 'Scan', false, context, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQrPasajero(),
                    ),
                  );
                }),
                // History - Aquí pasamos el contexto y la navegación
                _buildNavItem(Icons.history, 'History', false, context, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistorialPasajero(),
                    ),
                  );
                }),
                // Profile
                _buildNavItem(Icons.person, 'Profile', false, context, onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PerfilPasajero(),
                        ),
                    );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripItem({
    required IconData icon,
    required String title,
    required String route,
    required String subtitle,
    required String amount,
    required String tag,
    required bool isTopUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8F0E9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isTopUp ? const Color(0xFFE8F0E9) : const Color(0xFFE8F0E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isTopUp ? const Color(0xFF10B981) : const Color(0xFF006C49),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF161D19),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isTopUp ? const Color(0xFF10B981) : const Color(0xFF161D19),
                ),
              ),
              if (tag.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EAE3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.05,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Modificamos _buildNavItem para aceptar un onTap opcional
  Widget _buildNavItem(IconData icon, String label, bool isActive, BuildContext context, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {}, // Si no hay onTap, no hace nada
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(9999),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF3C4A42),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.05,
                color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}