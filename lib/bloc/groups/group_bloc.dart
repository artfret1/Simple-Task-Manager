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
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    if (state is GroupsLoaded) {
      final currentState = state as GroupsLoaded;
      final updatedGroups = [...currentState.groups];
      emit(GroupsLoaded(groups: updatedGroups));
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
