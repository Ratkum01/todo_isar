import 'package:flutter/material.dart';
import 'package:todo_tz/collections/routine.dart';
import 'package:todo_tz/pages/home_page.dart';
import 'package:todo_tz/pages/update_routine_page.dart';
class Task_Widget extends StatelessWidget {
  const Task_Widget({
    Key? key,
    required this.context,
    required this.widget,
    required this.routines,
    required this.i,
  }) : super(key: key);

  final BuildContext context;
  final HomePage widget;
  final List<Routine>? routines;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: 
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateRoutinePage(
                isar: widget.isar,
                routine: routines![i],
              ),
            ),
          );
        },
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routines![i].title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: RichText(
                  text: TextSpan(
                    style:
                        const TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.schedule,
                          size: 16,
                        ),
                      ),
                      TextSpan(text: " ${routines![i].startTimeRoutine}")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: RichText(
                  text: TextSpan(
                    style:
                        const TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.calendar_month,
                          size: 16,
                        ),
                      ),
                      TextSpan(text: " ${routines![i].day}")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}