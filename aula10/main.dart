import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double altura = 80.0;
const Color fundo = Color(0xFF1E164B);
const Color corApertada = Color.fromARGB(255, 45, 11, 237);

enum Sexo { masculino, feminino }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  double _altura = 150;
  double _peso = 65;
  double _resultadoIMC = 0;

  Sexo _sexoSelecionado = Sexo.masculino;
  Color _corMasculino = fundo;
  Color _corFeminino = fundo;

  void _calcularIMC() {
    setState(() {
      double alturaEmMetros = _altura / 100;
      _resultadoIMC = _peso / (alturaEmMetros * alturaEmMetros);
    });
  }

  void _mudarCorCaixa(Sexo sexo) {
    setState(() {
      if (sexo == Sexo.masculino) {
        _corMasculino = corApertada;
        _corFeminino = fundo;
      } else {
        _corFeminino = corApertada;
        _corMasculino = fundo;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IMC')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _mudarCorCaixa(Sexo.masculino);
                    },
                    child: Caixa(
                      cor: _corMasculino,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male,
                            color: Colors.white,
                            size: 80.0,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'MASC',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _mudarCorCaixa(Sexo.feminino);
                    },
                    child: Caixa(
                      cor: _corFeminino,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female,
                            color: Colors.white,
                            size: 80.0,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'FEM',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Altura:',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${_altura.toStringAsFixed(0)} cm',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  Slider(
                    value: _altura,
                    min: 60,
                    max: 260,
                    divisions: 195,
                    label: '${_altura.toStringAsFixed(0)} cm',
                    onChanged: (double valor) {
                      setState(() {
                        _altura = valor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Peso:',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${_peso.toStringAsFixed(0)} kg',
                          style: TextStyle(fontSize: 24.0, color: Colors.white),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (_peso > 0) _peso--;
                                });
                              },
                              child: const Icon(Icons.remove),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _peso++;
                                });
                              },
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Resultado:',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _resultadoIMC > 0
                              ? _resultadoIMC.toStringAsFixed(2)
                              : '0.00',
                          style: TextStyle(fontSize: 24.0, color: Colors.white),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _calcularIMC,
                          child: const Text('Calcular IMC'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFF638ED6),
            width: double.infinity,
            height: altura,
            margin: EdgeInsets.only(top: 10.0),
          ),
        ],
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
