import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/todo_model.dart';

class DatabaseServices {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("todos");

  User? user = FirebaseAuth.instance.currentUser;

  //add todo
  Future<DocumentReference> addTodoItem(
      String title, String description) async {
    return await todoCollection.add({
      "uid": user?.uid,
      "title": title,
      "description": description,
      "completed": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  //update todo
  Future<void> updateTodo(String id, String title, String description) async {
    final updateTodoCollection =
        FirebaseFirestore.instance.collection("todos").doc(id);

    return await updateTodoCollection.update({
      "title": title,
      "description": description,
    });
  }

  //update status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({"completed": completed});
  }

  //delete Todo
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  //get todos
  Stream<List<Todo>> get todos {
    return todoCollection
        .where("uid", isEqualTo: user!.uid)
        .where("completed", isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapShot);
  }

  Stream<List<Todo>> get completedtodos {
    return todoCollection
        .where("uid", isEqualTo: user!.uid)
        .where("completed", isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapShot);
  }

  List<Todo> _todoListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
          id: doc.id,
          title: doc["title"] ?? "",
          completed: doc["completed"] ?? false,
          description: doc["description"] ?? "",
          timeStamp: doc["createdAt"] ?? "");
    }).toList();
  }
}
