import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PokeDetails extends StatefulWidget{

  const PokeDetails({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<PokeDetails> createState() => _PokeDetailsState();
}

class _PokeDetailsState extends State<PokeDetails> {
  var info;

  Future<String> makeRequest() async{
    var response = await http.get(Uri.parse(this.widget.data['url']),
        headers: {'Accept': 'aplication/json'});
    setState(() {
      info = json.decode(response.body);
    });

    return response.body;
  }

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('${this.info != null ? this.info['sprites']['front_default'] : 'https://www.creativefabrica.com/wp-content/uploads/2021/06/14/Illustration-Vector-graphic-of-Loading-Graphics-13392504-1-1-580x387.jpg'}',
              width: 200,
              height: 180,
              fit: BoxFit.cover,
            ),
            Text('${this.info != null ? this.info['name'] : 'Loading...'}', style: TextStyle(fontSize: 25),),
          ],
        ),
      ),
    );
  }
}
