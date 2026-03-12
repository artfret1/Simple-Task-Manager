import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/features/family/models/member.dart';

class FamilyRepository {
  final FirebaseFirestore firestore;

  FamilyRepository(this.firestore);

  Future<List<Member>> loadFamily(String groupId) async {
    final groupDoc = await firestore.collection('groups').doc(groupId).get();

    if (!groupDoc.exists) return [];

    final data = groupDoc.data()!;
    final membersMap = Map<String, dynamic>.from(data['members'] ?? {});

    List<Member> members = [];

    for (var uid in membersMap.keys) {
      final userDoc = await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final userTasksSnapshot = await userDoc.reference
            .collection('usersgroups')
            .get();
        final Map<String, dynamic> userTasksMap = {};
        for (var taskDoc in userTasksSnapshot.docs) {
          userTasksMap[taskDoc.id] = taskDoc.data();
        }
        members.add(
          Member(
            uid: uid,
            name: userData['name'] ?? 'Unknown',
            firstName: userData['first_name'],
            secondName: userData['last_name'],
            email: userData['email'],
            groups: userTasksMap,
          ),
        );
      }
    }

    return members;
  }

  Future<Member?> findUserByUid(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data()!;

    return Member(
      uid: uid,
      name: data['name'],
      firstName: data['first_name'],
      secondName: data['last_name'],
      email: data['email'],
    );
  }

  Future<void> addMemberToGroup(String groupId, String uid) async {
    final groupRef = firestore.collection('groups').doc(groupId);
    await groupRef.update({
      'memberIds': FieldValue.arrayUnion([uid]),
    });
    await groupRef.update({'members.$uid': 'member'});

    // Создаем документ в подколлекции 'usersgroups' для нового пользователя
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('usersgroups')
        .doc(groupId)
        .set(<String, dynamic>{'coins': 0, 'lvl': 1});
  }

  Future<void> updateMemberStats(
    String uid,
    int lvl,
    int coins,
    String groupId,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('usersgroups')
        .doc(groupId)
        .update(<String, dynamic>{'coins': coins, 'lvl': lvl});
  }

  Future<void> addTask(String uid, String groupId, String task) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('usersgroups')
        .doc(groupId)
        .update({
          'tasks': FieldValue.arrayUnion([task]),
        });
  }

  Future<void> removeTask(String uid, String groupId, String task) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('usersgroups')
        .doc(groupId)
        .update({
          "tasks": FieldValue.arrayRemove([task]),
        });
  }
}
