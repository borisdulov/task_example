import 'package:firebase_auth_example/feature/task/cubit/task_list/task_list_cubit.dart';
import 'package:firebase_auth_example/feature/task/model/task_model.dart';
import 'package:firebase_auth_example/feature/task/pages/task_list_page.dart';
import 'package:firebase_auth_example/feature/task/widgets/cant_create_task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  static const String path = '/new_task_page';

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool get canSave =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  void _saveTask() {
    if (!canSave) {
      showDialog(
        context: context,
        builder: (context) => const CantCreateTaskDialog(),
      );
      return;
    }

    final newTask = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
    );

    TaskListCubit.i(context).createTask(newTask);
    context.go(TaskListPage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(TaskListPage.path),
        ),
        title: const Text('New task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(_dateFormat.format(_selectedDate)),
                onTap: () => _selectDate(context),
                trailing: const Icon(Icons.calendar_today),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
