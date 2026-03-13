import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/group.dart';
import '../repository/group_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  // BLoC управляет списком групп пользователя через репозиторий.
  final GroupRepository repository;
  GroupBloc(this.repository) : super(GroupsInitial()) {
    // Регистрируем обработчики CRUD-операций над группами.
    on<AddGroup>(_onAddGroup);
    on<LoadGroups>(_onLoadGroups);
    on<RenameGroup>(_onRenameGroup);
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    try {
      await repository.addGroup(event.groupName);

      // После добавления перечитываем актуальный список из репозитория.
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
      // Синхронизируем UI со свежими данными после переименования.
      final groups = await repository.getGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    // Явно сигнализируем о загрузке, чтобы экран мог показать прогресс.
    emit(GroupsLoading());

    try {
      final groups = await repository.getGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError('Failed to load groups'));
    }
  }
}
