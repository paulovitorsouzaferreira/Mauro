class DicionarioApp extends StatefulWidget {
  const DicionarioApp({super.key});

  @override
  State<DicionarioApp> createState() => _DicionarioAppState();
}

class _DicionarioAppState extends State<DicionarioApp> {
  TextEditingController palavraCtrl = TextEditingController();
  String definicao = "";
  bool carregando = false;

  Future<void> buscarDefinicao() async {
    setState(() => carregando = true);

    final resp = await http.get(Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/${palavraCtrl.text}"));

    final dados = jsonDecode(resp.body);

    setState(() {
      definicao = dados[0]["meanings"][0]["definitions"][0]["definition"];
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dicionário Inglês")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: palavraCtrl,
              decoration: InputDecoration(
                hintText: "Digite uma palavra em inglês",
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
                onPressed: buscarDefinicao,
                child: Text("Buscar definição")
            ),
            SizedBox(height: 20),
            if (carregando) CircularProgressIndicator(),
            if (!carregando && definicao.isNotEmpty)
              Text("Definição: $definicao")
          ],
        ),
      ),
    );
  }
}
