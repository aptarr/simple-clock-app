import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmInfo {
  final String id;
  final DateTime time;
  final String? description;
  final bool isActive;

  AlarmInfo({required this.id, required this.time, this.description, this.isActive = true});

  factory AlarmInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlarmInfo(
      id: doc.id,
      time: (data['time'] as Timestamp).toDate(),
      description: data['description'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'time': Timestamp.fromDate(time),
      'description': description,
      'isActive': isActive,
    };
  }
}
//
// List<AlarmInfo> alarm = [
//   AlarmInfo(DateTime.now().add(Duration(hours: 1)), description: 'Kelas IMK'),
//   AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: ''),
//   AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Kelas PPB')
// ];
