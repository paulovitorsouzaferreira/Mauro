import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> cotacao() async {
  var url = Uri.https(
      'olinda.bcb.gov.br',
      '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
      {'@dataCotacao': '\'03-07-2025\'', '\$top': '1', '\$format': 'json', '\$select': 'cotacaoCompra'});

  var r = await http.get(url);
  var j = json.decode(r.body);
  return j['value'][0]['cotacaoCompra'];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: cotacao(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: Text('Carregando...'));
            return Center(child: Text('Dólar: ${snapshot.data}'));
          },
        ),
      ),
    );
  }
}
