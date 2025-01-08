import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/view_models/notification.dart';
import 'package:to_do_app/view_models/provider.dart';
import 'package:to_do_app/views/add_task.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SendNotification myNotification = SendNotification();
  void addTimeToFirebase(BuildContext context) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference timeRemember =
        firebaseFirestore.collection("timeRemember");
    final DateTime? selectedDateTime = await pickTimeOfTask(context);
    if (selectedDateTime != null) {
      timeRemember
          .add({"selectedDateTime": selectedDateTime.toIso8601String()});
    }
  }

  Future<DateTime?> pickTimeOfTask(BuildContext context) async {
    print("Opening date and time picker...");
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    DateTime? selectedDateTime;

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        print("Selected Date and Time: $selectedDateTime");
      }
    }

    return selectedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTask();
            },
          );
        },
        tooltip: "Add Task",
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Row(
          children: [
            Text(
              "Tasks",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            SizedBox(width: 20),
            Icon(
              Icons.list,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  elevation: 9,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (bool? value) {
                        if (value != null) {
                          taskProvider.toggleTaskDone(task);
                        }
                      },
                    ),
                    title: Text(
                      task.title ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            myNotification.getTokenAndSendNotification(
                                title: "from Youssef",
                                body: "hey youssef , are you ok");
                          },
                          icon: Icon(
                            Icons.alarm,
                            color: Colors.blue[600],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            taskProvider.deleteTask(task.id!);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
