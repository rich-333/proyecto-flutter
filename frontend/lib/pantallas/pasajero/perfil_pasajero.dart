import 'package:flutter/material.dart';
import 'historial_pasajero.dart';
import 'login_pasajero.dart';
import 'scan_qr_pasajero.dart';

class PerfilPasajero extends StatelessWidget {
  const PerfilPasajero({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // surface
      body: Column(
        children: [
          // TopAppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFF4FBF4),
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
                        color: const Color(0xFFE8F0E9), // surface-container
                        border: Border.all(
                          color: const Color(0xFFBBCABF).withOpacity(0.3), // outline-variant
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFE8F0E9),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF006C49),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Transito Pay',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006C49), // primary
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                // Notifications button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF006C49),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Profile Header Section
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE8F0E9), // surface-container
                              border: Border.all(
                                color: const Color(0xFFFFFFFF), // surface-container-lowest
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withOpacity(0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F0E9),
                              radius: 56,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF006C49),
                                size: 56,
                              ),
                            ),
                          ),
                          // Verification Badge
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981), // primary-container
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF4FBF4), // surface
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nombre del Usuario',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF161D19), // on-surface
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Payment Chip for User Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EAE3), // surface-container-high
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFFBBCABF), // outline-variant
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_bus,
                              color: Color(0xFF006C49),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Pasajero General',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Color(0xFF161D19),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Bento Grid Sections
                  Column(
                    children: [
                      // Top-up Methods (Full width)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF), // surface-container-lowest
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFDDE4DD), // surface-variant
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
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
                                      color: const Color(0xFF006C49).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Color(0xFF006C49),
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Métodos de recarga',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF161D19),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Tarjetas, QR, Puntos Físicos',
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          color: Color(0xFF3C4A42),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF3C4A42),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Row for Settings and Help
                      Row(
                        children: [
                          // Settings
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 140,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFDDE4DD),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F0E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.settings,
                                        color: Color(0xFF3C4A42),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Configuración',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF161D19),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Help & Support
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 140,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFDDE4DD),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F0E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.help_center,
                                        color: Color(0xFF3C4A42),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Soporte',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF161D19),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPasajero(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDAD6).withOpacity(0.5), // error-container/50
                        foregroundColor: const Color(0xFF93000A), // on-error-container
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFFFDAD6), // error-container
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Espacio para bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
      // BottomNavBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0E9), // surface-container
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
                // Home
                _buildNavItem(Icons.home, 'Home', false, onTap: () {
                  Navigator.pop(context);
                }),
                // Scan
                _buildNavItem(Icons.qr_code_scanner, 'Scan', false, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQrPasajero(),
                    ),
                  );
                }),
                // History
                _buildNavItem(Icons.history, 'History', false, onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialPasajero(),
                    ),
                  );
                }),
                // Profile (Active)
                _buildNavItem(Icons.person, 'Profile', true, onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF10B981), // primary-container
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
                letterSpacing: 0.5,
                color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}