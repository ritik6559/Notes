import 'dart:async';

import 'package:mynotes/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Steps involvedP:-
// 1. Setup Sqflite
// 2. Open DataBase
// 3. Create Table
// 4. Perform CRUD

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    //if database exists return databse
    if (_database != null) return _database!;

    //else initialize or create a database.
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    //opening database.
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  //creating database.
  Future _createDb(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NON NULL';
    final integerType = 'INTEGER NON NULL';
    final textType = 'TEXT NON NULL';

    await db.execute('''
CREATE TABLE $tableNotes(
  //inside we need to define all of our columns.
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType,
)
''');
  }

  //CRUD operations.
  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes, //table name
      columns: NoteFields.values, //content we need to retrieve from db.
      where: '${NoteFields.id} = ?', //or'${NotesFields.id} = $id'
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';

    final result = await db.query(tableNotes,
        orderBy:
            orderBy); // this will provide List<Map> so will convert it to list.

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  //closing datanase.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
