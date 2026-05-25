import 'package:flutter/material.dart';
import 'registro_pasajero.dart'; // <-- AGREGAR ESTA LÍNEA
import 'home_pasajero.dart';

class LoginPasajero extends StatefulWidget {
  const LoginPasajero({super.key});

  @override
  State<LoginPasajero> createState() => _LoginPasajeroState();
}

class _LoginPasajeroState extends State<LoginPasajero> {
  bool ocultarPin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // ICONO SUPERIOR
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3EC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.dialpad,
                    color: Color(0xFF008F5D),
                    size: 28,
                  ),
                ),

                const SizedBox(height: 24),

                // TITULO
                const Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Ingresa tus datos para continuar',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6E6E6E),
                  ),
                ),

                const SizedBox(height: 42),

                // NUMERO
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'NÚMERO DE CELULAR',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D3D3D),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 62,
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
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20),
                      prefixIcon: const Icon(
                        Icons.smartphone,
                        color: Color(0xFF5B5B5B),
                      ),
                      hintText: 'Ej. 71234567',
                      hintStyle: const TextStyle(
                        color: Color(0xFF8C8C8C),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // PIN Y OLVIDASTE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PIN (4 DÍGITOS)',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        '¿Olvidaste tu PIN?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF007A63),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF3EF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD9E3DB),
                    ),
                  ),
                  child: TextField(
                    obscureText: ocultarPin,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF5B5B5B),
                      ),
                      hintText: '••••',
                      hintStyle: const TextStyle(
                        letterSpacing: 5,
                        color: Color(0xFF6B6B6B),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarPin = !ocultarPin;
                          });
                        },
                        icon: Icon(
                          ocultarPin
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF5B5B5B),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOTON LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () { 
                        // Navegar al home del pasajero
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePasajero(),
                            ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16C784),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 34),

                // DIVISOR
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFD2D2D2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'o',
                        style: TextStyle(
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFD2D2D2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 34),

                // GOOGLE
                Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF3EF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD7DDD8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Ingresar con Google',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // REGISTRARSE (MODIFICADO CON NAVEGACIÓN)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistroPasajero(),
                                ),
                            );
                        },
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007A63),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}