import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaAluno(),
    );
  }
}

// ---------------------------
// TELA 1 – CADASTRAR ALUNO
// ---------------------------

class TelaAluno extends StatefulWidget {
  const TelaAluno({super.key});

  @override
  State<TelaAluno> createState() => _TelaAlunoState();
}

class _TelaAlunoState extends State<TelaAluno> {
  final TextEditingController nome = TextEditingController();
  final TextEditingController matricula = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aluno")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nome,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: matricula,
              decoration: const InputDecoration(labelText: "Matrícula"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TelaNotas(
                      nome: nome.text,
                      matricula: matricula.text,
                    ),
                  ),
                );
              },
              child: const Text("Próximo"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// TELA 2 – LANÇAR NOTAS
// ---------------------------

class TelaNotas extends StatefulWidget {
  final String nome;
  final String matricula;

  const TelaNotas({super.key, required this.nome, required this.matricula});

  @override
  State<TelaNotas> createState() => _TelaNotasState();
}

class _TelaNotasState extends State<TelaNotas> {
  final TextEditingController notaController = TextEditingController();
  final List<double> notas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lançar notas")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: notaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Digite a nota",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (notaController.text.isNotEmpty) {
                  setState(() {
                    notas.add(double.parse(notaController.text));
                    notaController.clear();
                  });
                }
              },
              child: const Text("Adicionar nota"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TelaResultado(
                      nome: widget.nome,
                      matricula: widget.matricula,
                      notas: notas,
                    ),
                  ),
                );
              },
              child: const Text("Ver resultado"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// TELA 3 – EXIBIR RESULTADO
// ---------------------------

class TelaResultado extends StatelessWidget {
  final String nome;
  final String matricula;
  final List<double> notas;

  const TelaResultado(
      {super.key,
      required this.nome,
      required this.matricula,
      required this.notas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resumo do Aluno")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome: $nome", style: const TextStyle(fontSize: 18)),
            Text("Matrícula: $matricula", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Notas:", style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Nota ${index + 1}: ${notas[index]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
