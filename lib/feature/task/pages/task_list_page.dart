import 'package:firebase_auth_example/feature/settings/pages/settings_page.dart';
import 'package:firebase_auth_example/feature/task/cubit/task_list/task_list_cubit.dart';
import 'package:firebase_auth_example/feature/task/cubit/task_list/task_list_cubit_state.dart';
import 'package:firebase_auth_example/feature/task/pages/new_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  static const String path = '/tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: TaskListCubit.i(context).loadTasks,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(SettingsPage.path),
          ),
        ],
      ),
      body: BlocBuilder<TaskListCubit, TaskListCubitState>(
        builder: (context, state) {
          if (state is TaskListStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TaskListStateSuccess) {
            if (state.taskList.isEmpty) {
              return const Center(
                child: Text("You have no tasks yet!"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final task = state.taskList[index];
                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) =>
                      TaskListCubit.i(context).removeTask(task),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (v) => TaskListCubit.i(context)
                          .changeCompleteStatusTask(task),
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                      task.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Builder(
                      builder: (context) {
                        final isExpired =
                            task.dueDate.isBefore(DateTime.now()) &&
                                !task.isCompleted;

                        return Text(
                          DateFormat.MMMMEEEEd().format(task.dueDate),
                          style: TextStyle(
                            color: isExpired ? Colors.red : Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              itemCount: state.taskList.length,
            );
          }
          if (state is TaskListStateFailure) {
            return Center(
              child: Text(
                "ERROR ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(NewTaskPage.path),
        child: const Icon(Icons.add),
      ),
    );
  }
}
