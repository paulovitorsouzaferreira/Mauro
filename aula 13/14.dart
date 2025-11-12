import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double? latitude;
  double? longitude;
  String? temperatura;
  String? umidade;
  String? velocidadeVento;

  @override
  void initState() {
    super.initState();
    _getPosicao();
  }

  // Função para pegar a posição atual
  void _getPosicao() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    if (latitude != null && longitude != null) {
      _buscarDadosClimaticos(latitude!, longitude!);
    }
  }

  Future<void> _buscarDadosClimaticos(double lat, double lon) async {
    final apiKey = 'SUA_API_KEY_AQUI';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pt_br');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperatura = '${data['main']['temp']} °C';
        umidade = '${data['main']['humidity']}%';
        velocidadeVento = '${data['wind']['speed']} m/s';
      });
    } else {
      throw Exception('Falha ao carregar dados meteorológicos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clima Atual'),
        ),
        body: Center(
          child: latitude == null || longitude == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Latitude: $latitude', style: TextStyle(fontSize: 20)),
                    Text('Longitude: $longitude',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    temperatura != null
                        ? Text('Temperatura: $temperatura',
                            style: TextStyle(fontSize: 20))
                        : const CircularProgressIndicator(),
                    umidade != null
                        ? Text('Umidade: $umidade',
                            style: TextStyle(fontSize: 20))
                        : const CircularProgressIndicator(),
                    velocidadeVento != null
                        ? Text('Velocidade do vento: $velocidadeVento',
                            style: TextStyle(fontSize: 20))
                        : const CircularProgressIndicator(),
                  ],
                ),
        ),
      ),
    );
  }
}
