import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/member.dart';
import 'package:task_manager/repositories/family_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamilyRepository repository;

  String? groupId;

  FamilyBloc(this.repository) : super(FamilyInitial()) {
    on<LoadFamily>(_loadFamily);
    on<AddMemberByUid>(_addMember);
    on<DeleteMember>(_onDeleteMember);
    on<SetEditingMember>(_setEditingMember);
  }

  void _setEditingMember(SetEditingMember event, Emitter<FamilyState> emit) {
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;

    emit(
      FamilyLoaded(
        members: current.members,
        familyName: current.familyName,
        editingMemberUid: event.uid,
      ),
    );
  }

  Future<void> _loadFamily(LoadFamily event, Emitter<FamilyState> emit) async {
    try {
      emit(FamilyLoading());

      groupId = event.groupId;

      final members = await repository.loadFamily(event.groupId);

      emit(FamilyLoaded(members: members, familyName: "Группа"));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _addMember(
    AddMemberByUid event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      if (groupId == null) return;

      // Получаем текущий список участников
      final currentMembers = state is FamilyLoaded
          ? (state as FamilyLoaded).members
          : [];

      // Проверка, чтобы не добавить дважды
      final existing = currentMembers.any((m) => m.uid == event.uid);
      if (existing) {
        emit(FamilyError("Пользователь уже в группе"));
        return;
      }

      final member = await repository.findUserByUid(event.uid);

      if (member == null) {
        emit(FamilyError("Пользователь не найден"));
        return;
      }

      // Добавляем в Firestore
      await repository.addMemberToGroup(groupId!, event.uid);

      // Загружаем актуальный список
      final members = await repository.loadFamily(groupId!);

      emit(FamilyLoaded(members: members, familyName: "Группа"));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onDeleteMember(
    DeleteMember event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members
          .where((member) => member.name != event.memberName)
          .toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMemberUid: currentState.editingMemberUid,
        ),
      );
    }
  }
}
