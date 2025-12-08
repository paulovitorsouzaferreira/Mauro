import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Lista global de palavras compreendidas
ValueNotifier<List<String>> compreendidas = ValueNotifier([]);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ctrl = TextEditingController();
  String paragrafo = "";
  bool carregando = false;

  Future<void> carregarWikipedia() async {
    setState(() => carregando = true);

    final url = ctrl.text.trim();

    try {
      final resposta = await http.get(Uri.parse(url));
      final document = parser.parse(resposta.body);

      final p = document.querySelector('p');

      if (p != null) {
        paragrafo = p.text;
      } else {
        paragrafo = "Nenhum parágrafo encontrado.";
      }
    } catch (e) {
      paragrafo = "Erro ao carregar página.";
    }

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> palavras = paragrafo.split(" ");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wikipedia English Trainer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PalavrasCompreendidas()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                labelText: "Cole o link da Wikipedia (EN)",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: carregarWikipedia,
              child: const Text("Carregar texto"),
            ),
            const SizedBox(height: 20),

            carregando
                ? const CircularProgressIndicator()
                : Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: palavras.map((w) {
                        if (compreendidas.value.contains(w.toLowerCase())) {
                          return Chip(label: Text(w));
                        }
                        return ActionChip(
                          label: Text(w),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DefinicaoPage(palavra: w),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

/// Página de definição
class DefinicaoPage extends StatefulWidget {
  final String palavra;
  const DefinicaoPage({required this.palavra});

  @override
  State<DefinicaoPage> createState() => _DefinicaoPageState();
}

class _DefinicaoPageState extends State<DefinicaoPage> {
  String definicao = "";
  String audioUrl = "";
  bool carregando = true;

  Future<void> buscarDefinicao() async {
    final url =
        "https://api.dictionaryapi.dev/api/v2/entries/en/${widget.palavra}";
    try {
      final r = await http.get(Uri.parse(url));
      final data = parser.parse(r.body);

      final json = r.body;

      final decoded = jsonDecode(r.body);

      definicao = decoded[0]["meanings"][0]["definitions"][0]["definition"];

      final audio = decoded[0]["phonetics"]
          .firstWhere(
              (p) => p["audio"] != null && (p["audio"] as String).isNotEmpty,
              orElse: () => {"audio": ""});

      audioUrl = audio["audio"];
    } catch (e) {
      definicao = "Não encontrado.";
    }

    setState(() => carregando = false);
  }

  @override
  void initState() {
    super.initState();
    buscarDefinicao();
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return Scaffold(
      appBar: AppBar(title: Text(widget.palavra)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Definição:", style: TextStyle(fontSize: 18)),
                  Text(definicao),
                  const SizedBox(height: 20),

                  if (audioUrl.isNotEmpty)
                    ElevatedButton(
                      onPressed: () => player.play(UrlSource(audioUrl)),
                      child: const Text("Ouvir pronúncia"),
                    ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      compreendidas.value
                          .add(widget.palavra.toLowerCase());
                      compreendidas.notifyListeners();
                      Navigator.pop(context);
                    },
                    child: const Text("Marcar como compreendida"),
                  )
                ],
              ),
      ),
    );
  }
}

/// Página das palavras compreendidas
class PalavrasCompreendidas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Palavras compreendidas")),
      body: ValueListenableBuilder(
        valueListenable: compreendidas,
        builder: (context, lista, _) {
          return ListView(
            children: lista.map((p) {
              return ListTile(
                title: Text(p),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    lista.remove(p);
                    compreendidas.notifyListeners();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
