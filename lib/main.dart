import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Wikipedia search API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getPeliculaData() async {
    var response = await http.get(Uri.parse("https://ghibliapi.herokuapp.com/films"));

    var jsonData = jsonDecode(response.body);

    List<Pelicula> peliculas = [];

    for (var u in jsonData) {
      Pelicula pelicula = Pelicula(u["id"], u["title"], u["director"], u["release_date"], u["description"], u["image"]);
      peliculas.add(pelicula);
    }

    return peliculas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Ghibli'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getPeliculaData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: Text('Cargando')),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Card(child: ListTile(leading: FlutterLogo(), title: Text(snapshot.data[i].title), subtitle: Text(snapshot.data[i].director), trailing: Text(snapshot.data[i].release_date)));
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Pelicula {
  final String id, title, director, release_date, description, image;
  Pelicula(this.id, this.title, this.director, this.release_date, this.description, this.image);
}
