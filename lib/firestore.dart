import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';

class FirestoreService{

  final alarms = FirebaseFirestore.instance.collection('alarms');

  Future<void> addAlarm(DateTime time, String? description) {
    return alarms.add({
      'time': Timestamp.fromDate(time),
      'description': description ?? '',
      'isActive': true,
    });
  }

  Future<void> deleteAlarm(String id) => alarms.doc(id).delete();

  Future<void> updateAlarm(String id, {required DateTime time, required String? description}) {
    return alarms.doc(id).update({
      'time': Timestamp.fromDate(time),
      'description': description,
    });
  }

  Future<void> toggleAlarm(String id, bool isActive) {
    return alarms.doc(id).update({'isActive': isActive});
  }

  Stream<List<AlarmInfo>> getAlarmsStream() {
    return alarms.orderBy('time').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AlarmInfo.fromFirestore(doc)).toList());
  }
}