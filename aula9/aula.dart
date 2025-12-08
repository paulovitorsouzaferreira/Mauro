import 'package:flutter/material.dart';

void main() {
  runApp(const PetIdadeApp());
}

enum Animal { gato, cachorro }

class PetIdadeApp extends StatefulWidget {
  const PetIdadeApp({super.key});

  @override
  State<PetIdadeApp> createState() => _PetIdadeAppState();
}

class _PetIdadeAppState extends State<PetIdadeApp> {
  Animal selecionado = Animal.gato;
  double peso = 5.0;
  int idade = 1;
  double idadeFisiologica = 0;

  void calcular() {
    double result = 0;

    if (selecionado == Animal.gato) {
      if (idade == 1) result = 15;
      else if (idade == 2) result = 15 + 9;
      else result = 15 + 9 + (idade - 2) * 4;
    } else {
      // cachorro
      double p = peso;
      if (p <= 10) {
        if (idade == 1) result = 12;
        else if (idade == 2) result = 12 + 7;
        else result = 12 + 7 + (idade - 2) * 4;
      } else if (p <= 25) {
        if (idade == 1) result = 15;
        else if (idade == 2) result = 15 + 9;
        else result = 15 + 9 + (idade - 2) * 5;
      } else {
        if (idade == 1) result = 20;
        else if (idade == 2) result = 20 + 11;
        else result = 20 + 11 + (idade - 2) * 6;
      }
    }

    setState(() {
      idadeFisiologica = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("Idade Fisiológica do Pet")),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selecionado = Animal.gato);
                      },
                      child: Caixa(
                        cor: selecionado == Animal.gato
                            ? Colors.deepPurple
                            : const Color(0xFF1E164B),
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 70),
                            SizedBox(height: 10),
                            Text("GATO")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selecionado = Animal.cachorro);
                      },
                      child: Caixa(
                        cor: selecionado == Animal.cachorro
                            ? Colors.deepPurple
                            : const Color(0xFF1E164B),
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets_outlined, size: 70),
                            SizedBox(height: 10),
                            Text("CACHORRO")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PESO
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Peso (kg)", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text("${peso.toStringAsFixed(0)} kg",
                        style: const TextStyle(fontSize: 22)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbColor: Colors.red,
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 18),
                      ),
                      child: Slider(
                        min: 1,
                        max: 60,
                        value: peso,
                        onChanged: (v) => setState(() => peso = v),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // IDADE
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Idade do Pet (anos)",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text("$idade anos",
                        style: const TextStyle(fontSize: 22)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () {
                            if (idade < 30) setState(() => idade++);
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () {
                            if (idade > 1) setState(() => idade--);
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // RESULTADO
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Idade Fisiológica",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(
                      "${idadeFisiologica.toStringAsFixed(1)} anos humanos",
                      style: const TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),

            // BOTÃO CALCULAR
            GestureDetector(
              onTap: calcular,
              child: Container(
                height: 80,
                width: double.infinity,
                color: Colors.deepPurpleAccent,
                child: const Center(
                  child: Text(
                    "CALCULAR",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget filho;

  const Caixa({super.key, required this.cor, required this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cor,
      ),
      child: filho,
    );
  }
}
