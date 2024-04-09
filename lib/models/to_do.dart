import 'package:freezed_annotation/freezed_annotation.dart';

part 'to_do.freezed.dart';
part 'to_do.g.dart';

@freezed
class ToDo with _$ToDo {
  factory ToDo({
    required String id,
    required String name,
    required bool completed,
  }) = _ToDo;

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);
}
