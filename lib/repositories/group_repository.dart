import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/group.dart';

class GroupRepository {
  final FirebaseFirestore firestore;

  GroupRepository(this.firestore);

  Future<List<Group>> getGroups() async {
    final snapshot = await firestore.collection('groups').get();

    return snapshot.docs.map((doc) {
      final membersMap = Map<String, dynamic>.from(doc['members'] ?? {});

      String adminUid = '';

      membersMap.forEach((uid, role) {
        if (role == 'admin') {
          adminUid = uid;
        }
      });

      return Group(id: doc.id, name: doc['name'] ?? '', admin: adminUid);
    }).toList();
  }
}
