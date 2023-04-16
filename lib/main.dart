import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_tz/pages/home_page.dart';

import 'collections/category.dart';
import 'collections/routine.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory(); // permanent directory
  final isar = await Isar.open(
    schemas: [RoutineSchema, CategorySchema],
    directory: dir.path,
  );
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({
    Key? key,
    required this.isar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO ISAR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(isar: isar),
    );
  }
}
