import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_app/models/pokemon.dart';
import 'package:football_app/util/dbhelper.dart';
import 'package:http/http.dart' as http;

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  DbHelper helper = DbHelper();
  List<Pokemon> pokeFavs = [];

  Future showData() async{
    await helper.openDb();
    pokeFavs = await helper.getPokemons();

    setState(() {
      pokeFavs = pokeFavs;
    });
  }

  @override
  Widget build(BuildContext context) {
    showData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Favoritos'),
      ),
      body: ListView.builder(
          itemCount: pokeFavs == null ? 0 : pokeFavs.length,
          itemBuilder: (BuildContext context, i){
            return ListTile(
              title: Text(pokeFavs[i].name),

            );
          }
      ),
    );
  }
}

