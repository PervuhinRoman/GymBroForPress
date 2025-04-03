import 'package:gymbro/features/calendar/models/training_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trainings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTrainings (
        description TEXT,
        date TEXT,
        time TEXT,
        tag TEXT
      )
    ''');
  }

  Future<void> create(Training training) async {
    print("inserted");
    print(training.date);
    print(training.time);
    final db = await instance.database;
    await db.insert(tableTrainings, training.toJson());
  }

  Future<List<Training>> getTrainingsByDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTrainings,
      columns: TrainingFields.values,
      where: '${TrainingFields.date} = ?',
      whereArgs: [date],
    );
    return maps.map((json) => Training.fromJson(json)).toList();
  }

  Future<List<Training>> getAllTrainings() async {
    final db = await instance.database;
    final maps = await db.query(
      tableTrainings,
      columns: TrainingFields.values,
    );
    return maps.map((json) => Training.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
