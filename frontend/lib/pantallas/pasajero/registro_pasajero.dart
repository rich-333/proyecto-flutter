import 'package:flutter/material.dart';
import 'verificacion_documento_pasajero.dart';

class RegistroPasajero extends StatefulWidget {
  const RegistroPasajero({super.key});

  @override
  State<RegistroPasajero> createState() => _RegistroPasajeroState();
}

class _RegistroPasajeroState extends State<RegistroPasajero> {
  bool ocultarPassword = true;
  String? tipoPasajero = 'General'; // General, Estudiante, Mayor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER VERDE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 8,
                  right: 8,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB7E5C3),
                      Color(0xFFD8F3DD),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Emerald',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF007A63),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ],
                ),
              ),

              // CARD BLANCA
              Transform.translate(
                offset: const Offset(0, -10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITULO
                        const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Únete a la nueva era del transporte.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // TIPO PASAJERO
                        const Text(
                          'Tipo de pasajero',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: _tipoCard(
                                icono: Icons.person,
                                texto: 'General',
                                seleccionado: tipoPasajero == 'General',
                                onTap: () {
                                  setState(() {
                                    tipoPasajero = 'General';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _tipoCard(
                                icono: Icons.school_outlined,
                                texto: 'Estudiante',
                                seleccionado: tipoPasajero == 'Estudiante',
                                onTap: () {
                                  setState(() {
                                    tipoPasajero = 'Estudiante';
                                  });
                                  // Navegar a verificación de Estudiante
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const VerificacionDocumentoPasajero(
                                        tipoUsuario: 'Estudiante',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _tipoCard(
                                icono: Icons.accessibility_new,
                                texto: 'Mayor',
                                seleccionado: tipoPasajero == 'Mayor',
                                onTap: () {
                                  setState(() {
                                    tipoPasajero = 'Mayor';
                                  });
                                  // Navegar a verificación de Adulto Mayor
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const VerificacionDocumentoPasajero(
                                        tipoUsuario: 'Mayor',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        Container(
                          height: 1,
                          color: const Color(0xFFE3E3E3),
                        ),

                        const SizedBox(height: 26),

                        // NOMBRE
                        const Text(
                          'Nombre completo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF444444),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _input(
                          hint: 'Ej. Juan Pérez',
                        ),

                        const SizedBox(height: 18),

                        // FILA CI Y FECHA
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CI',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _input(
                                    hint: 'Número',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fecha de nac.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _input(
                                    hint: 'dd/mm/aaaa',
                                    icono: Icons.calendar_today_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // TELEFONO
                        const Text(
                          'Teléfono',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF444444),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _input(
                          hint: '+591 00000000',
                        ),

                        const SizedBox(height: 18),

                        // CORREO
                        const Text(
                          'Correo electrónico',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF444444),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _input(
                          hint: 'correo@ejemplo.com',
                        ),

                        const SizedBox(height: 18),

                        // PASSWORD
                        const Text(
                          'Contraseña',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF444444),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF3EF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFD9E3DB),
                            ),
                          ),
                          child: TextField(
                            obscureText: ocultarPassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              hintText: '••••••••••',
                              hintStyle: const TextStyle(
                                letterSpacing: 3,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    ocultarPassword =
                                        !ocultarPassword;
                                  });
                                },
                                icon: Icon(
                                  ocultarPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF444444),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 34),

                        // BOTON
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              // Si es General, ir al Home directamente
                              if (tipoPasajero == 'General') {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                // Para Estudiante o Mayor, ya navegamos al hacer tap en el tipo
                                // Aquí solo mostramos un mensaje
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Completa la verificación'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF007A4D),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // INICIAR SESION
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '¿Ya tienes cuenta? ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Inicia sesión',
                                    style: TextStyle(
                                      color: Color(0xFF007A63),
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String hint,
    IconData? icono,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD9E3DB),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF7A7A7A),
          ),
          suffixIcon: icono != null
              ? Icon(
                  icono,
                  size: 20,
                  color: Colors.black54,
                )
              : null,
        ),
      ),
    );
  }

  Widget _tipoCard({
    required IconData icono,
    required String texto,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: seleccionado
              ? const Color(0xFFEFF8F1)
              : const Color(0xFFF3F3F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFF007A63)
                : const Color(0xFFD7D7D7),
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              color: const Color(0xFF005F46),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2B2B2B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}