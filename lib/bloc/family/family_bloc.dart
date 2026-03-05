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
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
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

  Future<void> _onUpdateMember(
    UpdateMember event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is! FamilyLoaded) return;

    try {
      final currentState = state as FamilyLoaded;

      // сохраняем изменения в Firestore
      await repository.updateMemberStats(
        event.updatedMember.uid,
        event.updatedMember.lvl,
        event.updatedMember.coins,
      );

      // перезагружаем список участников группы
      final members = await repository.loadFamily(groupId!);

      emit(
        FamilyLoaded(
          members: members,
          familyName: currentState.familyName,
          editingMember: null,
        ),
      );
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
          editingMember: null,
        ),
      );
    }
  }
}
