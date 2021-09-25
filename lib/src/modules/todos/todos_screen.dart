import 'package:flutter/material.dart';
import 'package:skeleton_test/src/modules/settings/settings_view.dart';

import 'list_todos_item.dart';
import 'todos_controller.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key}) : super(key: key);

  static const routeName = '/todos-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListTodosItem(
        controller: TodosController(),
      ),
    );
  }
}
