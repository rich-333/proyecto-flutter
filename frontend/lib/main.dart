import 'package:flutter/material.dart';

// Pasajero
import 'pantallas/pasajero/login_pasajero.dart';
import 'pantallas/pasajero/registro_pasajero.dart';
import 'pantallas/pasajero/home_pasajero.dart';
import 'pantallas/pasajero/historial_pasajero.dart';
import 'pantallas/pasajero/perfil_pasajero.dart';
import 'pantallas/pasajero/scan_qr_pasajero.dart';
import 'pantallas/pasajero/confirmar_pago_pasajero.dart';
import 'pantallas/pasajero/pago_exitoso_pasajero.dart';
import 'pantallas/pasajero/verificacion_documento_pasajero.dart';

// Chofer
import 'pantallas/chofer/chofer_theme.dart';
import 'pantallas/chofer/login_chofer.dart';
import 'pantallas/chofer/dashboard_chofer.dart';
import 'pantallas/chofer/notificacion_pago_chofer.dart';
import 'pantallas/chofer/resumen_jornada_chofer.dart';

final _choferThemeNotifier = ChoferThemeNotifier();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transito Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      // Envuelve TODA la app con el proveedor de tema del chofer
      builder: (context, child) {
        return ChoferThemeProvider(
          notifier: _choferThemeNotifier,
          child: child!,
        );
      },
      routes: {
        // ── Pasajero ──────────────────────────────────────────────────────────
        '/': (context) => const LoginPasajero(),
        '/registro': (context) => const RegistroPasajero(),
        '/home': (context) => const HomePasajero(),
        '/historial': (context) => const HistorialPasajero(),
        '/perfil': (context) => const PerfilPasajero(),
        '/scan': (context) => const ScanQrPasajero(),
        '/confirmar-pago': (context) => const ConfirmarPagoPasajero(),
        '/pago-exitoso': (context) => const PagoExitosoPasajero(),
        '/verificacion': (context) =>
            const VerificacionDocumentoPasajero(tipoUsuario: 'Estudiante'),

        // ── Chofer ────────────────────────────────────────────────────────────
        '/chofer': (context) => const LoginChofer(),
        '/chofer/dashboard': (context) => const DashboardChofer(),
        '/chofer/notificacion-pago': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, String>? ??
              {};
          return NotificacionPagoChofer(
            monto: args['monto'] ?? 'Bs 2.00',
            nombre: args['nombre'] ?? '',
            tipo: args['tipo'] ?? 'General',
          );
        },
        '/chofer/resumen': (context) => const ResumenJornadaChofer(),
      },
    );
  }
}
