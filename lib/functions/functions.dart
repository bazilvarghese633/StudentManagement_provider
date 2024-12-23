import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:student_provider_try1/Model/model.dart';

class DatabaseHelper {
  static const databaseName = 'student.db';
  static const databaseVersion = 1;
  static const table = 'students';
  static const columId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';
  static const columnPlace = 'place';
  static const columnCourse = 'course';
  static const columnImage = 'image';
  static const columnPhone = 'phone';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: onCreate,
    );
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table(
$columId INTEGER PRIMARY KEY AUTOINCREMENT,
$columnName TEXT NOT NULL,
$columnAge INTEGER NOT NULL,
$columnPlace TEXT NOT NULL,
$columnCourse TEXT NOT NULL,
$columnImage TEXT NOT NULL,
$columnPhone TEXT NOT NULL


)


''');
  }

  Future<int> insertStudent(StudentModel student) async {
    final db = await database;
    return await db.insert(table, student.toMap());
  }

  Future<List<StudentModel>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(
        maps.length,
        (index) => StudentModel(
              id: maps[index][columId],
              name: maps[index][columnName],
              age: maps[index][columnAge],
              place: maps[index][columnPlace],
              course: maps[index][columnCourse],
              image: maps[index][columnImage],
              phone: maps[index][columnPhone],
            ));
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columId=?',
      whereArgs: [id],
    );
  }

  Future<int> updateStudent(StudentModel student) async {
    final db = await database;
    return db.update(
      table,
      student.toMap(),
      where: '$columId=?',
      whereArgs: [student.id],
    );
  }
}
