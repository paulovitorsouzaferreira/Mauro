import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: AppClima()));
}

class AppClima extends StatefulWidget {
  const AppClima({super.key});

  @override
  State<AppClima> createState() => _AppClimaState();
}

class _AppClimaState extends State<AppClima> {
  TextEditingController cidadeCtrl = TextEditingController();
  String temperatura = '';
  String umidade = '';
  String vento = '';
  bool carregando = false;

  Future<void> buscarClima() async {
    setState(() => carregando = true);

    // 1) Buscar latitude e longitude da cidade
    final geo = await http.get(Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=${cidadeCtrl.text}&count=1"));

    final dadosGeo = jsonDecode(geo.body);
    final lat = dadosGeo['results'][0]['latitude'];
    final lon = dadosGeo['results'][0]['longitude'];

    // 2) Buscar clima
    final clima = await http.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m"));

    final dadosClima = jsonDecode(clima.body)['current'];

    setState(() {
      temperatura = "${dadosClima['temperature_2m']} °C";
      umidade = "${dadosClima['relative_humidity_2m']} %";
      vento = "${dadosClima['wind_speed_10m']} km/h";
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clima da Cidade")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: cidadeCtrl,
              decoration: InputDecoration(
                  hintText: "Digite uma cidade", filled: true),
            ),
            SizedBox(height: 10),
            TextButton(
                onPressed: buscarClima,
                child: Text("Buscar clima")
            ),
            SizedBox(height: 20),
            if (carregando) CircularProgressIndicator(),
            if (!carregando && temperatura.isNotEmpty) ...[
              Text("Temperatura: $temperatura"),
              Text("Umidade: $umidade"),
              Text("Vento: $vento"),
            ]
          ],
        ),
      ),
    );
  }
}
