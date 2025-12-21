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
        cardTheme: const CardThemeData(
          color: Color(0xFF1A1B1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111113),
          elevation: 0,
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
  bool loading = false;
  String resultText = 'Response will appear here';

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

  Future<void> _run(Future<dynamic> Function() action) async {
    setState(() => loading = true);
    final res = await action();
    setState(() {
      loading = false;
      resultText = res.toString();
    });
  }

  Widget actionTile(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
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
        title: const Text('Profscode CRUD Demo'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),

              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                actionTile(
                  'GET Users',
                  Ionicons.download_outline,
                  () => _run(
                    () => crud.getRequest(
                      'https://jsonplaceholder.typicode.com/users',
                    ),
                  ),
                ),
                actionTile(
                  'POST User',
                  Ionicons.add_circle_outline,
                  () => _run(
                    () => crud.postRequest(
                      'https://jsonplaceholder.typicode.com/users',
                      {'name': 'John Doe'},
                    ),
                  ),
                ),
                actionTile(
                  'PUT User',
                  Ionicons.reload_outline,
                  () => _run(
                    () => crud.putRequest(
                      'https://jsonplaceholder.typicode.com/users/1',
                      {'name': 'Jane'},
                    ),
                  ),
                ),
                actionTile(
                  'PATCH User',
                  Ionicons.build_outline,
                  () => _run(
                    () => crud.patchRequest(
                      'https://jsonplaceholder.typicode.com/users/1',
                      {'email': 'new@mail.com'},
                    ),
                  ),
                ),
                actionTile(
                  'DELETE User',
                  Ionicons.trash_outline,
                  () => _run(
                    () => crud.deleteRequest(
                      'https://jsonplaceholder.typicode.com/users/1',
                    ),
                  ),
                ),
                actionTile(
                  'HEAD Request',
                  Ionicons.eye_outline,
                  () => _run(
                    () => crud.headRequest(
                      'https://jsonplaceholder.typicode.com/users',
                    ),
                  ),
                ),
                actionTile(
                  'OPTIONS',
                  Ionicons.help_circle_outline,
                  () => _run(
                    () => crud.optionsRequest(
                      'https://jsonplaceholder.typicode.com/users',
                    ),
                  ),
                ),
                actionTile(
                  'UPLOAD File',
                  Ionicons.cloud_upload_outline,
                  () => _run(
                    () => crud.fileRequest(
                      'https://example.com/upload',
                      fields: {},
                      files: [],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// RESPONSE AREA
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        resultText,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      ),
                    ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Text(
                  'Profscode CRUD Package',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'github.com/Ahmedhafiz33',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
