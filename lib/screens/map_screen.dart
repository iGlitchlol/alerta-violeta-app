import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  // 🔥 COLOR SEGÚN CATEGORÍA
  Color getColor(String categoria) {
    switch (categoria) {
      case "Robo":
        return Colors.orange;
      case "Violencia Física":
        return Colors.red;
      case "Seguimiento":
        return Colors.purple;
      case "Acoso":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // 🔥 Cargar datos desde API
  Future<void> loadReports() async {
    final url = Uri.parse("https://alerta-violeta-web.vercel.app/api/report");

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    List<Marker> tempMarkers = [];

    for (var r in data) {
      final lat = r["lat"];
      final lng = r["lng"];
      final categoria = r["categoria"] ?? "Acoso";

      tempMarkers.add(
        Marker(
          point: LatLng(lat, lng),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Reporte"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("📍 Ubicación: $lat, $lng"),
                      Text("⚠️ Categoría: $categoria"),
                      Text("📅 Fecha: ${r["fecha"]}"),

                      // 🔥 Imagen
                      if (r["foto"] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.memory(
                            base64Decode(r["foto"]),
                            height: 150,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },

            // 🔥 ICONO CON COLOR DINÁMICO
            child: Icon(
              Icons.location_on,
              color: getColor(categoria),
              size: 40,
            ),
          ),
        ),
      );
    }

    setState(() {
      markers = tempMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Riesgo")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(19.2435, -103.7251),
          initialZoom: 13,
        ),
        children: [
          // 🔥 MAPA SIN BLOQUEO
          TileLayer(
            urlTemplate:
                "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
            subdomains: ['a', 'b', 'c'],
          ),

          // 🔥 MARCADORES
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}