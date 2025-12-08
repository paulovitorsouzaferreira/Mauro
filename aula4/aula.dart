import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

Card criaLinha(
  String coluna1,
  String coluna2,
  IconData? icone,
  double tamanho,
  Color? cor,
  int fundoR,
  int fundoG,
  int fundoB,
) {
  // Linha simples (dragão)
  if (icone == null && cor == null && tamanho == 0) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(coluna1, style: GoogleFonts.rampartOne(fontSize: 18)),
            Text(coluna2, style: GoogleFonts.quicksand(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Linha com ícone + botão
  return Card(
    color: Color.fromARGB(0xFF, fundoR, fundoG, fundoB),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4),
          child: ListTile(
            leading: Icon(icone, size: tamanho, color: cor),
            title: Text(coluna1, style: GoogleFonts.rampartOne(fontSize: 16)),
            subtitle: Text(coluna2, style: GoogleFonts.quicksand(fontSize: 14)),
          ),
        ),
        TextButton(
          child: const Text('Usar poder'),
          onPressed: () {},
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),

              /// FOTO DO DRAGÃO
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/howtotrainyourdragon/images/0/08/Grump_Render.png',
                ),
              ),

              /// Divider
              SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: Colors.orange.shade700,
                  thickness: 2,
                ),
              ),

              /// LINHA DRAGÃO
              criaLinha('Dragão:', 'Grump', null, 0, null, 0, 0, 0),

              /// Divider
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.blue.shade700,
                  thickness: 2,
                ),
              ),

              /// ATAQUE
              criaLinha(
                'Ataque:',
                '25',
                Icons.offline_bolt,
                40,
                Colors.blue,
                0x70,
                0xAD,
                0x6B,
              ),

              /// Divider
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.green.shade700,
                  thickness: 2,
                ),
              ),

              /// VELOCIDADE
              criaLinha(
                'Velocidade:',
                '20',
                Icons.speed,
                40,
                Colors.green,
                0x71,
                0x5E,
                0xFF,
              ),

              /// Divider
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.red.shade700,
                  thickness: 2,
                ),
              ),

              /// FOGO
              criaLinha(
                'Fogo:',
                '50',
                Icons.fireplace,
                40,
                Colors.red,
                0xFF,
                0x9F,
                0x5E,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
