// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rapidd_tech_assignment/src/view/task_list_view.dart';
import 'package:rapidd_tech_assignment/utils/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggingIn = true;

  FirebaseAuth get authInstance => _auth;
  bool get isLogin => isLoggingIn;

  updateIsLogin(bool value) {
    isLoggingIn = value;
    notifyListeners();
  }

  submitForm(String email, String password, BuildContext context) async {
    UserCredential authResult;
    try {
      if (isLoggingIn) {
        authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String userId = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('user').doc(userId).set({'email': email});
      }
      StorageService.instance.save('USER_ID', authResult.user!.uid);
      StorageService.instance.save('USER_EMAIL', email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TaskListView()));
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found, please sign up")));
      } else if (error.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong password, please try again")));
      } else if (error.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User already exists, please try log in")));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Catch: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong, please try again")));
    }
  }
}
