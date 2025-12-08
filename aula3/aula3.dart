import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RolinhaPage(),
  ));
}

class RolinhaPage extends StatelessWidget {
  const RolinhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rolinha-do-planalto'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Rolinha-do-planalto'),
            Container(
              width: 250,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              color: Colors.lightBlue,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/3/3e/Columbina%28Turtur%29_talpacoti-1_cropped.jpg',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OutraAvePage()),
                );
              },
              child: Text('Ir para outra ave'),
            )
          ],
        ),
      ),
    );
  }
}

class OutraAvePage extends StatelessWidget {
  const OutraAvePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outra Ave'),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Outra Ave Exemplo'),
            Container(
              width: 250,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              color: Colors.lightBlue,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/6/6e/Barn_Owl_in_flight_-_5.jpg',
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Voltar'),
            )
          ],
        ),
      ),
    );
  }
}
