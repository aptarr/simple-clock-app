import 'package:flutter/material.dart';
import 'package:simple_clock_apps/alarm_add.dart';
import 'package:simple_clock_apps/alarm_card.dart';
import 'package:simple_clock_apps/data.dart' as data;
import 'firestore.dart';

class AlarmHome extends StatefulWidget {
  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<data.AlarmInfo>>(
        stream: firestoreService.getAlarmsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final alarms = snapshot.data!;
          return AlarmCard(
            alarms: alarms,
            onDelete: (alarm) => firestoreService.deleteAlarm(alarm.id),
            onEdit: (alarm, newDescription, newTime) => firestoreService.updateAlarm(
              alarm.id,
              time: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                newTime.hour,
                newTime.minute,
              ),
              description: newDescription,
            ),
            onActive: (alarm) => firestoreService.toggleAlarm(alarm.id, !alarm.isActive),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmAdd(
                addAlarm: (DateTime time, String? description) =>
                    firestoreService.addAlarm(time, description),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
