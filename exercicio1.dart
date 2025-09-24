import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Perguntas());
}

class Perguntas extends StatefulWidget {
  const Perguntas({super.key});

  @override
  State<Perguntas> createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  List<Widget> resultado = [];
  int numeroPergunta = 0;
  late SharedPreferences prefs;

  List<Map<String, dynamic>> perguntas = [
    {
      'texto': 'Qual é a capital da França?',
      'alternativas': ['Berlim', 'Madrid', 'Paris', 'Roma'],
      'resposta': 2
    },
    {
      'texto': 'Quem escreveu "Dom Quixote"?',
      'alternativas': [
        'William Shakespeare',
        'Miguel de Cervantes',
        'Gabriel García Márquez',
        'Fiódor Dostoiévski'
      ],
      'resposta': 1
    },
    {
      'texto': 'Qual é o maior planeta do sistema solar?',
      'alternativas': ['Terra', 'Marte', 'Júpiter', 'Saturno'],
      'resposta': 2
    },
    {
      'texto': 'Em que ano ocorreu a Revolução Francesa?',
      'alternativas': ['1776', '1789', '1812', '1848'],
      'resposta': 1
    },
    {
      'texto': 'Quem pintou a Mona Lisa?',
      'alternativas': [
        'Vincent van Gogh',
        'Pablo Picasso',
        'Leonardo da Vinci',
        'Claude Monet'
      ],
      'resposta': 2
    },
    {
      'texto': 'Qual é o elemento químico representado pelo símbolo "O"?',
      'alternativas': ['Ouro', 'Oxigênio', 'Osmium', 'Ósmio'],
      'resposta': 1
    },
    {
      'texto': 'Qual é o rio mais longo do mundo?',
      'alternativas': [
        'Rio Amazonas',
        'Rio Nilo',
        'Rio Yangtzé',
        'Rio Mississippi'
      ],
      'resposta': 1
    },
    {
      'texto': 'Quem foi o primeiro presidente dos Estados Unidos?',
      'alternativas': [
        'Abraham Lincoln',
        'Thomas Jefferson',
        'George Washington',
        'John Adams'
      ],
      'resposta': 2
    },
    {
      'texto': 'Qual é o país mais populoso do mundo?',
      'alternativas': ['Índia', 'Estados Unidos', 'China', 'Indonésia'],
      'resposta': 2
    },
    {
      'texto': 'Qual é a fórmula química da água?',
      'alternativas': ['CO2', 'H2O', 'O2', 'NaCl'],
      'resposta': 1
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Carregar o progresso anterior salvo no SharedPreferences
  _loadProgress() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      numeroPergunta = prefs.getInt('numeroPergunta') ?? 0;
      resultado = List<Widget>.from(
        (prefs.getStringList('resultado') ?? []).map(
          (e) => e == 'correct'
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.close, color: Colors.red),
        ),
      );
    });
  }

  // Salvar o progresso atual no SharedPreferences
  _saveProgress() async {
    await prefs.setInt('numeroPergunta', numeroPergunta);
    await prefs.setStringList(
        'resultado',
        resultado
            .map((e) =>
                e is Icon && e.color == Colors.green ? 'correct' : 'incorrect')
            .toList());
  }

  // Função que verifica a resposta
  _verificarResposta(int alternativaEscolhida) {
    if (alternativaEscolhida == perguntas[numeroPergunta]['resposta']) {
      setState(() {
        resultado.add(const Icon(Icons.check, color: Colors.green));
      });
    } else {
      setState(() {
        resultado.add(const Icon(Icons.close, color: Colors.red));
      });
    }

    if (numeroPergunta < perguntas.length - 1) {
      numeroPergunta++;
      _saveProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Quiz de Conhecimentos Gerais')),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    perguntas[numeroPergunta]['texto'],
                    style:
                        const TextStyle(fontFamily: 'Quicksand', fontSize: 24),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: List.generate(
                    perguntas[numeroPergunta]['alternativas'].length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _verificarResposta(index);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60),
                          ),
                          child: Text(
                            perguntas[numeroPergunta]['alternativas'][index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: resultado,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
