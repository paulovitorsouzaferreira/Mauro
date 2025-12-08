import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ClimaApp());
}

class ClimaApp extends StatefulWidget {
  const ClimaApp({super.key});

  @override
  State<ClimaApp> createState() => _ClimaAppState();
}

class _ClimaAppState extends State<ClimaApp> {
  double temp = 0;
  int umidade = 0;
  double vento = 0;

  @override
  void initState() {
    super.initState();
    carregarClima();
  }

  Future<void> carregarClima() async {
    // pega posição
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    // chama API
    String apiKey = "SUA_CHAVE_AQUI";
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&units=metric&appid=$apiKey";

    var resposta = await http.get(Uri.parse(url));
    var dados = json.decode(resposta.body);

    setState(() {
      temp = dados["main"]["temp"];
      umidade = dados["main"]["humidity"];
      vento = dados["wind"]["speed"] * 3.6; // m/s → km/h
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Clima Atual"),
              Text("Temperatura: ${temp.toStringAsFixed(1)} °C"),
              Text("Umidade: $umidade %"),
              Text("Vento: ${vento.toStringAsFixed(1)} km/h"),
            ],
          ),
        ),
      ),
    );
  }
}
