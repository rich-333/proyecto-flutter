import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'verificacion_documento_pasajero.dart';

class RegistroPasajero extends StatefulWidget {
  const RegistroPasajero({super.key});

  @override
  State<RegistroPasajero> createState() => _RegistroPasajeroState();
}

class _RegistroPasajeroState extends State<RegistroPasajero> {
  bool ocultarPassword = true;
  String? tipoPasajero = 'general';
  bool isLoading = false;

  // Controladores de texto
  late TextEditingController fullNameController;
  late TextEditingController ciController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController birthDateController;

  final Map<String, Map<String, String>> tiposUsuario = {
    'general': {
      'label': 'General',
      'icon': 'person',
    },
    'estudiante_escolar': {
      'label': 'Estudiante Escolar',
      'icon': 'school',
    },
    'estudiante_universitario': {
      'label': 'Estudiante Universitario',
      'icon': 'school_outlined',
    },
    'adulto_mayor': {
      'label': 'Adulto Mayor',
      'icon': 'accessibility_new',
    },
    'discapacitado': {
      'label': 'Discapacitado',
      'icon': 'accessibility',
    },
  };

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    ciController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    birthDateController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ciController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDateController.text = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'school':
        return Icons.school;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'accessibility':
        return Icons.accessibility;
      default:
        return Icons.person;
    }
  }

  Future<void> _handleRegister() async {
    // Validar campos
    if (fullNameController.text.isEmpty ||
        ciController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        birthDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 8 caracteres'),
        ),
      );
      return;
    }

    // Normalize inputs
    final fullName = fullNameController.text.trim();
    final ci = ciController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final birthDate = birthDateController.text.trim();

    // Validaciones adicionales
    if (fullName.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre debe tener al menos 2 caracteres')),
      );
      return;
    }

    // Cédula: alfanumérico mínimo 8 caracteres
    if (!RegExp(r'^[A-Za-z0-9]{7,}$').hasMatch(ci)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cédula debe tener al menos 7 caracteres alfanuméricos')),
      );
      return;
    }

    // Teléfono: solo dígitos y mínimo 8 caracteres
      if (!RegExp(r'^\d{8,}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El teléfono debe contener solo números y tener al menos 8 dígitos')),
      );
      return;
    }

    // Email simple validation
    if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo electrónico válido')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Si es general, registrar directamente
      if (tipoPasajero == 'general') {
        final response = await ApiService.registerPassenger(
          fullName: fullName,
          ci: ci,
          phone: phone,
          email: email,
          password: passwordController.text,
          birthDate: birthDate,
          userType: tipoPasajero!,
        );

        if (mounted) {
          if (response['message'] != null) {
            // Guardar token si viene en la respuesta
            if (response['token'] != null) {
              await ApiService.saveToken(response['token']);
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );
            
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['error'] ?? 'Error al registrar')),
            );
          }
        }
      } else {
        // Ir a verificación de documento
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificacionDocumentoPasajero(
                tipoUsuario: tipoPasajero!,
                fullName: fullName,
                ci: ci,
                phone: phone,
                email: email,
                password: passwordController.text,
                birthDate: birthDate,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

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
                child: Row(
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

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: tiposUsuario.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _tipoCard(
                                  icono: _getIcon(entry.value['icon']!),
                                  texto: entry.value['label']!,
                                  seleccionado: tipoPasajero == entry.key,
                                  onTap: () {
                                    setState(() {
                                      tipoPasajero = entry.key;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
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
                          controller: fullNameController,
                        ),
                        const SizedBox(height: 18),

                        // FILA CI Y FECHA
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cédula de Identidad',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _input(
                                    hint: 'Ej. 12345678',
                                    controller: ciController,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fecha de nacimiento',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _selectBirthDate,
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF3EF),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9E3DB),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: Text(
                                                birthDateController.text.isEmpty
                                                    ? 'Seleccionar'
                                                    : birthDateController.text,
                                                style: const TextStyle(
                                                  color: Color(0xFF7A7A7A),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 16),
                                            child: Icon(
                                              Icons.calendar_today,
                                              size: 20,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                          controller: phoneController,
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
                          controller: emailController,
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
                            controller: passwordController,
                            obscureText: ocultarPassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              hintText: '••••••••••',
                              hintStyle: const TextStyle(
                                letterSpacing: 3,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  ocultarPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    ocultarPassword = !ocultarPassword;
                                  });
                                },
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
                            onPressed: isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007A4D),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor:
                                  const Color(0xFF007A4D).withOpacity(0.5),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Crear cuenta',
                                    style: TextStyle(
                                      fontSize: 18,
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
                                text: '¿Ya tienes cuenta? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A4A4A),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Inicia sesión',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF007A63),
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
    TextEditingController? controller,
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
        controller: controller,
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
        width: 90,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
