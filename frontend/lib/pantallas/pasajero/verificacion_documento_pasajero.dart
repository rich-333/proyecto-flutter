import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
// Avoid importing dart:io to keep web compatibility; use XFile from image_picker instead
import '../../services/api_service.dart';

class VerificacionDocumentoPasajero extends StatefulWidget {
  final String tipoUsuario;
  final String fullName;
  final String ci;
  final String phone;
  final String email;
  final String password;
  final String birthDate;

  const VerificacionDocumentoPasajero({
    super.key,
    required this.tipoUsuario,
    required this.fullName,
    required this.ci,
    required this.phone,
    required this.email,
    required this.password,
    required this.birthDate,
  });

  @override
  State<VerificacionDocumentoPasajero> createState() =>
      _VerificacionDocumentoPasajeroState();
}

class _VerificacionDocumentoPasajeroState
    extends State<VerificacionDocumentoPasajero> {
  bool isFileUploaded = false;
  String fileName = '';
  XFile? selectedFile;
  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  final Map<String, Map<String, String>> tiposDocumento = {
    'estudiante_escolar': {
      'titulo': 'Verificación de Estudiante Escolar',
      'descripcion':
          'Sube una foto de tu carnet de identidad vigente para acceder a la tarifa preferencial.',
      'icono': 'school',
    },
    'estudiante_universitario': {
      'titulo': 'Verificación de Estudiante Universitario',
      'descripcion':
          'Sube una foto de tu carnet universitario vigente para acceder a la tarifa preferencial.',
      'icono': 'school_outlined',
    },
    'adulto_mayor': {
      'titulo': 'Verificación de Adulto Mayor',
      'descripcion':
          'Sube una foto de tu carnet de identidad vigente para acceder a la tarifa preferencial.',
      'icono': 'accessibility_new',
    },
    'discapacitado': {
      'titulo': 'Verificación de Discapacitado',
      'descripcion':
          'Sube una foto de tu carnet de discapacitado vigente para acceder a la tarifa preferencial.',
      'icono': 'accessibility',
    },
  };

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedFile = image;
          isFileUploaded = true;
          fileName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _finishRegistration() async {
    if (!isFileUploaded || selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un documento')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // If running on web, read bytes from XFile and send bytes; otherwise send path
      if (kIsWeb) {
        final bytes = await selectedFile!.readAsBytes();
        final response = await ApiService.registerPassenger(
          fullName: widget.fullName,
          ci: widget.ci,
          phone: widget.phone,
          email: widget.email,
          password: widget.password,
          birthDate: widget.birthDate,
          userType: widget.tipoUsuario,
          documentImageBytes: bytes,
        );

        if (mounted) {
          if (response['message'] != null) {
            if (response['token'] != null) {
              await ApiService.saveToken(response['token']);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );

            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(response['error'] ?? 'Error al registrar documento'),
              ),
            );
          }
        }
      } else {
        final response = await ApiService.registerPassenger(
          fullName: widget.fullName,
          ci: widget.ci,
          phone: widget.phone,
          email: widget.email,
          password: widget.password,
          birthDate: widget.birthDate,
          userType: widget.tipoUsuario,
          documentImage: selectedFile!.path,
        );

        if (mounted) {
          if (response['message'] != null) {
            if (response['token'] != null) {
              await ApiService.saveToken(response['token']);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );

            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(response['error'] ?? 'Error al registrar documento'),
              ),
            );
          }
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

  String _getButtonText() {
    switch (widget.tipoUsuario) {
      case 'estudiante_escolar':
      case 'estudiante_universitario':
      case 'discapacitado':
        return 'Continuar';
      case 'adulto_mayor':
        return 'Finalizar registro';
      default:
        return 'Continuar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoInfo = tiposDocumento[widget.tipoUsuario] ?? tiposDocumento['general']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4),
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
                              fontWeight: FontWeight.w600,
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

                  // Contenido dinámico
                  Text(
                    tipoInfo['titulo']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161D19),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tipoInfo['descripcion']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload Area
                  GestureDetector(
                    onTap: _selectImage,
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
                      child: selectedFile != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.2),
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
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continuar/Finalizar Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _finishRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor:
                            const Color(0xFF10B981).withOpacity(0.5),
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
                          : Text(
                              _getButtonText(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
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
    );
  }
}
