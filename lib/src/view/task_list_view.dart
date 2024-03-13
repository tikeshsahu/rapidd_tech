// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_tech_assignment/src/view/auth_view.dart';
import 'package:rapidd_tech_assignment/src/model/task.dart';
import 'package:rapidd_tech_assignment/src/view_model/task_view_model.dart';
import 'package:intl/intl.dart';
import 'package:rapidd_tech_assignment/utils/storage_service.dart';
import 'package:rapidd_tech_assignment/widgets/add_task_modal.dart';

class TaskListView extends StatelessWidget {
  TaskListView({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              StorageService.instance.clearAll();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthView()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<List<Task>>(
          stream: Provider.of<TaskViewModel>(context, listen: false).getTasks(),
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final taskData = snapshot.data!;
              return ListView.builder(
                itemCount: taskData.length,
                itemBuilder: (context, index) {
                  var time = taskData[index].timestamp.toDate();
                  return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              taskData[index].title,
                            ),
                            scrollable: true,
                            content: Text(
                              taskData[index].description,
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await Provider.of<TaskViewModel>(context, listen: false).deleteTaskFromFirebase(taskData[index].id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          title: Text(taskData[index].title),
                          subtitle: Text(DateFormat.MMMEd().add_jm().format(time)),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.share,
                            ),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Share Task'),
                                        content: Form(
                                          key: formKey,
                                          child: TextFormField(
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                                              border: OutlineInputBorder(borderSide: BorderSide()),
                                              labelText: 'Enter Email',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty || !value.contains('@') || !value.contains('.com') && !value.contains('.in')) {
                                                return 'Incorrect Email address';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              emailController.dispose();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String email = emailController.text;
                                              if (formKey.currentState!.validate()) {
                                                await Provider.of<TaskViewModel>(context, listen: false).shareTask(taskData[index].id, email);
                                              }
                                              Navigator.pop(context);
                                              emailController.dispose();
                                            },
                                            child: const Text('Share'),
                                          ),
                                        ],
                                      ));
                            },
                          ),
                          leading: Checkbox(
                            value: taskData[index].isDone,
                            onChanged: (value) {
                              Provider.of<TaskViewModel>(context, listen: false).updateIsDone(taskData[index].id, value!);
                            },
                          ),
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              if (kDebugMode) print(snapshot.error);
              return const Center(
                child: Text('An error occurred'),
              );
            } else {
              return const Center(
                child: Text('No tasks found'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const AddTaskModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
