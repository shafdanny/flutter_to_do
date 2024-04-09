import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do/models/to_do.dart';
import 'package:flutter_to_do/provider.dart';
import 'package:flutter_to_do/to_do_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('localBox');

  runApp(
    const ProviderScope(
      child: ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends ConsumerWidget {
  ToDoListPage({super.key});

  final TextEditingController _textFieldController = TextEditingController();

  void _addToDoItem(WidgetRef ref, String name) {
    ref.read(toDoListProvider.notifier).addTodo(ToDo(
          id: const Uuid().v1(),
          name: name,
          completed: false,
        ));
    _textFieldController.clear();
  }

  void _handleTodoChange(WidgetRef ref, ToDo toDo) {
    ref.read(toDoListProvider.notifier).changeCompletedToDo(toDo);
  }

  void _deleteTodo(WidgetRef ref, ToDo toDo) {
    ref.read(toDoListProvider.notifier).deleteToDo(toDo);
  }

  Future<void> _displayDialog(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your todo'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addToDoItem(ref, _textFieldController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ToDo>> toDoList = ref.watch(toDoListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('To Do List'),
      ),
      body: switch (toDoList) {
        AsyncData(:final value) => ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: value.map((ToDo toDo) {
              return ToDoItem(
                toDo: toDo,
                onToDoChanged: _handleTodoChange,
                deleteToDo: _deleteTodo,
              );
            }).toList(),
          ),
        AsyncError() => const Text('Oops, something unexpected happened'),
        _ => const CircularProgressIndicator(),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context, ref),
        tooltip: 'Add a Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
