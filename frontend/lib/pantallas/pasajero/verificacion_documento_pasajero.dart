import 'package:flutter/material.dart';

class VerificacionDocumentoPasajero extends StatefulWidget {
  final String tipoUsuario; // 'Estudiante' o 'Mayor'

  const VerificacionDocumentoPasajero({
    super.key,
    required this.tipoUsuario,
  });

  @override
  State<VerificacionDocumentoPasajero> createState() => _VerificacionDocumentoPasajeroState();
}

class _VerificacionDocumentoPasajeroState extends State<VerificacionDocumentoPasajero> {
  bool isFileUploaded = false;
  String fileName = '';
  late String currentTipo;

  @override
  void initState() {
    super.initState();
    currentTipo = widget.tipoUsuario;
  }

  @override
  Widget build(BuildContext context) {
    final isEstudiante = currentTipo == 'Estudiante';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4), // background
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
              children: [
                // Back button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8F0E9),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF161D19),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF006C49),
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
                  const SizedBox(height: 24),
                  // Progress Indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paso 2 de 2',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: Color(0xFF565E74),
                            ),
                          ),
                          const Text(
                            'Verificación',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: Color(0xFF006C49),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE4DD),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Toggle Scenarios
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentTipo = 'Estudiante';
                                isFileUploaded = false;
                                fileName = '';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isEstudiante ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: isEstudiante
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Estudiante',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: isEstudiante
                                      ? const Color(0xFF006C49)
                                      : const Color(0xFF3C4A42),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentTipo = 'Mayor';
                                isFileUploaded = false;
                                fileName = '';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isEstudiante ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: !isEstudiante
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Adulto Mayor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: !isEstudiante
                                      ? const Color(0xFF006C49)
                                      : const Color(0xFF3C4A42),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Contenido según el tipo
                  if (isEstudiante) _buildStudentVerification() else _buildSeniorVerification(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verificación de Estudiante',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF161D19),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sube una foto de tu carnet estudiantil vigente para acceder a la tarifa preferencial.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF3C4A42),
          ),
        ),
        const SizedBox(height: 24),
        // Upload Area
        GestureDetector(
          onTap: () {
            setState(() {
              isFileUploaded = true;
              fileName = 'carnet_estudiante.jpg';
            });
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 250),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF6EE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4EDEA3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isFileUploaded) ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      color: Color(0xFF006C49),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tocar para subir foto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF006C49),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Formatos aceptados: JPG, PNG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Color(0xFF565E74),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Documento cargado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Color(0xFF565E74),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tocar para cambiar',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF006C49),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Continuar Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Navegar al Home
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeniorVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verificación de Adulto Mayor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF161D19),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sube una foto de tu carnet de identidad vigente para acceder a la tarifa preferencial.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF3C4A42),
          ),
        ),
        const SizedBox(height: 24),
        // Upload Area
        GestureDetector(
          onTap: () {
            setState(() {
              isFileUploaded = true;
              fileName = 'carnet_identidad.jpg';
            });
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 250),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF6EE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4EDEA3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isFileUploaded) ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      color: Color(0xFF006C49),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tocar para subir foto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF006C49),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Formatos aceptados: JPG, PNG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Color(0xFF565E74),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Documento cargado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Color(0xFF565E74),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tocar para cambiar',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF006C49),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Finalizar registro Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Navegar al Home
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Finalizar registro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}