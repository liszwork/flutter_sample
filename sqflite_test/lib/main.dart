import 'package:flutter/material.dart';
import 'package:sqflite_test/db_provider.dart';
import 'package:sqflite_test/user_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBProvider db = DBProvider();

  List<UserData> userDatas = [];
  int id = 1;
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDelId = TextEditingController();

  String displayData = '';

  insert() async {
    String name = controllerName.text;
    int age = int.parse(controllerAge.text);
    UserData data = UserData(id: id, name: name, age: age);

    db.insert(data);

    controllerName.text = '';
    controllerAge.text = '';
    id++;

    restore();
  }

  restore() async {
    userDatas = await db.getUserDatas();
    showCurrentUserData();
  }

  showCurrentUserData() {
    setState(() {
      displayData = '';
      for (UserData data in userDatas) {
        displayData += data.toString() + '\n';
      }
      return;
    });
  }

  clearDisplay() {
    setState(() {
      displayData = '';
    });
  }

  allDelete() {
    db.deleteAll();
    id = 1;
    restore();
  }

  delete() {
    int id = int.parse(controllerDelId.text);
    db.delete(id);
    controllerDelId.text = '';
    restore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: controllerAge,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Age',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: insert,
                child: const Text('Insert'),
              ),
              ElevatedButton(
                onPressed: clearDisplay,
                child: const Text('Clear display'),
              ),
              ElevatedButton(
                onPressed: allDelete,
                child: const Text('All delete DB datas'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: controllerDelId,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'ID',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: delete,
                child: const Text('Delete ID'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: restore,
            child: const Text('Restore'),
          ),
          Text('$displayData'),
        ],
      ),
    );
  }
}
