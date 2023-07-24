import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(title: "Go to work"),
    Todo(title: "Learn Flutter"),
    Todo(title: "Make app"),
    Todo(title: "Go To Home"),
  ];

  List<Todo> get todos => _todos;

  void add(String todo) {
    _todos.add(Todo(title: todo));
    notifyListeners();
  }

  void delete(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void edit(int index, String text) {
    _todos[index].title = text;
    notifyListeners();
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });
}
