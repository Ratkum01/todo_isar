import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todo_tz/collections/routine.dart';
import 'package:todo_tz/widgets/task_widget.dart';

import 'create_routine_page.dart';
import 'update_routine_page.dart';

class HomePage extends StatefulWidget {
  final Isar isar;
  const HomePage({
    Key? key,
    required this.isar,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Routine>? routines;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool searching = false;

  @override
  void initState() {
    super.initState();
    _readRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TODO'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRoutinePage(isar: widget.isar),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : 
          SingleChildScrollView(
              controller: null,
              child: 
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                     
                      onChanged: searchRoutineByName,
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                        ),
                        hintText: 'Search....',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 5.0),
                  FutureBuilder<List<Widget>>(
                    future: _buildWidgets(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              clearAll();
            },
            child: const Text('Clear all'),
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> _buildWidgets() async {
    // this will load the data again
    if (!searching) {
      await _readRoutines();
    }

    List<Widget> x = [];

    for (int i = 0; i < routines!.length; i++) {
      x.add(
        Task_Widget(context: context, widget: widget, routines: routines, i: i),
      );
    }
    return x;
  }

  _readRoutines() async {
    final routineCollection = widget.isar.routines;
    final getRoutines = await routineCollection.where().findAll();

    setState(() {
      routines = getRoutines;
      isLoading = false;
    });
    // print(routines![0].title);
    // print(routines![0].startTimeRoutine);
    // print(routines!.length);
  }

  searchRoutineByName(String searchName) async {
    searching = true;
    final routineCollection = widget.isar.routines;
    final searchResults =
        await routineCollection.filter().titleContains(searchName).findAll();

    setState(() {
      routines = searchResults;
      isLoading = false;
    });
  }

  clearAll() async {
    final routineCollection = widget.isar.routines;
    final getRoutines = await routineCollection.where().findAll();

    await widget.isar.writeTxn((isar) async {
      for (var routine in getRoutines) {
        routineCollection.delete(routine.id);
      }
    });
    setState(() {});
  }
}


