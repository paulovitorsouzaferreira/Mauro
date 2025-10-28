import 'package:flutter/material.dart';
import 'db_helper.dart';

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  double numeroAtual = 0.0;
  double memoria = 0.0;
  String operacaoAtual = '';
  DBHelper dbHelper = DBHelper();

  void _executarOperacao(String operacao) {
    setState(() {
      if (operacao == '=') {
        double resultado;
        switch (operacaoAtual) {
          case '+':
            resultado = numeroAtual + memoria;
            break;
          case '-':
            resultado = numeroAtual - memoria;
            break;
          case '*':
            resultado = numeroAtual * memoria;
            break;
          case '/':
            if (memoria != 0) {
              resultado = numeroAtual / memoria;
            } else {
              resultado = 0.0; // Evitar divisão por 0
            }
            break;
          default:
            return;
        }

        // Salvar operação no banco
        dbHelper.saveOperacao(operacaoAtual, resultado);
        dbHelper.saveDados(resultado, memoria);

        // Atualizar valores após a operação
        numeroAtual = resultado;
        memoria = 0.0; // Limpar memória após operação
        operacaoAtual = ''; // Limpar operação
      } else if (operacao == 'MC') {
        memoria = 0.0;
      } else if (operacao == 'MR') {
        numeroAtual = memoria;
      } else if (operacao == 'M+') {
        memoria += numeroAtual;
      } else if (operacao == 'M-') {
        memoria -= numeroAtual;
      } else {
        operacaoAtual = operacao;
      }
    });
  }

  void _atualizarNumero(double numero) {
    setState(() {
      numeroAtual = numeroAtual * 10 + numero; // Para concatenar os números
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora')),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Ajuste no padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display do número atual
            Text(
              '$numeroAtual',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display da operação em andamento
            Text(
              operacaoAtual,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            // Teclado numérico
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                if (index < 9) {
                  return ElevatedButton(
                    onPressed: () => _atualizarNumero(index.toDouble()),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('$index'),
                  );
                }

                // Botões de operações
                final operacoes = [
                  '+',
                  '-',
                  '*',
                  '/',
                  'MC',
                  'MR',
                  'M+',
                  'M-',
                  '='
                ];

                return ElevatedButton(
                  onPressed: () => _executarOperacao(operacoes[index - 9]),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text(operacoes[index - 9]),
                );
              },
            ),
            SizedBox(height: 20),
            // Exibir as operações realizadas
            ElevatedButton(
              onPressed: () async {
                var operacoes = await dbHelper.getOperacoes();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Operações Realizadas'),
                    content: ListView.builder(
                      itemCount: operacoes.length,
                      itemBuilder: (context, index) {
                        var operacao = operacoes[index];
                        return ListTile(
                          title: Text(operacao['operacao']),
                          subtitle: Text('Resultado: ${operacao['resultado']}'),
                        );
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Ver Operações'),
            ),
          ],
        ),
      ),
    );
  }
}
