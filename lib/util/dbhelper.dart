import 'package:football_app/models/pokemon.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final int version = 1;
  Database? db;
  static final DbHelper dbHelper = DbHelper._internal();

  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async{
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(),
      'pokeV1.db'),
        onCreate: (database, version){
        database.execute('CREATE TABLE pokemons(id INTEGER PRIMARY KEY, name TEXT)');
        }, version: version
      );
    }
    return db!;
  }
  Future testDb() async{
    db = await openDb();
    await db!.execute('INSERT INTO pokemons VALUES (1, "bulbasaur")');
    await db!.execute('INSERT INTO pokemons VALUES (2, "ivysaur")');

    List pokemons = await db!.rawQuery('SELECT * FROM pokemons');
    print(pokemons[0]);
  }

  //insert pokemon
  Future<int> insertPokemon(Pokemon pokemons) async{
    int id = await this.db!.insert(
        'pokemons',
        pokemons.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //get pokemon
  Future<bool> isPokemonSaved(String name) async{
    List<Map> result = await db!.rawQuery('SELECT * FROM pokemons WHERE name=?', ['${name}']);
    if(result.length > 0){
      return true;
    }
    return false;
  }

  // get pokemons
  Future<List<Pokemon>> getPokemons() async {
    final List<Map<String, dynamic>> maps = await db!.query('pokemons');

    return List.generate(maps.length, (i) {
      return Pokemon(
        maps[i]['id'],
        maps[i]['name'],
      );
    });
  }

  // delete pokemons
  Future<int> deletePokemon(Pokemon pokemon) async {
    int result = await db!.delete("pokemons", where: "id = ?", whereArgs: [pokemon.id]);
    return result;
  }

}