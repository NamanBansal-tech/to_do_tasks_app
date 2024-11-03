import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/network/repositories/tasks/tasks_repo.dart';
import 'package:to_do_tasks/utils/app_strings.dart';
import 'package:to_do_tasks/utils/server_constants.dart';
import 'package:to_do_tasks/utils/type_def.dart';

class TasksRepoImpl extends TasksRepo {
  @override
  ResultOrError<String> createTask(TaskModel task) async {
    try {
      await FirebaseFirestore.instance
          .collection(ServerConstants.tasks)
          .doc(task.id)
          .set(
            task.toJson(),
          );
      return const Right(AppStrings.taskSuccessfullyAdded);
    } catch (e) {
      log(
        e.toString(),
        name: "Add Task Exception",
      );
      return const Left(
        AppStrings.somethingWentWrong,
      );
    }
  }

  @override
  ResultOrError<String> editTask(TaskModel task) async {
    try {
      await FirebaseFirestore.instance
          .collection(ServerConstants.tasks)
          .doc(task.id)
          .update(
            task.toJson(),
          );
      return const Right(AppStrings.taskSuccessfullyEdit);
    } catch (e) {
      log(
        e.toString(),
        name: "Edit Task Exception",
      );
      return const Left(
        AppStrings.somethingWentWrong,
      );
    }
  }

  @override
  ResultOrError<String> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection(ServerConstants.tasks)
          .doc(taskId)
          .delete();
      return const Right(AppStrings.taskSuccessfullyDeleted);
    } catch (e) {
      log(
        e.toString(),
        name: "Delete Task Exception",
      );
      return const Left(
        AppStrings.somethingWentWrong,
      );
    }
  }
}
