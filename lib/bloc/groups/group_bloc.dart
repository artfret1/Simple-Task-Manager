import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/repositories/group_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository repository;
  GroupBloc(this.repository) : super(GroupsInitial()) {
    on<AddGroup>(_onAddGroup);
    on<LoadGroups>(_onLoadGroups);
    on<RenameGroup>(_onRenameGroup);
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    try {
      await repository.addGroup(event.groupName);

      final groups = await repository.getGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onRenameGroup(
    RenameGroup event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await repository.renameGroup(event.groupID, event.newName);
      final groups = await repository.getGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupsLoading());

    try {
      final groups = await repository.getGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError('Failed to load groups'));
    }
  }
}
