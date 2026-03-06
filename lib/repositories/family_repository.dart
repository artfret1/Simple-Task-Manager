import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/member.dart';

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

        members.add(
          Member(
            uid: uid,
            name: userData['name'] ?? 'Unknown',
            lvl: userData['lvl'] ?? 1,
            coins: userData['coins'] ?? 0,
            firstName: userData['first_name'],
            secondName: userData['last_name'],
            email: userData['email'],
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
      lvl: data['lvl'],
      coins: data['coins'],
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
  }

  Future<void> updateMemberStats(String uid, int lvl, int coins) async {
    await firestore.collection('users').doc(uid).update({
      'lvl': lvl,
      'coins': coins,
    });
  }
}
