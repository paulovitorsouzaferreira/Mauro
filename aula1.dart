import 'dart:math';

void main() {
  double raio = 5.75;
  double area = pi * raio * raio;
  print(area);
}

void main() {
  int informado = 6;
  int atual = DateTime.now().month;

  if (atual > informado) {
    print('$atual é maior que $informado');
  } else if (atual < informado) {
    print('$atual é menor que $informado');
  } else {
    print('$atual é igual a $informado');
  }
}

void main() {
  DateTime hoje = DateTime.now();
  int ano = hoje.year;
  int mes = hoje.month;
  int ultimoDia = hoje.day;

  print('| D | S | T | Q | Q | S | S |');

  int primeiroWeekday = DateTime(ano, mes, 1).weekday % 7;
  for (int i = 0; i < primeiroWeekday; i++) {
    stdout.write('|   ');
  }

  for (int dia = 1; dia <= ultimoDia; dia++) {
    String d = dia < 10 ? ' $dia' : '$dia';
    stdout.write('| $d ');
    if ((dia + primeiroWeekday) % 7 == 0) print('|');
  }
}
