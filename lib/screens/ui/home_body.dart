import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_tasks/components/custom_text_form_field.dart';
import 'package:to_do_tasks/my_app.dart';
import 'package:to_do_tasks/screens/bloc/home_bloc.dart';
import 'package:to_do_tasks/screens/ui/add_new_task.dart';
import 'package:to_do_tasks/screens/ui/current_list.dart';
import 'package:to_do_tasks/screens/ui/show_filter_dialog_box.dart';
import 'package:to_do_tasks/utils/app_strings.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          AppStrings.toDoTasks,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<HomeBloc>().updateSecondaryWidgetVisible(true);
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: BlocProvider.value(
                      value: context.read<HomeBloc>(),
                      child: const ShowFilterDialogBox(),
                    ),
                  );
                },
              ).whenComplete(
                () {
                  if (context.mounted) {
                    context
                        .read<HomeBloc>()
                        .updateSecondaryWidgetVisible(false);
                  }
                },
              );
            },
            icon: const Icon(Icons.filter_alt_rounded),
          ),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.estate == EHomeState.error && state.message != null) {
            Fluttertoast.showToast(
                msg: state.message!, backgroundColor: Colors.red);
          }
          if (state.estate == EHomeState.success && state.message != null) {
            Fluttertoast.showToast(
                msg: state.message!, backgroundColor: Colors.green);
          }
          if (state.estate == EHomeState.added && state.message != null) {
            Fluttertoast.showToast(
                msg: state.message!, backgroundColor: Colors.green);
            context.read<HomeBloc>().getTaskStream();
            if (navigatorKey.currentContext != null) {
              Navigator.pop(navigatorKey.currentContext ?? context);
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              CustomTextFormField(
                onChanged: (val) {
                  context.read<HomeBloc>().searchItem(val);
                },
                controller: context.read<HomeBloc>().searchController,
                labelText: AppStrings.search,
                hintText: AppStrings.searchHint,
                suffix: const Icon(Icons.search_rounded),
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultTabController(
                length: HomeTabs.values.length,
                child: TabBar(
                  onTap: (val) {
                    context.read<HomeBloc>().updateCurrentTab(val);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  labelColor: Colors.blue,
                  indicatorColor: Colors.blueAccent,
                  tabs: const [
                    Tab(
                      text: AppStrings.all,
                    ),
                    Tab(
                      text: AppStrings.pending,
                    ),
                    Tab(
                      text: AppStrings.completed,
                    ),
                  ],
                ),
              ),
              const Expanded(child: CurrentList()),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.read<HomeBloc>().updateSecondaryWidgetVisible(true);
          context.read<HomeBloc>().resetControllers();
          showModalBottomSheet(
            context: context,
            enableDrag: true,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            showDragHandle: true,
            builder: (_) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: const AddNewTaskBottomSheet(),
                ),
              );
            },
          ).whenComplete(
            () {
              if (context.mounted) {
                context.read<HomeBloc>().updateSecondaryWidgetVisible(false);
              }
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
