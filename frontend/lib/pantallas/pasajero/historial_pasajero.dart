import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'perfil_pasajero.dart';
import 'scan_qr_pasajero.dart'; // ← Agrega esta importación

class HistorialPasajero extends StatefulWidget {
  const HistorialPasajero({super.key});

  @override
  State<HistorialPasajero> createState() => _HistorialPasajeroState();
}

class _HistorialPasajeroState extends State<HistorialPasajero> {
  bool isLoading = true;
  List<dynamic> combinedHistory = [];
  double totalSpent = 0.0;
  String currentMonth = DateTime.now().month.toString().padLeft(2, '0');
  String currentYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final res = await ApiService.getPassengerHistory(currentMonth, currentYear);
      if (mounted) {
        setState(() {
          final trips = (res['trips'] as List<dynamic>?)?.map((t) {
            t['isRecarga'] = false;
            return t;
          }).toList() ?? [];
          
          final recharges = (res['recharges'] as List<dynamic>?)?.map((r) {
            r['isRecarga'] = true;
            return r;
          }).toList() ?? [];

          combinedHistory = [...trips, ...recharges];
          // SORT BY DATE AND TIME
          combinedHistory.sort((a, b) {
            final dateA = a['date'] + " " + a['time'];
            final dateB = b['date'] + " " + b['time'];
            return dateB.compareTo(dateA); // Descending
          });

          totalSpent = double.tryParse(res['total_spent_in_month']?.toString() ?? '0') ?? 0.0;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // surface
      body: Column(
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
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE3EAE3), // surface-container-high
                    border: Border.all(
                      color: const Color(0xFFBBCABF).withOpacity(0.3), // outline-variant/30
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFFE3EAE3),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF006C49),
                      size: 22,
                    ),
                  ),
                ),
                // Brand
                const Text(
                  'Transito Pay',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF006C49), // primary
                    letterSpacing: -0.5,
                  ),
                ),
                // Notifications
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0E9), // surface-container
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Header Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Historial',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF161D19), // on-surface
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentMonth / $currentYear',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C4A42), // on-surface-variant
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Summary Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A), // surface-navy
                      borderRadius: BorderRadius.circular(16),
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
                        // Abstract background pattern
                        Positioned(
                          right: -40,
                          top: -40,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFF006C49).withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 40,
                                  color: const Color(0xFF006C49).withOpacity(0.2),
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'GASTOS DEL MES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                      color: Color(0xFFE8F0E9), // surface-container-high
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Bs. ${totalSpent.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFFFFFF), // on-primary
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981), // primary-container
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.analytics,
                                  color: Color(0xFFFFFFFF),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Transaction List
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (combinedHistory.isEmpty)
                    const Center(
                      child: Text(
                        'No hay registros este mes',
                        style: TextStyle(color: Color(0xFF3C4A42), fontSize: 16),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: combinedHistory.length,
                      separatorBuilder: (_, __) => const Divider(height: 16, thickness: 1, color: Color(0xFFDDE4DD)),
                      itemBuilder: (context, index) {
                        final tx = combinedHistory[index];
                        final isRecarga = tx['isRecarga'] == true;
                        
                        String title = isRecarga ? 'Recarga de Saldo' : (tx['line'] ?? tx['route']);
                        String sub = isRecarga ? (tx['description'] ?? 'Recarga wallet') : tx['route'];
                        String amount = isRecarga ? '+Bs. ${tx['amount']}' : '-Bs. ${tx['amount_paid']}';
                        String time = tx['time'].toString().substring(0, 5);
                        String tag = tx['passenger_type'] ?? 'General';
                        
                        return _buildHistoryItem(
                          icon: isRecarga ? Icons.account_balance_wallet : Icons.directions_bus,
                          title: title,
                          subtitle: sub,
                          time: '${tx['date']} $time',
                          amount: amount,
                          isTopUp: isRecarga,
                          tag: isRecarga ? '' : tag,
                          tagColor: isRecarga ? Colors.transparent : const Color(0xFFDAE2FD),
                          tagTextColor: isRecarga ? Colors.transparent : const Color(0xFF3F465C),
                        );
                      },
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
                // Scan - MODIFICADO: Ahora navega a ScanQrPasajero
                _buildNavItem(Icons.qr_code_scanner, 'Scan', false, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQrPasajero(),
                    ),
                  );
                }),
                // History (Active)
                _buildNavItem(Icons.history, 'History', true, onTap: () {}),
                // Profile
                _buildNavItem(Icons.person, 'Profile', false, onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilPasajero(),
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

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    String subtitle = '',
    required String time,
    required String amount,
    String tag = '',
    Color tagColor = const Color(0xFFDAE2FD),
    Color tagTextColor = const Color(0xFF3F465C),
    bool isTopUp = false,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isTopUp ? const Color(0xFF10B981) : const Color(0xFFE8F0E9), // primary-container or surface-container
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isTopUp ? const Color(0xFF006C49).withOpacity(0.2) : const Color(0xFFBBCABF).withOpacity(0.2),
              ),
            ),
            child: Icon(
              icon,
              color: isTopUp ? Colors.white : const Color(0xFF006C49),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF161D19),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle.isNotEmpty ? subtitle : time,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
          // Amount and Tag
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: tagTextColor,
                    ),
                  ),
                ),
              if (subtitle.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EAE3), // surface-container-high
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
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