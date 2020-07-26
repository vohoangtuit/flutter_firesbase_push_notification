import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String content;
  DetailPage(this.content);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.blueGrey,
          child: Text("Detail: "+widget.content, style: TextStyle(fontSize: 18,color: Colors.white),),
        ),
      ),

    );
  }
}
