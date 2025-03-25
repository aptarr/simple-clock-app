class AlarmInfo {
  DateTime alarmDateTime;
  String? description;
  bool isActive;

  AlarmInfo(this.alarmDateTime, {this.description, this.isActive = true});
}

List<AlarmInfo> alarm = [
  AlarmInfo(DateTime.now().add(Duration(hours: 1)), description: 'Kelas IMK'),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: ''),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Kelas PPB')
];
