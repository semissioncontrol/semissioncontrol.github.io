import 'package:flutter/material.dart';

import 'index.dart';
import 'projects.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IndexPage(),
        '/projects': (context) => ProjectsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
