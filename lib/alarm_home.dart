import 'package:flutter/material.dart';
import 'package:simple_clock_apps/alarm_add.dart';
import 'package:simple_clock_apps/alarm_card.dart';
import 'package:simple_clock_apps/data.dart' as data;

class AlarmHome extends StatefulWidget {
  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  List<data.AlarmInfo> alarms = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list of alarms here if needed
    alarms = data.alarm;
  }

  void addAlarm(data.AlarmInfo newAlarm) {
    setState(() {
      alarms.add(newAlarm);  // Update the local alarms list
      data.alarm = alarms;
    });
  }

  // Function to delete an alarm
  void deleteAlarm(data.AlarmInfo alarmToDelete) {
    setState(() {
      alarms.remove(alarmToDelete);
      data.alarm = alarms;
    });
  }

  // Function to edit an alarm
  void editAlarm(data.AlarmInfo alarmToEdit, String newDescription, TimeOfDay newTime) {
    setState(() {
      alarmToEdit.description = newDescription;
      alarmToEdit.alarmDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        newTime.hour,
        newTime.minute,
      );
      data.alarm = alarms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlarmCard(
        alarms: alarms,
        onDelete: deleteAlarm,
        onEdit: editAlarm,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AlarmAdd page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlarmAdd(addAlarm: addAlarm)), // Navigate to AlarmAdd page
          );
        },
        child: Icon(Icons.add), // Floating action button icon
      ),
    );
  }
}