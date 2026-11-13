import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importante importar esto

class GuiaScreen extends StatelessWidget {
  const GuiaScreen({super.key});

  // Función para realizar la llamada
  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Si por alguna razón no puede llamar (ej. una tablet sin chip)
      debugPrint('No se pudo realizar la llamada a $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7C3AED);
    const Color darkText = Color(0xFF2E1065);
    const Color bgPurple = Color(0xFFF5F3FF);

    return Scaffold(
      backgroundColor: bgPurple,
      appBar: AppBar(
        title: const Text(
          "Guía y Protocolos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Glosario de Violencias",
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              color: darkText
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Identificar la violencia es el primer paso para erradicarla. Conoce tus derechos en Colima.",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 25),

          _buildInfoCard(
            title: "Acoso Sexual Callejero",
            icon: Icons.record_voice_over_rounded,
            content: "Conductas físicas o verbales de naturaleza sexual no deseadas. \n\nEjemplos: Piropos agresivos, persecución, o toma de fotografías sin consentimiento. En Colima, esto es sancionable.",
            color: primaryPurple,
          ),

          _buildInfoCard(
            title: "Violencia Física",
            icon: Icons.front_hand_rounded,
            content: "Cualquier acto que cause daño corporal. No importa la intensidad, si hay intención de dañar mediante contacto físico, es violencia.",
            color: Colors.redAccent,
          ),

          _buildInfoCard(
            title: "Leyes en Colima",
            icon: Icons.gavel_rounded,
            content: "La Ley de Acceso de las Mujeres a una Vida Libre de Violencia del Estado de Colima garantiza tu protección integral y el derecho a denunciar ante el Ministerio Público.",
            color: Colors.blueGrey,
          ),

          const SizedBox(height: 30),

          // RECUADRO DE AYUDA DIRECTA CON BOTONES FUNCIONALES
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.contact_support_rounded, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      "¿Necesitas ayuda ahora?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Usa estos botones para contactar a las autoridades de Colima de inmediato.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 13),
                ),
                const SizedBox(height: 20),
                
                // Botón 911
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall("911"),
                    icon: const Icon(Icons.emergency),
                    label: const Text("Llamar al 911 (Emergencias)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Botón Línea Mujer Colima
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _makeCall("075"), // Número típico de Línea Mujer / Denuncia
                    icon: const Icon(Icons.woman),
                    label: const Text("Llamar a Línea Mujer (075)"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryPurple,
                      side: const BorderSide(color: primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required String content, required Color color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      color: Colors.white,
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E1065))),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
          ),
        ],
      ),
    );
  }
}