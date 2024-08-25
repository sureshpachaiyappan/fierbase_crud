import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String name;
  String email;
  String age;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.name,
    required this.email,
    required this.age,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          age: json['age']! as String,
          isDone: json['isDone']! as bool,
          createdOn: json['createdOn']! as Timestamp,
          updatedOn: json['updatedOn']! as Timestamp,
        );

  Todo copyWith({
    String? name,
    String? email,
    String? age,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Todo(
        name: name ?? this.name,
        email: name ?? this.email,
        age: name ?? this.age,
        isDone: isDone ?? this.isDone,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email':email,
      'age':age,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
