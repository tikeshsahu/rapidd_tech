import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rapidd_tech_assignment/src/model/task.dart';
import 'package:rapidd_tech_assignment/utils/app_utils.dart';
import 'package:rapidd_tech_assignment/utils/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskViewModel extends ChangeNotifier {
  final FirebaseFirestore data = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks() {
    try {
      return data.collection('tasks').doc('doc').collection("myTasks").snapshots().map((snapshot) {
        var userEmail = StorageService.instance.fetch(AppUtils.userEmail);

        var tasks = snapshot.docs
            .where((doc) {
              var toBeSeenBy = doc.data()['toBeSeenBy'] as List?;
              if (toBeSeenBy != null) {
                return toBeSeenBy.contains(userEmail);
              }
              return false;
            })
            .map((doc) => Task.fromMap(doc.data()))
            .toList();
        return tasks;
      });
    } catch (e) {
      if (kDebugMode) print("Error: $e");
      return const Stream.empty();
    }
  }

  Future<void> addTaskToFirebase(Task task) async {
    var docRef = await data.collection('tasks').doc('doc').collection("myTasks").add(task.toMap());
    task.id = docRef.id;
    await data.collection('tasks').doc('doc').collection("myTasks").doc(docRef.id).update({'id': docRef.id});
  }

  Future<void> deleteTaskFromFirebase(String id) async {
    try {
      await data.collection('tasks').doc('doc').collection("myTasks").doc(id).delete();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> updateIsDone(String id, bool isDone) async {
    try {
      await data.collection('tasks').doc('doc').collection("myTasks").doc(id).update({'isDone': isDone});
    } catch (e) {
      if (kDebugMode) print("Error updating task: $e");
    }
  }

  Future<void> shareTask(String taskId, String email) async {
    try {
      var taskRef = data.collection('tasks').doc('doc').collection("myTasks").doc(taskId);
      var taskSnapshot = await taskRef.get();

      if (taskSnapshot.exists) {
        await taskRef.update({
          'toBeSeenBy': FieldValue.arrayUnion([email]),
        });
      }

      await sendEmail(email);
    } catch (e) {
      if (kDebugMode) print("Error sharing task: $e");
    }
  }

  Future<void> sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': AppUtils.mailSubject,
        'body': AppUtils.mailBody,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }
}
