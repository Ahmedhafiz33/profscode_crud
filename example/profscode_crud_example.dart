import 'package:flutter/material.dart';
import 'package:profscode_crud/profscode_crud.dart';
import 'package:ionicons/ionicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4F46E5),
          secondary: Color(0xFF9333EA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111113),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1B1E),
          elevation: 4,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
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

    crud = Crud(
      headersProvider: () => {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        'Content-Type': 'application/json',
      },
      onRefreshToken: () async {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      },
    );
  }

  Future<void> _getUsers() async {
    final response = await crud.getRequest(
      'https://jsonplaceholder.typicode.com/users',
    );
    setState(() => resultText = 'GET Response: $response');
  }

  Future<void> _postUser() async {
    final data = {'name': 'John Doe', 'email': 'john@example.com'};
    final response = await crud.postRequest(
      'https://jsonplaceholder.typicode.com/users',
      data,
    );
    setState(() => resultText = 'POST Response: $response');
  }

  Future<void> _putUser() async {
    final data = {'name': 'Jane Doe'};
    final response = await crud.putRequest(
      'https://jsonplaceholder.typicode.com/users/1',
      data,
    );
    setState(() => resultText = 'PUT Response: $response');
  }

  Future<void> _patchUser() async {
    final data = {'email': 'newmail@example.com'};
    final response = await crud.patchRequest(
      'https://jsonplaceholder.typicode.com/users/1',
      data,
    );
    setState(() => resultText = 'PATCH Response: $response');
  }

  Future<void> _deleteUser() async {
    final response = await crud.deleteRequest(
      'https://jsonplaceholder.typicode.com/users/1',
    );
    setState(() => resultText = 'DELETE Response: $response');
  }

  Future<void> _headRequest() async {
    final response = await crud.headRequest(
      'https://jsonplaceholder.typicode.com/users',
    );
    setState(() => resultText = 'HEAD Response: $response');
  }

  Future<void> _optionsRequest() async {
    final response = await crud.optionsRequest(
      'https://jsonplaceholder.typicode.com/users',
    );
    setState(() => resultText = 'OPTIONS Response: $response');
  }

  Future<void> _uploadFile() async {
    final response = await crud.fileRequest(
      'https://example.com/upload',
      fields: {},
      files: [],
    );
    setState(() => resultText = 'UPLOAD Response: $response');
  }

  Widget actionButton(String label, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 26, color: Colors.white),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profscode CRUD Example'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            actionButton('GET Users', Ionicons.download_outline, _getUsers),
            actionButton('POST User', Ionicons.add_circle_outline, _postUser),
            actionButton('PUT User', Ionicons.reload_outline, _putUser),
            actionButton('PATCH User', Ionicons.build_outline, _patchUser),
            actionButton(
              'DELETE User',
              Ionicons.trash_bin_outline,
              _deleteUser,
            ),
            actionButton('HEAD Request', Ionicons.eye_outline, _headRequest),
            actionButton(
              'OPTIONS Request',
              Ionicons.help_circle_outline,
              _optionsRequest,
            ),
            actionButton(
              'UPLOAD File',
              Ionicons.cloud_upload_outline,
              _uploadFile,
            ),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(resultText))),
            const SizedBox(height: 20),
            const Divider(height: 30, color: Colors.white30),
            const Text(
              'For questions or suggestions:',
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 10),
            const Text(
              'Website: http://ahmedhafiz.com.tr',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 6),
            const Text(
              'Instagram: @ahmedhafiz.33',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const Text(
              'GitHub: github.com/Ahmedhafiz33',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
