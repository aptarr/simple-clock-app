import 'package:flutter/material.dart';

import 'notification_service.dart';

class AlarmAdd extends StatefulWidget {
  final Function(DateTime, String?) addAlarm;

  AlarmAdd({required this.addAlarm});

  @override
  _AlarmAddState createState() => _AlarmAddState();
}

class _AlarmAddState extends State<AlarmAdd> {
  // Controllers to hold input values
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController _descriptionController = TextEditingController();


  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  // Function to save the alarm
  void _saveAlarm() async {
    final alarmDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _time.hour,
      _time.minute,
    );
    widget.addAlarm(alarmDateTime, _descriptionController.text);

    await NotificationService.createNotification(
      id: alarmDateTime.millisecondsSinceEpoch ~/ 1000,
      title: 'Alarm',
      body: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : 'Your alarm is ringing!',
      scheduled: true,
      interval: alarmDateTime.difference(DateTime.now()),
    );

    Navigator.pop(context);
  }

  // Function to cancel the operation (for now, just pop the screen)
  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 10),  // Set the margin here
              child: Text(
                'Add New Alarm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Time Picker
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D2F41),
                borderRadius: BorderRadius.circular(10), // Set the radius for rounded corners
                border: Border.all(width: 1), // Optional: Border color and width
              ),
              margin: EdgeInsets.only(top: 30, bottom: 10),
              child: ListTile(
                title: Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                ),
                subtitle: Text(
                  '${_time.format(context)}',
                  style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.access_time, color: Colors.white, size: 40,),
                onTap: () => _selectTime(context),
              ),
            ),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2, // border width
                  ),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),

            // Buttons (Save and Cancel)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: _cancel,
                    child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.deepPurpleAccent,
                          width: 2, // border width
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Space between the buttons
                  // Save Button
                  ElevatedButton(
                    onPressed: _saveAlarm,
                    child: Text(
                        'Save Alarm',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White color for Save
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
