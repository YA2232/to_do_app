import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskRepository taskRepository = TaskRepository();
  List<Task> tasks = [];

  TaskProvider() {
    getTasks();
  }

  Future<void> getTasks() async {
    tasks = await taskRepository.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    int id = await taskRepository.insertData(task);
    task.id = id;
    await getTasks();
  }

  Future<void> updateTask(Task task) async {
    await taskRepository.updateTask(task);
    await getTasks();
  }

  Future<void> deleteTask(int id) async {
    await taskRepository.deleteTaskById(id);
    await getTasks();
  }

  void toggleTaskDone(Task task) {
    task.toggle();
    updateTask(task);
  }
}
