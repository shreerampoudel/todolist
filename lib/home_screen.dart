import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/todo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  TextEditingController ctodoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      //color
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        //color
        backgroundColor: const Color.fromARGB(255, 96, 112, 121),
        title: const Text("Todo App", style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 230, 0))),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          AddorUpdateTodo(context, todoProvider, true, "", 0);
        },
      ),
      body: ListView.builder(
        itemCount: todoProvider.todos.length,
        itemBuilder: (BuildContext ctx, int index) {
          return ListTile(
            leading: Checkbox(
              value: todoProvider.todos[index].isDone,
              onChanged: (bool? value) {
                todoProvider.todos[index].isDone = value!;
              },
              activeColor: const Color.fromARGB(255, 123, 255, 0),
            ),
            title: Text(
              todoProvider.todos[index].title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    AddorUpdateTodo(
                      context, todoProvider, false, todoProvider.todos[index].title, index);
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    todoProvider.delete(index);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> AddorUpdateTodo(
    BuildContext context, TodoProvider todoProvider, bool isAdded, String text, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ctodoText.text = text;

    // Retrieve the last saved todo
    String? lastTodo = prefs.getString('myKey');

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isAdded ? const Text('Add Todo') : const Text("Update Todo"),
          content: TextField(
            controller: ctodoText,
            decoration: const InputDecoration(hintText: "Enter todo", labelText: "Enter todo"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.headline6),
              child: const Text('Save'),
              onPressed: () {
                if (isAdded) {
                  todoProvider.add(ctodoText.text);
                } else {
                  todoProvider.edit(index, ctodoText.text);
                }

                // Save the new/updated todo to shared preferences
                prefs.setString('myKey', ctodoText.text);
                ctodoText.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.headline6),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
