import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class Thrones{
  final String name;
  final String culture;

  Thrones({this.name, this.culture});

  factory Thrones.fromJson(Map<String, dynamic> json) {
    return Thrones(
      name: json['name'],
      culture: json['culture'],
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}):url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
}// TestHttp

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  String _url;
  Thrones _thrones;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }//initState

  _sendRequestGet(){
    http.get(_url).then((response) {
      _thrones = Thrones.fromJson(json.decode(response.body));

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _thrones = Thrones(
        name: '',
        culture: '',
      );

      setState(() {});
    });
  }



  Widget build(BuildContext context) {
    return Form(key: _formKey, child: SingleChildScrollView(child: Column(
      children: <Widget>[
        Container(
            child: Text('Ссылка на API', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
            padding: EdgeInsets.all(10.0)
        ),
        Container(
            child: TextFormField(initialValue: _url, validator: (value){if (value.isEmpty) return 'Поле не может быть пустым';}, onSaved: (value){_url = value;}, autovalidate: true),
            padding: EdgeInsets.all(10.0)
        ),
        SizedBox(height: 20.0),
        RaisedButton(child: Text('Послать запрос'), onPressed: _sendRequestGet),
        Text('Информация', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
        Text(_thrones == null ? '' : _thrones.name),
        Text(_thrones == null ? '' : _thrones.culture),
      ],
    )));
  }//build
}//TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Экзамен'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: TestHttp(url: 'https://anapioficeandfire.com/api/characters/583')
    );
  }
}

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp()
    )
);