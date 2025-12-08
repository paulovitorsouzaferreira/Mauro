class JogoCartas extends StatefulWidget {
  const JogoCartas({super.key});

  @override
  State<JogoCartas> createState() => _JogoCartasState();
}

class _JogoCartasState extends State<JogoCartas> {
  String cartaJogador = "";
  String cartaOponente = "";
  int pontosJogador = 0;
  int pontosOponente = 0;

  final valores = {
    "ACE": 14,
    "KING": 13,
    "QUEEN": 12,
    "JACK": 11,
    "10": 10,
    "9": 9,
    "8": 8,
    "7": 7,
    "6": 6,
    "5": 5,
    "4": 4,
    "3": 3,
    "2": 2,
  };

  Future<void> jogar() async {
    final resp = await http.get(
        Uri.parse("https://deckofcardsapi.com/api/deck/new/draw/?count=2"));

    final dados = jsonDecode(resp.body);
    final c1 = dados['cards'][0];
    final c2 = dados['cards'][1];

    final valor1 = valores[c1['value']]!;
    final valor2 = valores[c2['value']]!;

    setState(() {
      cartaJogador = c1['image'];
      cartaOponente = c2['image'];

      if (valor1 > valor2)
        pontosJogador++;
      else if (valor2 > valor1)
        pontosOponente++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jogo de Cartas")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Jogador: $pontosJogador   |   Oponente: $pontosOponente",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cartaJogador.isNotEmpty
                  ? Image.network(cartaJogador, width: 120)
                  : Container(width: 120, height: 170, color: Colors.grey),
              cartaOponente.isNotEmpty
                  ? Image.network(cartaOponente, width: 120)
                  : Container(width: 120, height: 170, color: Colors.grey),
            ],
          ),
          SizedBox(height: 20),
          TextButton(onPressed: jogar, child: Text("Jogar rodada"))
        ],
      ),
    );
  }
}
