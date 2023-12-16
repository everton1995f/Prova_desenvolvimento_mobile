import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  //CRIANDO UM CONSTRUTOR
  DB._();
  //CRIANDO UMA INSTANCIA DO DB
  static final DB instance = DB._();
  //INSTANCIA DO SQLite
  static Database? _database;
  
  // Metodo assincrono que verifica se o _database é diferente de null
  get database async {
    if(_database != null) return _database;

    return await _initDatabase();
  }
  // Metodo assincrono para iniciar o banco de dados
  _initDatabase() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'prova.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_usuarios);
    await db.execute(_tarefas);
  }

  String get _usuarios => '''
    CREATE TABLE usuarios (
      id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(35) NOT NULL,
      email_usuario VARCHAR(75) NOT NULL,
      senha_usuario VARCHAR(40) NOT NULL
    )
''';

  String get _tarefas => '''
    CREATE TABLE tarefas (
      id_tarefa INTEGER PRIMARY KEY AUTOINCREMENT,
      nome_tarefa VARCHAR(40) NOT NULL,
      descricao_tarefa VARCHAR(200) NOT NULL,
      status_tarefa VARCHAR(20) NOT NULL
    )
''';
}