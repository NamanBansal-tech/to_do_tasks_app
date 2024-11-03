import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_tasks/network/repositories/tasks/tasks_repo_impl.dart';
import 'package:to_do_tasks/screens/bloc/home_bloc.dart';
import 'package:to_do_tasks/screens/ui/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        tasksRepo: TasksRepoImpl(),
      ),
      child: const HomeBody(),
    );
  }
}
