import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/my_app.dart';
import 'package:to_do_tasks/screens/bloc/home_bloc.dart';
import 'package:to_do_tasks/utils/app_strings.dart';
import 'package:to_do_tasks/utils/utility.dart';

import 'add_new_task.dart';

class CurrentList extends StatelessWidget {
  const CurrentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return StreamBuilder(
        stream: context.read<HomeBloc>().streamData,
        builder: (context, snapshots) {
          return snapshots.connectionState == ConnectionState.waiting
              ? SizedBox(
                  height: 0.6.sh,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : !snapshots.hasError &&
                      snapshots.hasData &&
                      snapshots.data != null &&
                      snapshots.data!.docs.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        final item = TaskModel.fromJson(
                            snapshots.data!.docs[index].data());
                        Color? iconColor = item.priority != null
                            ? Utility.getPriorityColor(item.priority!)
                            : Colors.green;
                        String title = AppStrings.low;
                        switch (item.priority) {
                          case null:
                            break;
                          case TaskPriority.high:
                            title = AppStrings.high;
                            break;
                          case TaskPriority.medium:
                            title = AppStrings.medium;
                            break;
                          case TaskPriority.low:
                            title = AppStrings.low;
                            break;
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.h,
                              ),
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              leading: item.isCompleted
                                  ? Icon(
                                      Icons.done_all_rounded,
                                      color: CupertinoColors.activeGreen,
                                      size: 18.h,
                                    )
                                  : Icon(
                                      Icons.circle,
                                      color: iconColor,
                                      size: 16.h,
                                    ),
                              trailing: state.estate == EHomeState.loading &&
                                      state.currentTaskId == item.id
                                  ? const CircularProgressIndicator()
                                  : RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Switch(
                                              value: item.isCompleted,
                                              onChanged: (val) {
                                                if (!item.isCompleted) {
                                                  context
                                                      .read<HomeBloc>()
                                                      .completeTask(item);
                                                }
                                              },
                                            ),
                                            alignment:
                                                PlaceholderAlignment.middle,
                                          ),
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                            ),
                                            alignment:
                                                PlaceholderAlignment.middle,
                                          ),
                                        ],
                                      ),
                                    ),
                              title: Text(
                                item.title ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: [
                                ListTile(
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: Text(
                                    '${AppStrings.description}: ',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  title: Text(
                                    item.description ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: Text(
                                    '${AppStrings.deadLineWithFormat}: ',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  title: Text(
                                    item.deadline != null
                                        ? Utility.formatDisplayDate(
                                            DateTime.parse(item.deadline!))
                                        : 'N/A',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: Text(
                                    '${AppStrings.priority}: ',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  title: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                state.estate == EHomeState.deleting
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 12.h),
                                        child: item.isCompleted
                                            ? Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    context
                                                        .read<HomeBloc>()
                                                        .deleteTask(item.id!);
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5.w),
                                                            child: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
                                                              size: 12.h,
                                                            ),
                                                          ),
                                                          alignment:
                                                              PlaceholderAlignment
                                                                  .middle,
                                                        ),
                                                        const TextSpan(
                                                          text:
                                                              AppStrings.delete,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<HomeBloc>()
                                                            .editTaskControllers(
                                                                item);
                                                        showModalBottomSheet(
                                                          context: context,
                                                          enableDrag: true,
                                                          isScrollControlled:
                                                              true,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24.r),
                                                          ),
                                                          showDragHandle: true,
                                                          builder: (ctx) {
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: MediaQuery.of(
                                                                        navigatorKey.currentContext ??
                                                                            ctx)
                                                                    .viewInsets
                                                                    .bottom,
                                                              ),
                                                              child:
                                                                  BlocProvider
                                                                      .value(
                                                                value: context.read<
                                                                    HomeBloc>(),
                                                                child:
                                                                    AddNewTaskBottomSheet(
                                                                  taskId:
                                                                      item.id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            WidgetSpan(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: 5
                                                                            .w),
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 12.h,
                                                                ),
                                                              ),
                                                              alignment:
                                                                  PlaceholderAlignment
                                                                      .middle,
                                                            ),
                                                            const TextSpan(
                                                              text: AppStrings
                                                                  .edit,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<HomeBloc>()
                                                            .deleteTask(
                                                                item.id!);
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            WidgetSpan(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: 5
                                                                            .w),
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 12.h,
                                                                ),
                                                              ),
                                                              alignment:
                                                                  PlaceholderAlignment
                                                                      .middle,
                                                            ),
                                                            const TextSpan(
                                                              text: AppStrings
                                                                  .delete,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: snapshots.data != null
                          ? snapshots.data!.docs.length
                          : 0,
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          snapshots.hasError
                              ? AppStrings.somethingWentWrong
                              : AppStrings.noRecordFound,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
        },
      );
    });
  }
}
