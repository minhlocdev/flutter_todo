import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timeStamp;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.description,
    required this.timeStamp,
  });
}
