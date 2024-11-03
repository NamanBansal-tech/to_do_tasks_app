import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_tasks/components/custom_text_form_field.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/screens/bloc/home_bloc.dart';
import 'package:to_do_tasks/utils/app_strings.dart';
import 'package:to_do_tasks/utils/utility.dart';

class AddNewTaskBottomSheet extends StatelessWidget {
  const AddNewTaskBottomSheet({super.key, this.taskId});

  final String? taskId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 16.h,
            ),
            child: Form(
              key: context.read<HomeBloc>().formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (taskId == null)
                    Text(
                      AppStrings.addTask,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextFormField(
                    enabled: state.estate != EHomeState.loading,
                    controller: context.read<HomeBloc>().titleController,
                    hintText: AppStrings.enterTitle,
                    labelText: AppStrings.title,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return AppStrings.titleEmptyMsg;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextFormField(
                    enabled: state.estate != EHomeState.loading,
                    hintText: AppStrings.enterDescription,
                    labelText: AppStrings.description,
                    controller: context.read<HomeBloc>().descriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return AppStrings.descriptionEmptyMsg;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextFormField(
                    enabled: state.estate != EHomeState.loading,
                    controller: context.read<HomeBloc>().deadlineController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return AppStrings.deadlineEmptyMsg;
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () async {
                      final currentDate = DateTime.now();
                      final data = await showDatePicker(
                        context: context,
                        firstDate: currentDate,
                        lastDate: DateTime(currentDate.year + 12),
                        initialDate: state.selectedDateTime,
                      );
                      if (context.mounted && data != null) {
                        context.read<HomeBloc>().updateSelectedDate(data);
                      }
                    },
                    labelText: AppStrings.deadLineWithFormat,
                    hintText: AppStrings.selectDeadline,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        AppStrings.priority,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Radio(
                        value: TaskPriority.low,
                        groupValue: state.selectedPriority,
                        onChanged: (val) {
                          if (val != null) {
                            context.read<HomeBloc>().updatePriority(val);
                          }
                        },
                        fillColor: WidgetStateProperty.all(
                            Utility.getPriorityColor(TaskPriority.low)),
                      ),
                      Text(
                        AppStrings.low,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Radio(
                        value: TaskPriority.medium,
                        groupValue: state.selectedPriority,
                        onChanged: (val) {
                          if (val != null) {
                            context.read<HomeBloc>().updatePriority(val);
                          }
                        },
                        fillColor: WidgetStateProperty.all(
                            Utility.getPriorityColor(TaskPriority.medium)),
                      ),
                      Text(
                        AppStrings.medium,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Radio(
                        value: TaskPriority.high,
                        groupValue: state.selectedPriority,
                        onChanged: (val) {
                          if (val != null) {
                            context.read<HomeBloc>().updatePriority(val);
                          }
                        },
                        fillColor: WidgetStateProperty.all(
                            Utility.getPriorityColor(TaskPriority.high)),
                      ),
                      Text(
                        AppStrings.high,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  state.estate == EHomeState.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (taskId != null) {
                              context.read<HomeBloc>().editTask(taskId!);
                            } else {
                              context.read<HomeBloc>().addTask();
                            }
                          },
                          child: const Text(
                            AppStrings.submit,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
