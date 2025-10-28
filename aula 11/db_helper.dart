import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String _dbName = 'calculadora.db';
  static const String _tableDados = 'dados';
  static const String _tableOperacoes = 'operacoes';

  static const String createTableDados = '''
    CREATE TABLE $_tableDados(
      id INTEGER PRIMARY KEY,
      numero_atual REAL,
      memoria REAL
    );
  ''';

  static const String createTableOperacoes = '''
    CREATE TABLE $_tableOperacoes(
      id INTEGER PRIMARY KEY,
      operacao TEXT,
      resultado REAL,
      timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  ''';

  Future<Database> _initializeDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _dbName);
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(createTableDados);
      db.execute(createTableOperacoes);
    });
  }

  // Função para inserir os dados de cálculo
  Future<void> saveDados(double numeroAtual, double memoria) async {
    final db = await _initializeDB();
    await db.insert(
      _tableDados,
      {'numero_atual': numeroAtual, 'memoria': memoria},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Função para salvar operações realizadas
  Future<void> saveOperacao(String operacao, double resultado) async {
    final db = await _initializeDB();
    await db.insert(
      _tableOperacoes,
      {'operacao': operacao, 'resultado': resultado},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Função para obter operações realizadas
  Future<List<Map<String, dynamic>>> getOperacoes() async {
    final db = await _initializeDB();
    return db.query(_tableOperacoes);
  }
}
