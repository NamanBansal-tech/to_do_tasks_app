import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/network/repositories/tasks/tasks_repo.dart';
import 'package:to_do_tasks/utils/app_strings.dart';
import 'package:to_do_tasks/utils/debouncer.dart';
import 'package:to_do_tasks/utils/server_constants.dart';
import 'package:to_do_tasks/utils/utility.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc({
    required this.tasksRepo,
  }) : super(HomeState.initial()) {
    initWidgets();
  }

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController deadlineController;
  late TextEditingController searchController;
  late GlobalKey<FormState> formKey;
  late Debouncer debouncer;
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamData;
  final TasksRepo tasksRepo;

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    searchController.dispose();
    return super.close();
  }

  void getTaskStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(ServerConstants.tasks).limit(10);
    if (searchController.text.trim().isNotEmpty) {
      query = query.where('title',
          isGreaterThanOrEqualTo: searchController.text.trim().toLowerCase());
      query = query.where('title',
          isLessThan: '${searchController.text.trim().toLowerCase()}z');
    }
    if (state.currentTab != HomeTabs.all) {
      query = query.where('isCompleted',
          isEqualTo: state.currentTab == HomeTabs.completed);
    }
    if (state.selectedFilterPriority != null) {
      query = query.where('priority',
          isEqualTo: state.selectedFilterPriority!.name);
    }
    if (state.selectedFilterDateTime != null) {
      query = query.where('deadline',
          isEqualTo: Utility.formatServerDate(state.selectedFilterDateTime!));
    }
    streamData = query.snapshots();
  }

  void initWidgets() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    deadlineController = TextEditingController();
    searchController = TextEditingController();
    debouncer = Debouncer();
    formKey = GlobalKey<FormState>();
    getTaskStream();
  }

  void searchItem(String searchString) {
    debouncer.run(() {
      emit(state.copyWith(estate: EHomeState.searching));
      setToInitialState();
      getTaskStream();
    });
  }

  void resetControllers() {
    titleController.clear();
    descriptionController.clear();
    deadlineController.clear();
    emit(state.copyWith(
        selectedDateTime: null, selectedPriority: TaskPriority.low));
  }

  void editTaskControllers(TaskModel task) {
    titleController.text = task.title ?? '';
    descriptionController.text = task.description ?? '';
    deadlineController.text = task.deadline != null
        ? Utility.formatDisplayDate(DateTime.parse(task.deadline!))
        : '';
    emit(state.copyWith(
        selectedDateTime:
            task.deadline != null ? DateTime.tryParse(task.deadline!) : null,
        selectedPriority: task.priority ?? TaskPriority.low));
  }

  void updateSelectedDate(DateTime date) {
    deadlineController.text = Utility.formatDisplayDate(date);
    emit(state.copyWith(selectedDateTime: date));
  }

  void updateSelectedFilteredDate(DateTime? date) {
    emit(state.copyWith(selectedFilterDateTime: date));
  }

  void updateSecondaryWidgetVisible(bool visible) {
    emit(state.copyWith(anySecondaryWidgetVisible: visible));
  }

  void updateCurrentTab(int index) {
    emit(state.copyWith(currentTab: HomeTabs.values[index]));
    getTaskStream();
  }

  void updateFilterPriority(TaskPriority? priority) {
    emit(state.copyWith(selectedFilterPriority: priority));
  }

  void updatePriority(TaskPriority priority) {
    emit(state.copyWith(selectedPriority: priority));
  }

  Future<void> addTask() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(state.copyWith(estate: EHomeState.loading));
        final hasInternetConnection = await Utility.checkInternetConnection();
        if (hasInternetConnection) {
          final id = const Uuid().v1();
          final response = await tasksRepo.createTask(
            TaskModel(
              deadline: state.selectedDateTime != null
                  ? Utility.formatServerDate(state.selectedDateTime!)
                  : null,
              id: id,
              description: descriptionController.text.trim(),
              isCompleted: false,
              title: titleController.text.trim(),
              priority: state.selectedPriority,
            ),
          );
          response.fold((l) {
            emit(
              state.copyWith(
                estate: EHomeState.error,
                message: l,
              ),
            );
            setToInitialState();
          }, (r) {
            emit(
              state.copyWith(
                estate: EHomeState.added,
                message: r,
              ),
            );
            setToInitialState();
          });
        } else {
          emit(
            state.copyWith(
              estate: EHomeState.error,
              message: AppStrings.noInternetConnection,
            ),
          );
          setToInitialState();
        }
      }
    } catch (e) {
      debugPrint('addTask $e');
      emit(state.copyWith(
          estate: EHomeState.error, message: AppStrings.somethingWentWrong));
      setToInitialState();
    }
  }

  Future<void> completeTask(TaskModel task) async {
    try {
      emit(state.copyWith(estate: EHomeState.loading, currentTaskId: task.id));
      final hasInternetConnection = await Utility.checkInternetConnection();
      if (hasInternetConnection) {
        final response = await tasksRepo.editTask(
          task.copyWith(
            isCompleted: true,
          ),
        );
        response.fold((l) {
          emit(
            state.copyWith(
              estate: EHomeState.error,
              message: l,
            ),
          );
          setToInitialState();
        }, (r) {
          emit(
            state.copyWith(
              estate: EHomeState.success,
              currentTaskId: null,
              message: AppStrings.taskSuccessfullyCompleted,
            ),
          );
          setToInitialState();
        });
      } else {
        emit(
          state.copyWith(
            estate: EHomeState.error,
            message: AppStrings.noInternetConnection,
          ),
        );
        setToInitialState();
      }
    } catch (e) {
      debugPrint('editTask $e');
      emit(state.copyWith(
          estate: EHomeState.error, message: AppStrings.somethingWentWrong));
      setToInitialState();
    }
  }

  Future<void> editTask(String taskId) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(state.copyWith(estate: EHomeState.loading));
        final hasInternetConnection = await Utility.checkInternetConnection();
        if (hasInternetConnection) {
          final response = await tasksRepo.editTask(
            TaskModel(
              deadline: state.selectedDateTime != null
                  ? Utility.formatServerDate(state.selectedDateTime!)
                  : null,
              id: taskId,
              description: descriptionController.text.trim(),
              isCompleted: false,
              title: titleController.text.trim(),
              priority: state.selectedPriority,
            ),
          );
          response.fold((l) {
            emit(
              state.copyWith(
                estate: EHomeState.error,
                message: l,
              ),
            );
            setToInitialState();
          }, (r) {
            emit(
              state.copyWith(
                estate: EHomeState.added,
                message: r,
              ),
            );
            setToInitialState();
          });
        } else {
          emit(
            state.copyWith(
              estate: EHomeState.error,
              message: AppStrings.noInternetConnection,
            ),
          );
          setToInitialState();
        }
      }
    } catch (e) {
      debugPrint('editTask $e');
      emit(state.copyWith(
          estate: EHomeState.error, message: AppStrings.somethingWentWrong));
      setToInitialState();
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(state.copyWith(estate: EHomeState.deleting));
    final hasInternetConnection = await Utility.checkInternetConnection();
    if (hasInternetConnection) {
      final response = await tasksRepo.deleteTask(taskId);
      response.fold((l) {
        emit(state.copyWith(estate: EHomeState.error, message: l));
        setToInitialState();
      }, (r) {
        emit(state.copyWith(estate: EHomeState.success, message: r));
        setToInitialState();
      });
    } else {
      emit(
        state.copyWith(
          estate: EHomeState.error,
          message: AppStrings.noInternetConnection,
        ),
      );
      setToInitialState();
    }
  }

  void setToInitialState() {
    emit(state.copyWith(estate: EHomeState.initial, message: null));
  }
}
