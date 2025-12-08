import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var opcoes = ["Pedra", "Papel", "Tesoura"];

  int rodadas = 0;

  String resultado = "";
  String escolhaUser = "";
  String escolhaCPU = "";

  // 0 = pedra, 1 = papel, 2 = tesoura
  int escolherCPU() {
    var r = Random();

    // A cada 5 rodadas, 1 vitória só
    if (rodadas % 5 != 0) {
      // máquina tenta ganhar
      if (escolhaUser == "Pedra") return 1;
      if (escolhaUser == "Papel") return 2;
      if (escolhaUser == "Tesoura") return 0;
    }

    return r.nextInt(3);
  }

  void jogar(int escolha) {
    setState(() {
      escolhaUser = opcoes[escolha];
      var cpuIndex = escolherCPU();
      escolhaCPU = opcoes[cpuIndex];

      rodadas++;

      if (escolha == cpuIndex) {
        resultado = "Empate!";
      } else if ((escolha == 0 && cpuIndex == 2) ||
          (escolha == 1 && cpuIndex == 0) ||
          (escolha == 2 && cpuIndex == 1)) {
        resultado = "Você ganhou!";
      } else {
        resultado = "A máquina ganhou!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Escolha uma opção:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => jogar(0), child: Text("Pedra")),
                TextButton(onPressed: () => jogar(1), child: Text("Papel")),
                TextButton(onPressed: () => jogar(2), child: Text("Tesoura")),
              ],
            ),
            SizedBox(height: 30),
            Text("Você: $escolhaUser"),
            Text("CPU: $escolhaCPU"),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
