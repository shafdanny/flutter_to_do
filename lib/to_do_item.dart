import 'package:flutter/material.dart';
import 'package:flutter_to_do/models/to_do.dart';

class ToDoItem extends StatelessWidget {
  ToDoItem({
    required this.toDo,
    required this.onToDoChanged,
    required this.deleteToDo,
  }) : super(key: ObjectKey(toDo));

  final ToDo toDo;
  final void Function(ToDo toDo) onToDoChanged;
  final void Function(ToDo toDo) deleteToDo;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: toDo.completed,
        onChanged: (value) {
          onToDoChanged(toDo);
        },
      ),
      title: Row(children: <Widget>[
        Expanded(
          child: Text(toDo.name, style: _getTextStyle(toDo.completed)),
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          onPressed: () {
            deleteToDo(toDo);
          },
        ),
      ]),
    );
  }
}
