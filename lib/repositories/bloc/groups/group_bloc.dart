import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repositories/models/group.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<AddGroup>(_onAddGroup);
    on<LoadGroups>(_onLoadGroups);
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    if (state is GroupLoaded) {
      final currentState = state as GroupLoaded;
      final updatedGroups = [...currentState.groups];
      emit(GroupLoaded(groups: updatedGroups));
    }
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());

    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      List<Group> groups = [];

      QuerySnapshot querySnapshot = await db.collection("groups").get();

      for (var doc in querySnapshot.docs) {
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('name')) {
            groups.add(Group(id: doc.id, name: data['name']));
          }
        }
      }
      emit(GroupLoaded(groups: groups));
    } catch (e) {
      emit(GroupError('Failed to load groups'));
    }
  }
}
