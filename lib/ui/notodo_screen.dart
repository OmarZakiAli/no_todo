import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../util/dp_helper.dart';
import '../model/todo_model.dart';

class ToDoUi extends StatefulWidget {
  @override
  _ToDoUiState createState() => _ToDoUiState();
}

class _ToDoUiState extends State<ToDoUi> {
  var _textController = TextEditingController();
  List<NoDoItem> _items = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: ListView.builder(
        itemCount: _items.length,
        reverse: false,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            color: Colors.brown,
            child: ListTile(
                title: Text(
                  "${_items[index].itemName}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                leading: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: CircleAvatar(
                      child: Text("${_items[index].id}"),
                    )),
                contentPadding: EdgeInsets.only(top: 3.0),
                subtitle: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${_items[index].dateCreated}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                trailing: Listener(
                  key: Key("${_items[index].itemName}"),
                  child: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                  onPointerDown: (pointerEvent) {
                    _delete(_items[index].id, index);
                  },
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  void _showDialog() {
    var alert = AlertDialog(
        title: Text("add no todo item"),
        content: Container(
          color: Colors.grey,
          width: 200,
          height: 230,
          child: Column(
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.add,
                      color: Colors.yellowAccent,
                    ),
                    hintText: "ex: dont forget pryer",
                    hintStyle: TextStyle(color: Colors.red),
                    labelText: "not to do?"),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              RaisedButton(
                onPressed: _addNotoDo,
                child: Text(
                  "add",
                  style: TextStyle(color: Colors.blue),
                ),
                color: Colors.white,
              )
            ],
          ),
        ));

    showDialog(context: context, child: alert);
  }

  DatabaseHelper helper = DatabaseHelper();

  void _addNotoDo() async {
    NoDoItem notodo = NoDoItem(_textController.value.text, _getFormatedDate());
    int x = await helper.saveItem(notodo);
    var wtf = await helper.getItem(x);
    debugPrint(wtf.itemName);
    setState(() {
      _items.insert(0, wtf);
    });
    _textController.clear();
    Navigator.pop(context);
  }

  void _readList() async {
    List list = await helper.getItems();
    list.forEach((item) {
      NoDoItem noDoItem = NoDoItem.map(item);
      _items.add(noDoItem);
    });
  }

  void _delete(int id, int index) async {
    await helper.deleteItem(id);
    setState(() {
      _items.removeAt(index);
    });
  }

  String _getFormatedDate() {
    var time = DateTime.now();
    var dateFormat = DateFormat.yMMMMd("en_US");

    return dateFormat.format(time);
  }
}
