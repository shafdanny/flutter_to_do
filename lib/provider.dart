import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_to_do/models/to_do.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

@riverpod
class ToDoList extends _$ToDoList {
  @override
  Future<List<ToDo>> build() async {
    var box = Hive.box('localBox');
    List<ToDo> toDoList = [];

    for (var e in box.values) {
      toDoList
          .add(ToDo(id: e['id'], name: e['name'], completed: e['completed']));
    }

    syncToFirebase();

    return toDoList;
  }

  Future<void> addTodo(ToDo todo) async {
    final previousState = await future;
    previousState.add(todo);
    ref.notifyListeners();

    var box = Hive.box('localBox');

    box.put(todo.id,
        {'id': todo.id, 'name': todo.name, 'completed': todo.completed});

    syncToFirebase();
  }

  Future<void> deleteToDo(ToDo todo) async {
    final previousState = await future;
    previousState.remove(todo);
    ref.notifyListeners();

    var box = Hive.box('localBox');

    box.delete(todo.id);

    syncToFirebase();
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

    syncToFirebase();
  }

  Future<void> updateToDoList(List<ToDo> toDoList) async {
    final previousState = await future;

    previousState.clear();
    previousState.addAll(toDoList);

    var box = Hive.box('localBox');
    box.clear();

    for (var todo in toDoList) {
      box.put(todo.id,
          {'id': todo.id, 'name': todo.name, 'completed': todo.completed});
    }

    ref.notifyListeners();

    syncToFirebase();
  }

  Future<void> syncToFirebase() async {
    var box = Hive.box('localBox');
    List<ToDo> toDoList = [];

    for (var e in box.values) {
      toDoList
          .add(ToDo(id: e['id'], name: e['name'], completed: e['completed']));
    }

    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      final dio = Dio();
      var json = jsonEncode(toDoList, toEncodable: (e) => (e as ToDo).toJson());

      final response = await dio.put(
        'https://flutter-to-do-a1deb-default-rtdb.asia-southeast1.firebasedatabase.app/toDos.json',
        data: json,
      );
    }
  }
}
