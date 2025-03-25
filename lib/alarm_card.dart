import 'package:flutter/material.dart';
import 'package:simple_clock_apps/data.dart' as data;
import 'package:intl/intl.dart'; // For formatting date and time

class AlarmCard extends StatelessWidget {
  final List<data.AlarmInfo> alarms;
  final Function(data.AlarmInfo) onDelete;
  final Function(data.AlarmInfo, String, TimeOfDay) onEdit;

  AlarmCard({required this.alarms, required this.onDelete, required this.onEdit});

  // Function to show the edit dialog
  void _editAlarm(BuildContext context, data.AlarmInfo alarm) {
    TextEditingController descriptionController =
    TextEditingController(text: alarm.description);
    TimeOfDay time = TimeOfDay(
        hour: alarm.alarmDateTime.hour, minute: alarm.alarmDateTime.minute);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Alarm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Time'),
                subtitle: Text(time.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (newTime != null) {
                    time = newTime;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onEdit(alarm, descriptionController.text, time);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alarm',
              style: TextStyle(
                // fontFamily: ,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                // fontFamily: ,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: data.alarm.map((alarm){
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D2F41),
                      borderRadius: BorderRadius.all(Radius.circular(24))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    alarm.description ?? "",
                                    style: TextStyle(
                                      // fontFamily: ,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    )
                                ),
                                Text(
                                    "${alarm.alarmDateTime.hour}:${alarm.alarmDateTime.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      // fontFamily: ,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 40,
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    _editAlarm(context, alarm);
                                  },
                                  label: Text(''),
                                  icon: Icon(Icons.edit, size: 25),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    onDelete(alarm); // Delete the alarm
                                  },
                                  label: Text(''),
                                  icon: Icon(Icons.delete, size: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Switch(
                            value: alarm.isActive,
                            onChanged: (bool value) {
                              alarm.isActive = value; // Toggle the alarm's active status
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
