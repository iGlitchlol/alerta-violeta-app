import 'package:flutter/material.dart';
import '../screens/report_screen.dart';
import '../screens/map_screen.dart';
import '../screens/guia_screen.dart'; // Asegúrate de crear este archivo

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores globales de la App
    const Color primaryPurple = Color(0xFF7C3AED);
    const Color lightPurpleBg = Color(0xFFF5F3FF);
    const Color textDark = Color(0xFF2E1065);

    return Drawer(
      child: Container(
        color: lightPurpleBg,
        child: Column(
          children: [
            // Encabezado con Diseño Moderno
            DrawerHeader(
              decoration: const BoxDecoration(
                color: primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_moon_rounded, color: Colors.white, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Alerta Violeta",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Colima, México",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Opciones del Menú
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                    child: Text("SERVICIOS", 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  
                  _buildDrawerItem(
                    icon: Icons.add_alert_rounded,
                    label: "Nuevo Reporte",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen()));
                    },
                    color: primaryPurple,
                  ),

                  _buildDrawerItem(
                    icon: Icons.map_rounded,
                    label: "Mapa de Incidentes",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
                    },
                    color: primaryPurple,
                  ),

                  const Divider(height: 30, thickness: 1, indent: 15, endIndent: 15),

                  const Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 5),
                    child: Text("INFORMACIÓN Y APOYO", 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),

                  // ESTA ES LA PARTE QUE PIDIÓ TU PROFESOR
                  _buildDrawerItem(
                    icon: Icons.menu_book_rounded,
                    label: "Guía de Violencias",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GuiaScreen()));
                    },
                    color: Colors.orange.shade800,
                  ),

                  _buildDrawerItem(
                    icon: Icons.gavel_rounded,
                    label: "Artículos y Leyes",
                    onTap: () {
                      Navigator.pop(context);
                      // Aquí podrías abrir la misma GuiaScreen en la sección de leyes
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GuiaScreen()));
                    },
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),

            // Pie de página del Drawer
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Versión 1.0.0 - 2026",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para los items del menú
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E1065),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}