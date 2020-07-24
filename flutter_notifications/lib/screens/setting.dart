import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String content;
  SettingPage(this.content);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text(widget.content, style: TextStyle(fontSize: 18,color: Colors.teal),),
        ),
      ),

    );
  }
}
