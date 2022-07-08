import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_app/models/pokemon.dart';
import 'package:football_app/ui/favorites.dart';
import 'package:football_app/util/dbhelper.dart';
import 'package:http/http.dart' as http;
import 'details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Poke Dex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String url = "https://pokeapi.co/api/v2/pokemon";
  bool like = true;
  List data = [];
  DbHelper helper = DbHelper();
  List<Pokemon> pokemons = [];
  List<bool> favorites = [];

  Future<String> makeRequest() async{
    var response = await http.get(Uri.parse(url),
    headers: {'Accept': 'aplication/json'});

    setState(() {
      var extractData = json.decode(response.body);
      data = extractData['results'];
    });
    return response.body;
  }

  bool isFavorite (Pokemon poke){
    /*bool isPresent = false;
    pokemons.map((e) => (){
      print(e.name);
      if(e.name == name){
        isPresent = true;
      }
    });
    return isPresent;*/
    return pokemons.contains(poke);
    // TODO: No funciona
  }

  Future showData() async{
    await helper.openDb();
    pokemons = await helper.getPokemons();
    setState(() {
      pokemons = pokemons;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    //print(data);
   // print(pokemons);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i){
            return ListTile(
              title: Text(data[i]['name']),
              trailing: InkWell(
                child: isFavorite(Pokemon(i, data[i]['name'])) == true ? Icon(Icons.favorite_border) : Icon(Icons.favorite, color: Colors.red,),
                onTap: (){
                  setState(() {
                    helper.insertPokemon(Pokemon(i, data[i]['name']));
                  });
                  /*if(helper.isPokemonSaved(data[i]['name']) == true){
                    setState(() {
                      helper.deletePokemon(Pokemon(i, data[i]['name']));
                    });
                  } else{
                    setState(() {
                      helper.insertPokemon(Pokemon(i, data[i]['name']));
                    });
                  }*/
                },
              ),
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PokeDetails(data: data[i])));
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Favorites()));
              },
            );
          }
      ),
    );
  }
}
