import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Classe que representa a localização atual
class Localizacao {
  double? latitude;
  double? longitude;

  // Método que busca a localização atual e preenche os atributos
  Future<void> pegaLocalizacaoAtual() async {
    // Verifica permissões
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
          'Permissão de localização permanentemente negada. Vá nas configurações e ative.');
    }

    // Pega a posição atual
    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = posicao.latitude;
    longitude = posicao.longitude;
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Localizacao local = Localizacao();

  String textoLatitude = '...';
  String textoLongitude = '...';

  @override
  void initState() {
    super.initState();
    _buscarLocalizacao();
  }

  Future<void> _buscarLocalizacao() async {
    try {
      await local.pegaLocalizacaoAtual();

      setState(() {
        textoLatitude = local.latitude.toString();
        textoLongitude = local.longitude.toString();
      });
    } catch (e) {
      setState(() {
        textoLatitude = 'Erro ao obter localização';
        textoLongitude = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Busca Local',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Latitude: $textoLatitude'),
              Text('Longitude: $textoLongitude'),
            ],
          ),
        ),
      ),
    );
  }
}
