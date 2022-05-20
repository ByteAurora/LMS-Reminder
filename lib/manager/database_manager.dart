import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager{
  static final DatabaseManager _instance = DatabaseManager._constructor();
  Database? _database;

  DatabaseManager._constructor();

  factory DatabaseManager() {
    return _instance;
  }

  void init() async {
    _database = await openDatabase(join(await getDatabasesPath(), 'lms_reminder.db'));
  }

}