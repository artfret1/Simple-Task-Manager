import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group.dart';

class GroupRepository {
  // Репозиторий инкапсулирует все операции с группами в Firestore.
  final FirebaseFirestore firestore;

  GroupRepository(this.firestore);

  Future<List<Group>> getGroups() async {
    // Загружаем только те группы, в которых состоит текущий пользователь.
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    final snapshot = await firestore
        .collection('groups')
        .where('memberIds', arrayContains: currentUserId)
        .get();

    return snapshot.docs.map((doc) {
      final membersMap = Map<String, dynamic>.from(doc['members'] ?? {});

      // Ищем uid администратора группы по роли 'admin'.
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
    // Создатель группы автоматически становится её администратором.
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('groups')
        .add(<String, dynamic>{
          'name': name,
          'memberIds': [currentUserId],
          'members': {currentUserId: "admin"},
        });

    // Сохраняем id новой группы для последующей инициализации.
    String newGroupId = groupRef.id;

    // Создаём стартовую запись участника в контексте новой группы.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('usersgroups')
        .doc(newGroupId)
        .set(<String, dynamic>{'coins': 0, 'lvl': 1});
  }

  Future<void> renameGroup(String groupId, String newName) async {
    // Обновляем только поле имени без перезаписи всего документа.
    final docRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
    docRef.update({'name': newName});
  }
}
