import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TabuadaApp());
}

class TabuadaApp extends StatefulWidget {
  const TabuadaApp({super.key});

  @override
  _TabuadaAppState createState() => _TabuadaAppState();
}

class _TabuadaAppState extends State<TabuadaApp> {
  late SharedPreferences prefs;
  int numeroAtual = 1;
  int respostaCorreta = 0;
  String resposta = '';
  TextEditingController controladorResposta = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  _loadState() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      numeroAtual = prefs.getInt('numeroAtual') ?? 1;
      respostaCorreta = prefs.getInt('respostaCorreta') ?? 0;
    });
  }

  _saveState() async {
    await prefs.setInt('numeroAtual', numeroAtual);
    await prefs.setInt('respostaCorreta', respostaCorreta);
  }

  void verificarResposta() {
    if (int.tryParse(resposta) == (numeroAtual * 2)) {
      setState(() {
        respostaCorreta++;
        numeroAtual++;
        _saveState();
      });
    }
    controladorResposta.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tabuada')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Qual é o resultado de ${numeroAtual} x 2?',
                style: const TextStyle(fontSize: 24),
              ),
              TextField(
                controller: controladorResposta,
                decoration:
                    const InputDecoration(hintText: 'Digite sua resposta'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resposta = controladorResposta.text;
                    verificarResposta();
                  });
                },
                child: const Text('Verificar'),
              ),
              Text(
                'Respostas corretas: $respostaCorreta',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
