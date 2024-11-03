import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/utils/type_def.dart';

abstract class TasksRepo {
  ResultOrError<String> createTask(TaskModel task);
  ResultOrError<String> editTask(TaskModel task);
  ResultOrError<String> deleteTask(String taskId);
}
