import 'package:flutter/material.dart';
import 'package:flutter_to_do/models/to_do.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

@riverpod
class ToDoList extends _$ToDoList {
  @override
  Future<List<ToDo>> build() async {
    var box = Hive.box('localBox');
    List<ToDo> toDoList = [];

    for (var e in box.values) {
      debugPrint(e.toString());
      toDoList
          .add(ToDo(id: e['id'], name: e['name'], completed: e['completed']));
    }

    return toDoList;
  }

  Future<void> addTodo(ToDo todo) async {
    final previousState = await future;
    previousState.add(todo);
    ref.notifyListeners();

    var box = Hive.box('localBox');

    box.put(todo.id,
        {'id': todo.id, 'name': todo.name, 'completed': todo.completed});
  }

  Future<void> deleteToDo(ToDo todo) async {
    final previousState = await future;
    previousState.remove(todo);
    ref.notifyListeners();

    var box = Hive.box('localBox');

    box.delete(todo.id);
  }

  Future<void> changeCompletedToDo(ToDo todo) async {
    final previousState = await future;

    final updatedList = previousState
        .map((todoElem) => todoElem == todo
            ? todoElem.copyWith(completed: !todo.completed)
            : todoElem)
        .toList();

    previousState.clear();
    previousState.addAll(updatedList);

    var box = Hive.box('localBox');
    box.clear();

    for (var todo in updatedList) {
      box.put(todo.id,
          {'id': todo.id, 'name': todo.name, 'completed': todo.completed});
    }

    ref.notifyListeners();
  }
}
