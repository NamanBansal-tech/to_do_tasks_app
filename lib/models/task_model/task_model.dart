import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';

part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    String? id,
    String? title,
    String? description,
    String? deadline,
    TaskPriority? priority,
    @Default(false) bool isCompleted,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

enum TaskPriority {
  high,
  medium,
  low,
}
