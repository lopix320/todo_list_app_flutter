import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modals/item.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  List<Item> items = [];

  HomePage() {
    // items.add(Item(title: "Banana", done: false));
    // items.add(Item(title: "Maçã", done: true));
    // items.add(Item(title: "Uva", done: false));
    // items.add(Item(title: "Manga", done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(
        Item(
          title: newTaskCtrl.text,
          done: false,
        ),
      );
      save();
      newTaskCtrl.clear();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    print(data);
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          decoration: const InputDecoration(
            labelText: "Nova Tarefa",
            hintText: "Digite algo:",
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, index) {
          final item = widget.items[index];
          return Dismissible(
            background: Container(
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction) {
              remove(index);
            },
            key: Key(item.title.toString()),
            child: CheckboxListTile(
              title: Text(item.title.toString()),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 153, 129, 137),
      ),
    );
  }
}
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 227, 146, 241),
      //   centerTitle: true,
      //   title: Text(
      //     'Testando',
      //     style: TextStyle(fontSize: 20.0),
      //   ),
      // ),
      // body: Column(
      //   children: const [
      //     Center(
      //       heightFactor: 2,
      //       child: Text('Olá Mundo!',
      //           textDirection: TextDirection.ltr,
      //           style: TextStyle(
      //             fontSize: 32,
      //             color: Colors.black,
      //           )),
      //     ),
      //   ],
      // ),