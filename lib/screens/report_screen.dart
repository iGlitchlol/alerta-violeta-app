import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Position? position;
  File? image;
  final picker = ImagePicker();
  String categoria = "Acoso";
  bool isSending = false;

  // 🔥 NUEVO: Controlador para capturar el texto de la descripción
  final TextEditingController _descController = TextEditingController();

  final Color primaryPurple = const Color(0xFF7C3AED);
  final Color lightBg = const Color(0xFFF5F3FF);
  final Color darkText = const Color(0xFF2E1065);

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // 🔥 IMPORTANTE: Limpiar el controlador cuando se cierra la pantalla
  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    Position pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      position = pos;
    });
  }

  Future<void> _takePhoto() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> _sendData() async {
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esperando ubicación GPS...")),
      );
      return;
    }

    if (!mounted) return;
    setState(() => isSending = true);

    try {
      final url = Uri.parse("https://verduzco2.vercel.app/api/report");
      String? base64Image;

      if (image != null) {
        final bytes = await image!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lat": position!.latitude,
          "lng": position!.longitude,
          "fecha": DateTime.now().toString(),
          "foto": base64Image,
          "categoria": categoria,
          "descripcion": _descController.text, // 🔥 NUEVO: Enviamos la descripción
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Reporte enviado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Error del servidor");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Error al enviar el reporte"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text(
          "Nuevo Reporte",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles del incidente",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            const SizedBox(height: 20),

            // Card de Ubicación
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: primaryPurple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      position == null
                          ? "Obteniendo coordenadas..."
                          : "Ubicación detectada",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Selector de Categoría
            DropdownButtonFormField<String>(
              value: categoria,
              decoration: InputDecoration(
                labelText: "Categoría",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFE9D5FF)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: ["Acoso", "Robo", "Violencia Física", "Seguimiento"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => categoria = value!),
            ),

            const SizedBox(height: 25),

            // 🔥 NUEVO: Campo de Descripción (Debajo de categoría)
            TextField(
              controller: _descController,
              maxLines: 3, // Permite escribir varios reglones
              decoration: InputDecoration(
                labelText: "Descripción",
                hintText: "Escribe detalles de lo sucedido...",
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true, // Mantiene el label arriba
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFE9D5FF)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            const SizedBox(height: 25),

            // Área de Fotografía
            const Text(
              "Evidencia visual (opcional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE9D5FF), width: 2),
                ),
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(image!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded,
                              size: 50, color: primaryPurple.withOpacity(0.5)),
                          const SizedBox(height: 10),
                          const Text("Presiona para tomar foto"),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 40),

            // Botón de Envío
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: isSending ? null : _sendData,
                child: isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "ENVIAR REPORTE SEGURO",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}