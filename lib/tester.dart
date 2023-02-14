import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'KindaCode.com',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KindaCode.com')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const TextField(),
            const SizedBox(height: 30),
            MediaQuery.of(context).viewInsets.bottom == 0
                ? const Text(
                    'Keyboard is hidden',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  )
                : const Text(
                    'Keyboard is visible',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  )
          ],
        ),
      ),
    );
  }
}
