import 'package:gymbro/features/calendar/models/training_model.dart';
import 'package:gymbro/features/calendar/models/dot_on_map_model.dart';
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
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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

    await db.execute('''
    CREATE TABLE $tableDots (
      id TEXT PRIMARY KEY,
      longitude TEXT,
      latitude TEXT,
      isFavourite BOOLEAN
    )
  ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE $tableDots (
        id TEXT PRIMARY KEY,
        longitude TEXT,
        latitude TEXT,
        isFavourite BOOLEAN
      )
    ''');
    }
  }

  Future<void> create(Training training) async {
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

  Future<void> createDot(DotOnMapModel dot) async {
    final db = await instance.database;
    await db.insert(
      tableDots,
      dot.toJson(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Заменяет существующую запись
    );
  }

  Future<List<DotOnMapModel>> getAllDots() async {
    final db = await instance.database;
    final maps = await db.query(
      tableDots,
      columns: DotFields.values,
    );
    return maps.map((json) => DotOnMapModel.fromJson(json)).toList();
  }

  Future<int> updateDotFavourite(String id, bool isFavourite) async {
    final db = await instance.database;
    return await db.update(
      tableDots,
      {DotFields.isFavourite: isFavourite ? 1 : 0},
      where: '${DotFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<DotOnMapModel>> getFavouriteDots() async {
    final db = await instance.database;
    final maps = await db.query(
      tableDots,
      columns: DotFields.values,
      where: '${DotFields.isFavourite} = ?',
      whereArgs: [1],
    );
    return maps.map((json) => DotOnMapModel.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
