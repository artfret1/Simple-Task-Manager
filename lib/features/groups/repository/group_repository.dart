import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/groups/models/group.dart';

class GroupRepository {
  final FirebaseFirestore firestore;

  GroupRepository(this.firestore);

  Future<List<Group>> getGroups() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    final snapshot = await firestore
        .collection('groups')
        .where('memberIds', arrayContains: currentUserId)
        .get();

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

  Future<void> addGroup(String name) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('groups')
        .add(<String, dynamic>{
          'name': name,
          'memberIds': [currentUserId],
          'members': {currentUserId: "admin"},
        });

    // Получаем ID только что созданной группы
    String newGroupId = groupRef.id;

    // Создаем документ в подколлекции 'usersgroups' для текущего пользователя
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('usersgroups')
        .doc(newGroupId)
        .set(<String, dynamic>{'coins': 0, 'lvl': 1});
  }

  Future<void> renameGroup(String groupId, String newName) async {
    final docRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
    docRef.update({'name': newName});
  }
}
