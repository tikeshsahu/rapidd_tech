import 'package:rapidd_tech_assignment/auth/auth_view.dart';
import 'package:rapidd_tech_assignment/src/view/task_list_view.dart';
import 'package:rapidd_tech_assignment/utils/storage_service.dart';

class AppUtils{

  // Mail Data
  static const String mailSubject = "Sharing with you a Task.";
  static const String mailBody = "Hey, I am sharing a task with you. Please check it out. \n\nOpen the To-Do App to view the task.";

  // Storage keys
  static const String userId = "USER_ID";
  static const String userEmail = "USER_EMAIL";

  static checkUser() {
    if (StorageService.instance.fetch(AppUtils.userId) != null) {
      return const TaskListView();
    } else {
      return const AuthView();
    }
  }
}




