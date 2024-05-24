import 'package:bmi_record/controller/bmi_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteController{
  static const String _dbName = "bitp3453_bmi";

  Database? _db;

  SQLiteController._();
  static final SQLiteController _instance = SQLiteController._();

  factory SQLiteController(){
    return _instance;
  }

  Future<Database> get database async{
    if(_db != null){
      return _db!;
    }

    String path = join(await getDatabasesPath(), '$_dbName.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async{
      await db.execute('''
        CREATE TABLE IF NOT EXISTS bmi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          weight DOUBLE,
          height DOUBLE,
          gender TEXT,
          bmi DOUBLE,
          status TEXT
        )
      ''');
    });
    return _db!;
  }

  Future<int> insertBMIRecord (BmiController bmiController) async{
    final Database db = await database;
    final Map<String, dynamic> row = {
      'name': bmiController.nameController.text,
      'weight': double.parse(bmiController.weightController.text),
      'height': double.parse(bmiController.heightController.text),
      'gender': bmiController.gender,
      'bmi': double.parse(bmiController.bmiResult),
      'status': bmiController.bmiStatus,
    };
    return await db.insert('bmi', row);
  }

  Future<Map<String, dynamic>?> getPreviousData() async{
    final Database db = await database;
    List<Map<String,dynamic>> rows =
    await db.query('bmi', orderBy: 'id DESC', limit: 1);
    if(rows.isNotEmpty){
      return rows[0];
    }
    return null;
  }

  Future<double> calculateAverageBMI(String gender) async{
    final db = await database;
    var result = await db.rawQuery(
      'SELECT AVG(bmi) as average FROM bmi WHERE gender = ?', [gender],
    );
    if(result.isNotEmpty && result[0]['average'] != null){
      return double.tryParse(result[0]['average'].toString()) ?? 0.0;
    }
    return 0.0;
  }

  Future<int> GenderCount (String gender) async{
    final db = await database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM bmi WHERE gender = ? ' , [gender],
    );
    if(result.isNotEmpty ){
      return int.tryParse(result[0]['count'].toString()) ?? 0;
    }
    return 0;
  }

  Future<Map<String, dynamic>> calculateAveandCount() async{
    final double maleAverage = await calculateAverageBMI('Male');
    final int maleCount = await GenderCount('Male');
    final double femaleAverage = await calculateAverageBMI('Female');
    final int femaleCount = await GenderCount('Female');

    return{
      'AverageMale': maleAverage,
      'maleCount': maleCount,
      'AverageFemale': femaleAverage,
      'femaleCount': femaleCount,
    };
  }



}
