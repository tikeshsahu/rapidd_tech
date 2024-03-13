import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapidd_tech_assignment/utils/app_utils.dart';
import 'package:rapidd_tech_assignment/utils/storage_service.dart';

class Task {
  late String id;
  late String title;
  late String description;
  late Timestamp timestamp;
  late List<String> toBeSeenBy;
  late bool isDone;

  Task({required this.id, required this.title, required this.description, required this.timestamp, required this.toBeSeenBy,required this.isDone});

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    timestamp = map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.fromDate(map['timestamp']);
    toBeSeenBy = List<String>.from(map['toBeSeenBy'] ?? []);
    isDone = map['isDone'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'toBeSeenBy': toBeSeenBy,
      'isDone': isDone,
    };
  }

  factory Task.createNew(String title, String description) {
    return Task(id: '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(10000)}', title: title, description: description, timestamp: Timestamp.now(), toBeSeenBy: [StorageService.instance.fetch(AppUtils.userEmail)], isDone: false);
  }
}
