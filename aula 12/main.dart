import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const TarefasApp());
}

class TarefasApp extends StatefulWidget {
  const TarefasApp({super.key});

  @override
  State<TarefasApp> createState() => _TarefasAppState();
}

class _TarefasAppState extends State<TarefasApp> {
  late Database database;
  List<Map<String, dynamic>> tarefas = [];
  String filtroData = '';

  @override
  void initState() {
    super.initState();
    iniciaDB();
  }

  Future<void> iniciaDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = await openDatabase(
      join(await getDatabasesPath(), 'tarefas.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            data TEXT,
            feita INTEGER
          )
        ''');
      },
      version: 1,
    );

    // Carrega tarefas existentes
    await carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final db = database;
    List<Map<String, dynamic>> lista;
    if (filtroData.isEmpty) {
      lista = await db.query('tarefas', orderBy: 'data DESC');
    } else {
      lista = await db.query(
        'tarefas',
        where: 'data = ?',
        whereArgs: [filtroData],
        orderBy: 'data DESC',
      );
    }

    if (!mounted) return;
    setState(() {
      tarefas = lista;
    });
  }

  Future<void> inserirTarefa(
      String titulo, String descricao, String data) async {
    if (titulo.isEmpty || descricao.isEmpty || data.isEmpty) return;
    await database.insert(
      'tarefas',
      {'titulo': titulo, 'descricao': descricao, 'data': data, 'feita': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await carregarTarefas(); // Atualiza lista após inserir
  }

  Future<void> marcarComoFeita(int id, int feita) async {
    await database.update(
      'tarefas',
      {'feita': feita == 1 ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    await carregarTarefas();
  }

  Future<void> atualizarTarefa(
      int id, String titulo, String descricao, String data) async {
    await database.update(
      'tarefas',
      {'titulo': titulo, 'descricao': descricao, 'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
    await carregarTarefas();
  }

  void mostrarDialogoNovaTarefa(BuildContext ctx,
      {Map<String, dynamic>? tarefa}) {
    final tituloController =
        TextEditingController(text: tarefa != null ? tarefa['titulo'] : '');
    final descricaoController =
        TextEditingController(text: tarefa != null ? tarefa['descricao'] : '');
    final dataController =
        TextEditingController(text: tarefa != null ? tarefa['data'] : '');

    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: dataController,
                decoration:
                    const InputDecoration(labelText: 'Data (ex: 2025-11-04)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text.trim();
                final descricao = descricaoController.text.trim();
                final data = dataController.text.trim();

                if (titulo.isEmpty || descricao.isEmpty || data.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos!')),
                  );
                  return;
                }

                if (tarefa == null) {
                  await inserirTarefa(titulo, descricao, data);
                } else {
                  await atualizarTarefa(tarefa['id'], titulo, descricao, data);
                }

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogoFiltroData(BuildContext ctx) {
    final filtroController = TextEditingController(text: filtroData);
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar por data'),
          content: TextField(
            controller: filtroController,
            decoration:
                const InputDecoration(labelText: 'Data (ex: 2025-11-04)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  filtroData = filtroController.text.trim();
                });
                Navigator.pop(context);
                carregarTarefas();
              },
              child: const Text('Aplicar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  filtroData = '';
                });
                Navigator.pop(context);
                carregarTarefas();
              },
              child: const Text('Limpar Filtro'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Tarefas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => mostrarDialogoFiltroData(context),
            ),
          ],
        ),
        body: tarefas.isEmpty
            ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
            : ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final t = tarefas[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        t['titulo'],
                        style: TextStyle(
                          decoration: t['feita'] == 1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: t['feita'] == 1 ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text('Data: ${t['data']}\n${t['descricao']}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(
                          t['feita'] == 1
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: t['feita'] == 1 ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => marcarComoFeita(t['id'], t['feita']),
                      ),
                      onLongPress: () =>
                          mostrarDialogoNovaTarefa(context, tarefa: t),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => mostrarDialogoNovaTarefa(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
