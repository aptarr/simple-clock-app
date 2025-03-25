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
    alarms = data.alarm;
  }

  void addAlarm(data.AlarmInfo newAlarm) {
    setState(() {
      alarms.add(newAlarm);
      data.alarm = alarms;
    });
  }

  void deleteAlarm(data.AlarmInfo alarmToDelete) {
    setState(() {
      alarms.remove(alarmToDelete);
      data.alarm = alarms;
    });
  }

  void editAlarm(data.AlarmInfo alarmToEdit, String newDescription, TimeOfDay newTime) {
    setState(() {
      int index = alarms.indexOf(alarmToEdit);
      alarms[index] = data.AlarmInfo(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, newTime.hour, newTime.minute),
        description: newDescription,
      );
      data.alarm = alarms;
    });
  }

  void activeAlarm(data.AlarmInfo alarmToActive) {
    setState(() {
      alarmToActive.isActive = !alarmToActive.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlarmCard(
        alarms: alarms,
        onDelete: deleteAlarm,
        onEdit: editAlarm,
        onActive: activeAlarm,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlarmAdd(addAlarm: addAlarm)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
