import 'package:flutter/material.dart';
import 'report_screen.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de colores consistentes con tu Web
    const Color primaryPurple = Color(0xFF7C3AED);
    const Color lightPurpleBg = Color(0xFFF5F3FF);
    const Color borderPurple = Color(0xFFE9D5FF);

    return Scaffold(
      backgroundColor: lightPurpleBg,
      // AppBar elegante y plano
      appBar: AppBar(
        title: const Text(
          "Alerta Violeta Colima",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Elemento visual superior
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.shield_moon_rounded,
                  size: 80,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                "Tu seguridad nos importa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E1065), // El color oscuro de tu CSS
                ),
              ),
              const SizedBox(height: 10),
              
              Text(
                "Reporta cualquier incidente de forma rápida y segura en el estado de Colima.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 50),

              // 🔥 BOTÓN CORREGIDO Y ESTILIZADO
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shadowColor: primaryPurple.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      // Aquí corregimos el error del borderSide:
                      side: const BorderSide(
                        color: borderPurple,
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportScreen()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 28),
                      SizedBox(width: 15),
                      Text(
                        "REPORTAR AHORA",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Indicador de seguridad
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 5),
                  Text(
                    "Conexión cifrada y anónima",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}