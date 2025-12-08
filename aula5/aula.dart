import 'package:flutter/material.dart';

void main() {
  runApp(const CalcApp());
}

class CalcApp extends StatefulWidget {
  const CalcApp({super.key});

  @override
  State<CalcApp> createState() => _CalcAppState();
}

class _CalcAppState extends State<CalcApp> {
  int op1 = 0;
  int op2 = 0;
  bool soma = false;
  int resultado = 0;

  void apertar(int n) {
    if (!soma) {
      op1 = op1 * 10 + n;
    } else {
      op2 = op2 * 10 + n;
    }
    print('Operador 1: $op1');
    print('Operador 2: $op2');
    print('Soma apertado: $soma');
    print('Resultado: $resultado');
    setState(() {});
  }

  void apertarMais() {
    soma = true;
    print('Operador 1: $op1');
    print('Operador 2: $op2');
    print('Soma apertado: $soma');
    print('Resultado: $resultado');
    setState(() {});
  }

  void apertarIgual() {
    resultado = op1 + op2;
    print('Operador 1: $op1');
    print('Operador 2: $op2');
    print('Soma apertado: $soma');
    print('Resultado: $resultado');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resultado: $resultado',
              style: const TextStyle(fontSize: 32),
            ),
            Row(
              children: [
                botao(7),
                botao(8),
                botao(9),
              ],
            ),
            Row(
              children: [
                botao(4),
                botao(5),
                botao(6),
              ],
            ),
            Row(
              children: [
                botao(1),
                botao(2),
                botao(3),
              ],
            ),
            Row(
              children: [
                botao(0),
                Expanded(
                  child: TextButton(
                    onPressed: apertarIgual,
                    child: const Text('='),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: apertarMais,
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget botao(int n) {
    return Expanded(
      child: TextButton(
        onPressed: () => apertar(n),
        child: Text('$n'),
      ),
    );
  }
}
