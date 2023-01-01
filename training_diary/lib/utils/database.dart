

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_diary/model/exercice.dart';
import 'package:training_diary/model/lastSeance.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/model/routineHasExercice.dart';
import 'package:training_diary/model/seance.dart';
import 'package:training_diary/model/serie.dart';

class TrainingDiaryDatabase {
  TrainingDiaryDatabase._();

  static final TrainingDiaryDatabase instance = TrainingDiaryDatabase._();
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await initDB();

  /*Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }*/

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'training_diary_database.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE exercice(id INTEGER PRIMARY KEY, nom TEXT, description TEXT); ");
        db.execute("CREATE TABLE routine(id INTEGER PRIMARY KEY, nom TEXT, description TEXT); ");
        db.execute("CREATE TABLE routine_has_exercices(id INTEGER PRIMARY KEY, exercice_id INTEGER, routine_id INTEGER);");
        db.execute("CREATE TABLE seance(id INTEGER PRIMARY KEY, routine_id INTEGER, date DATE);");
        db.execute("CREATE TABLE last_seance(exercice_id INTEGER PRIMARY KEY, commentaire TEXT);");
      },
      version: 1,
    );
  }

  /********************************************EXERCICE****************************************************** */
  void insertExercice(Exercice exercice) async {
    final Database db = await database;

    await db.insert('exercice', exercice.toMap(), conflictAlgorithm: ConflictAlgorithm.replace) ;
  }

  void updateExercice(Exercice exercice) async {
    final Database db = await database;
    await db.update('exercice', exercice.toMap(), where: "id = ?", whereArgs: [exercice.id]);
  }

  void deleteExercice(int? id) async {
    final Database db = await database;
    db.delete("exercice", where: "id = ?", whereArgs: [id]);
    db.delete("routine_has_exercices", where: "exercice_id = ?", whereArgs: [id]);
  }

  Future<Exercice> getExercice(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("exercice", where: "id = ?", whereArgs: [id]);
    List<Exercice> exercices = List.generate(maps.length, (i) {
      return Exercice.fromMap(maps[i]);
    });

    return exercices[0];
  }

  Future<List<Exercice>> getAllExercices() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("exercice");
    List<Exercice> exercices = List.generate(maps.length, (i) {
      return Exercice.fromMap(maps[i]);
    });

    return exercices;
  }

  /********************************************ROUTINE****************************************************** */
  Future<int> insertRoutine(Routine routine) async {
    final Database db = await database;

    return await db.insert('routine', routine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace) ;
  }

  void updateRoutine(Routine routine) async {
    final Database db = await database;
    await db.update('routine', routine.toMap(), where: "id = ?", whereArgs: [routine.id]);
  }

  void deleteRoutine(int? id) async {
    final Database db = await database;
    db.delete("routine", where: "id = ?", whereArgs: [id]);
    db.delete("routine_has_exercices", where: "routine_id = ?", whereArgs: [id]);
  }

  Future<Routine> getRoutine(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("routine", where: "id = ?", whereArgs: [id]);
    List<Routine> routines = List.generate(maps.length, (i) {
      return Routine.fromMap(maps[i]);
    });

    return routines[0];
  }

  Future<List<Routine>> getAllRoutines() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("routine");
    List<Routine> routines = List.generate(maps.length, (i) {
      return Routine.fromMap(maps[i]);
    });

    return routines;
  }

  /********************************************ROUTINE_HAS_EXERCICE****************************************************** */
  void insertRoutineHasExercice(RoutineHasExercice routineHasExercice) async {
    final Database db = await database;

    await db.insert('routine_has_exercices', routineHasExercice.toMap(), conflictAlgorithm: ConflictAlgorithm.replace) ;
  }

  void updateRoutineHasExercice(RoutineHasExercice routineHasExercice) async {
    final Database db = await database;
    await db.update('routine_has_exercices', routineHasExercice.toMap(), where: "id = ?", whereArgs: [routineHasExercice.id]);
  }

  void deleteRoutineHasExercice(int exerciceId, int routineId) async {
    final Database db = await database;
    db.delete("routine_has_exercices", where: "exercice_id = ? AND routine_id = ?", whereArgs: [exerciceId, routineId]);
  }

  Future<RoutineHasExercice> getRoutineHasExercice(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("routine_has_exercices", where: "id = ?", whereArgs: [id]);
    List<RoutineHasExercice> routinesHasExercice = List.generate(maps.length, (i) {
      return RoutineHasExercice.fromMap(maps[i]);
    });

    return routinesHasExercice[0];
  }
  Future<List<RoutineHasExercice>> getAllRoutinesHasExercice() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("routine_has_exercices");
    List<RoutineHasExercice> routinesHasExercice = List.generate(maps.length, (i) {
      return RoutineHasExercice.fromMap(maps[i]);
    });

    return routinesHasExercice;
  }

  Future<List<Exercice>> getAllExercicesFromRoutine(Routine routine) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("routine_has_exercices", where: "routine_id = ?", whereArgs: [routine.id]);
    List<RoutineHasExercice> routinesHasExercice = List.generate(maps.length, (i) {
      return RoutineHasExercice.fromMap(maps[i]);
    });

    List<Exercice> exercices = [];
    routinesHasExercice.forEach((element) async {
      exercices.add(await TrainingDiaryDatabase.instance.getExercice(element.exerciceId));
    });
    return exercices;
  }

  /********************************************SEANCE****************************************************** */
  Future<int> insertSeance(Seance seance) async {
    final Database db = await database;

    return await db.insert('seance', seance.toMap(), conflictAlgorithm: ConflictAlgorithm.replace) ;
  }

  void updateSeance(Seance seance) async {
    final Database db = await database;
    await db.update('seance', seance.toMap(), where: "id = ?", whereArgs: [seance.id]);
  }

  void deleteSeance(int id) async {
    final Database db = await database;
    db.delete("seance", where: "id = ?", whereArgs: [id]);
  }

  Future<Seance> getSeance(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("seance", where: "id = ?", whereArgs: [id]);
    List<Seance> seances = List.generate(maps.length, (i) {
      return Seance.fromMap(maps[i]);
    });

    return seances[0];
  }

  Future<List<Seance>> getAllSeances() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("seance");
    List<Seance> seances = List.generate(maps.length, (i) {
      return Seance.fromMap(maps[i]);
    });

    return seances;
  }

  /********************************************LAST_SEANCE****************************************************** */
  Future<int> insertLastSeance(int? exerciceId, String commentaire) async {
    final Database db = await database;

    return await db.insert('last_seance', {'exercice_id' : exerciceId, 'commentaire' : commentaire}, conflictAlgorithm: ConflictAlgorithm.replace) ;
  }

  void deleteLastSeance(int id) async {
    final Database db = await database;
    db.delete("last_seance", where: "exercice_id = ?", whereArgs: [id]);
  }

  Future<List<LastSeance>> getLastSeance(int? id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("last_seance", where: "exercice_id = ?", whereArgs: [id]);
    List<LastSeance> lastSeance = List.generate(maps.length, (i) {
      return LastSeance.fromMap(maps[i]);
    });

    return lastSeance;
  }
}