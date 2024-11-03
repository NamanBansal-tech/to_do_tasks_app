part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(EHomeState.initial) EHomeState estate,
    String? message,
    DateTime? selectedDateTime,
    DateTime? selectedFilterDateTime,
    @Default(false) bool anySecondaryWidgetVisible,
    @Default(TaskPriority.low) TaskPriority selectedPriority,
    TaskPriority? selectedFilterPriority,
    String? currentTaskId,
    @Default(HomeTabs.all) HomeTabs currentTab,
  }) = _HomeState;

  factory HomeState.initial() => HomeState();
}

enum EHomeState {
  initial,
  loading,
  error,
  deleting,
  searching,
  added,
  success,
}

enum HomeTabs {
  all,
  pending,
  completed,
}
