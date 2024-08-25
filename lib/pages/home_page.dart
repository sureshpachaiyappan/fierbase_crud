import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "User List",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text("Add a User Data!"),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              String todoId = todos[index].id;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.name),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${todo.email}, (${todo.age})'),
                      Text(
                        DateFormat("dd-MM-yyyy h:mm a").format(
                          todo.updatedOn.toDate(),
                        ),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: -16,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _displayUpdateInputDialog(todoId,todo);
                          // Todo updatedTodo = todo.copyWith(
                          //     isDone: !todo.isDone, updatedOn: Timestamp.now());
                          // _databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          _databaseService.deleteTodo(todoId);

                        },
                      ),
                    ],
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayUpdateInputDialog(String id ,Todo updated) async {
    final userNameController = TextEditingController(text:updated.name);
    final userAgeController = TextEditingController(text:updated.age);
    final userEmailController = TextEditingController(text:updated.email);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Users'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: userNameController,
                  decoration:  InputDecoration(hintText: updated.name),

                ),

                TextField(
                  controller: userEmailController,
                  decoration:  InputDecoration(hintText: updated.email),
                ),

                TextField(
                  controller: userAgeController,
                  decoration:  InputDecoration(hintText:updated.age),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),


            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text('Ok'),
              onPressed: () {
                Todo todos = Todo(
                    name: userNameController.text,
                    email:userEmailController.text,
                    age: userAgeController.text,
                    isDone: !updated.isDone,
                    createdOn: Timestamp.now(),
                    updatedOn: Timestamp.now());
                _databaseService.updateTodo(id, todos);
                Navigator.pop(context);
                userNameController.clear();
                userEmailController.clear();
                userAgeController.clear();
              },
            ),
          ],
        );
      },
    );
  }



  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Users'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(hintText: "name...."),
                ),

                TextField(
                  controller: _emailEditingController,
                  decoration: const InputDecoration(hintText: "email...."),
                ),

                TextField(
                  controller: _ageEditingController,
                  decoration: const InputDecoration(hintText: "age...."),
                ),
              ],
            ),
          ),
          actions: <Widget>[
        MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
        child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }
        ),


            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text('Ok'),
              onPressed: () {
                Todo todo = Todo(
                    name: _textEditingController.text,
                    email:_emailEditingController.text,
                    age: _ageEditingController.text,
                    isDone: false,
                    createdOn: Timestamp.now(),
                    updatedOn: Timestamp.now());
                _databaseService.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
                _emailEditingController.clear();
                _ageEditingController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
