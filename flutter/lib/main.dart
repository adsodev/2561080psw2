import 'dart:convert';

import 'package:api_mob/models/Datos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ejemplo API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Datos?>? datos;
  
  // Future<void> getDatos() async {
  //   const url = 'https://jsonplaceholder.typicode.com/posts';
  //   final response = await http.get(Uri.parse(url));
  //
  //   print(response.body);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getDatos();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Datos?>(
                future: datos,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if(snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  } else {
                    if(snapshot.hasData) {
                      return buildDataWidget(context, snapshot);
                    } else if(snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return Container();
                    }
                  }
                }
            ),
            ElevatedButton(
                onPressed: () => clicGet(3),
                child: const Text("GET")
            ),
            ElevatedButton(
                onPressed: () => clicPost(),
                child: const Text("POST")
            ),
            ElevatedButton(
                onPressed: () => clicPut(2),
                child: const Text("PUT")
            ),
            ElevatedButton(
                onPressed: () => clicDelete(4),
                child: const Text("DELETE")
            ),
          ],
        ),
      ),
    );
  }

  void clicGet(int id) {
    setState(() {
      datos = getMethod(id);
    });
  }

  void clicPost() {
    setState(() {
      datos = postMethod('Título', 'Contenido');
    });
  }

  void clicPut(int id) {
    setState(() {
      datos = putMethod(id, 'Título', 'Contenido');
    });
  }

  void clicDelete(int id) {
    setState(() {
      datos = deleteMethod(id);
    });
  }
}

Widget buildDataWidget(context, snapshot) => Column(
  children: [
    Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(snapshot.data.title)
    ),
    Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(snapshot.data.body)
    )
  ],
);

Future<Datos> getMethod(int id) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
  final response = await http.get(url);

  return Datos.fromJson(json.decode(response.body));
}

Future<Datos> postMethod(String title, String body) async {
  Map<String, dynamic> request = {
    'title': title,
    'body': body
  };

  const url = 'https://jsonplaceholder.typicode.com/posts';
  final response = await http.post(Uri.parse(url), body: request);

  return Datos.fromJson(json.decode(response.body));
}

Future<Datos> putMethod(int id, String title, String body) async {
  Map<String, dynamic> request = {
    'title': title,
    'body': body
  };

  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
  final response = await http.put(url, body: request);

  return Datos.fromJson(json.decode(response.body));
}

Future<Datos?>? deleteMethod(int id) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
  final response = await http.delete(url);

  return null;
}