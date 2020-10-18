import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<MemeData> fetchAlbum() async {
  final response = await http.get('https://meme-api.herokuapp.com/gimme');
  if (response.statusCode == 200) {
    return MemeData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load meme');
  }
}

class MemeData{
  final String url;
  MemeData({this.url});
  factory MemeData.fromJson(Map<String, dynamic>json){
    return MemeData(
      url: json['url'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    Future<MemeData> futureMemeData;
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      futureMemeData = fetchAlbum();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Meme Meme !!!!'),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<MemeData>(
                future: futureMemeData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.network(snapshot.data.url);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      setState
                        (() {
                       didChangeDependencies();
                      });
                    },
                    child: Text('NEXT'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
