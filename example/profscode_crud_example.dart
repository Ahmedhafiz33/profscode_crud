import 'package:flutter/material.dart';
import 'package:profscode_crud/profscode_crud.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profscode CRUD Example',
      home: const CrudExamplePage(),
    );
  }
}

class CrudExamplePage extends StatefulWidget {
  const CrudExamplePage({super.key});

  @override
  State<CrudExamplePage> createState() => _CrudExamplePageState();
}

class _CrudExamplePageState extends State<CrudExamplePage> {
  late Crud crud;
  String resultText = 'Press a button to make a request';

  @override
  void initState() {
    super.initState();

    // Initialize the CRUD instance with custom headers and optional token refresh
    crud = Crud(
      headersProvider: () => {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        'Content-Type': 'application/json',
      },
      onRefreshToken: () async {
        // Optional: implement token refresh logic
        print('Refreshing token...');
        await Future.delayed(const Duration(seconds: 1));
        // Return true if token refreshed successfully
        return true;
      },
    );
  }

  Future<void> _getUsers() async {
    final response = await crud.getRequest(
      'https://jsonplaceholder.typicode.com/users',
    );
    setState(() {
      resultText = 'GET Response: ${response.toString()}';
    });
  }

  Future<void> _createUser() async {
    final data = {'name': 'John Doe', 'email': 'john@example.com'};
    final response = await crud.postRequest(
      'https://jsonplaceholder.typicode.com/users',
      data,
    );
    setState(() {
      resultText = 'POST Response: ${response.toString()}';
    });
  }

  Future<void> _updateUser() async {
    final data = {'name': 'Jane Doe'};
    final response = await crud.putRequest(
      'https://jsonplaceholder.typicode.com/users/1',
      data,
    );
    setState(() {
      resultText = 'PUT Response: ${response.toString()}';
    });
  }

  Future<void> _deleteUser() async {
    final response = await crud.deleteRequest(
      'https://jsonplaceholder.typicode.com/users/1',
    );
    setState(() {
      resultText = 'DELETE Response: ${response.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profscode CRUD Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getUsers,
              child: const Text('GET Users'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('POST User'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('PUT User'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteUser,
              child: const Text('DELETE User'),
            ),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(resultText))),
          ],
        ),
      ),
    );
  }
}
