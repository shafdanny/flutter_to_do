import 'package:flutter_to_do/models/to_do.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

@riverpod
class ToDoList extends _$ToDoList {
  @override
  Future<List<ToDo>> build() async {
    return [
      ToDo(id: const Uuid().v1(), name: 'Test 1', completed: false),
      ToDo(id: const Uuid().v1(), name: 'Test 2', completed: true),
    ];
  }

  Future<void> addTodo(ToDo todo) async {
    final previousState = await future;
    previousState.add(todo);
    ref.notifyListeners();
  }

  Future<void> deleteToDo(ToDo todo) async {
    final previousState = await future;
    previousState.remove(todo);
    ref.notifyListeners();
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

    ref.notifyListeners();
  }
}
