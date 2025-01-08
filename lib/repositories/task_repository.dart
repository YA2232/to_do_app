import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/models/task.dart';

class TaskRepository {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDataBase();
      return _db;
    } else {
      return _db;
    }
  }

  initDataBase() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "tasks.db");
    Database database =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE 'tasks' ("id" INTEGER PRIMARY KEY, "title" TEXT, "isDone" BOOL)
      ''');
}

  Future<List<Task>> getAllTasks() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> maps = await mydb!.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  Future<int> insertData(Task task) async {
    Database? mydb = await db;
    int response = await mydb!.insert('tasks', task.toJson());
    return response;
  }

  Future<int> updateTask(Task task) async {
    Database? mydb = await db;

    int response = await mydb!.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    return response;
  }

  Future<int> deleteTaskById(int id) async {
    Database? mydb = await db;

    int response = await mydb!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }
}
