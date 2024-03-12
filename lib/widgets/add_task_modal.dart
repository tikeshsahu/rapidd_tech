import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_tech_assignment/src/model/task.dart';
import 'package:rapidd_tech_assignment/src/view_model/task_view_model.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({Key? key}) : super(key: key);

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              autocorrect: true,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
              onPressed: () {
                taskViewModel.addTaskToFirebase(
                  Task.createNew(titleController.text, descriptionController.text),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
