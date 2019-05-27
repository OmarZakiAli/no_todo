import 'package:flutter/material.dart';
import './notodo_screen.dart';

class NoToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        title: Text(
          "No ToDo",
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
      ),
      body: ToDoUi(),
    );
  }
}
