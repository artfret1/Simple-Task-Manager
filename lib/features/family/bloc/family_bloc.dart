import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/member.dart';
import '../repository/family_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  // Репозиторий отвечает за чтение/запись данных группы в хранилище.
  final FamilyRepository repository;

  // Активная группа в контексте текущего экрана.
  String? groupId;

  FamilyBloc(this.repository) : super(FamilyInitial()) {
    // Подключаем обработчики пользовательских действий и CRUD-операций.
    on<LoadFamily>(_loadFamily);
    on<AddMemberByUid>(_addMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
    on<IncreaseLvl>(_increaseLvl);
    on<DecreaseLvl>(_decreaseLvl);
    on<IncreaseCoins>(_increaseCoins);
    on<DecreaseCoins>(_decreaseCoins);
    on<SetEditingMember>(_setEditingMember);
    on<AddTask>(_addTask);
    on<RemoveTask>(_removeTask);
    on<IncreaseManyCoins>(_increaseManyCoins);
  }

  void _setEditingMember(SetEditingMember event, Emitter<FamilyState> emit) {
    // Редактирование доступно только после успешной загрузки состава группы.
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;

    final member = current.members.firstWhere((m) => m.uid == event.uid);
    final groupData = member.groups?[groupId] ?? {"lvl": 0, "coins": 0};

    emit(
      current.copyWith(
        editingMemberUid: event.uid,
        tempLvl: groupData["lvl"],
        tempCoins: groupData["coins"],
      ),
    );
  }

  void _increaseLvl(IncreaseLvl event, Emitter<FamilyState> emit) {
    // Изменяем временные значения локально до сохранения в репозиторий.
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;

    emit(current.copyWith(tempLvl: (current.tempLvl ?? 0) + 1));
  }

  void _decreaseLvl(DecreaseLvl event, Emitter<FamilyState> emit) {
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;
    if ((current.tempLvl ?? 0) <= 0) return;

    emit(current.copyWith(tempLvl: (current.tempLvl ?? 0) - 1));
  }

  void _increaseCoins(IncreaseCoins event, Emitter<FamilyState> emit) {
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;
    emit(current.copyWith(tempCoins: (current.tempCoins ?? 0) + 1));
  }

  void _increaseManyCoins(IncreaseManyCoins event, Emitter<FamilyState> emit) {
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;
    emit(current.copyWith(tempCoins: (current.tempCoins ?? 0) + event.award));
  }

  void _decreaseCoins(DecreaseCoins event, Emitter<FamilyState> emit) {
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;
    if ((current.tempCoins ?? 0) <= 0) return;

    emit(current.copyWith(tempCoins: (current.tempCoins ?? 0) - 1));
  }

  Future<void> _addTask(AddTask event, Emitter<FamilyState> emit) async {
    // После изменения задач перечитываем семейный список для консистентности UI.
    if (state is! FamilyLoaded) return;

    try {
      await repository.addTask(event.uid, event.groupId, event.task);

      // Загружаем актуальный список
      final members = await repository.loadFamily(groupId!);

      emit(FamilyLoaded(members: members, familyName: "Группа"));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _removeTask(RemoveTask event, Emitter<FamilyState> emit) async {
    if (state is! FamilyLoaded) return;

    try {
      await repository.removeTask(event.uid, event.groupId, event.task);

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
    // Сохраняем отредактированные значения и закрываем режим редактирования.
    if (state is! FamilyLoaded) return;

    final current = state as FamilyLoaded;

    await repository.updateMemberStats(
      event.uid,
      current.tempLvl ?? 0,
      current.tempCoins ?? 0,
      event.groupId,
    );

    final members = await repository.loadFamily(groupId!);

    emit(
      FamilyLoaded(
        members: members,
        familyName: current.familyName,
        editingMemberUid: null,
      ),
    );
  }

  Future<void> _loadFamily(LoadFamily event, Emitter<FamilyState> emit) async {
    try {
      // Явно отражаем загрузку, чтобы экран мог показать прогресс.
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
    // Локально удаляем участника из текущего состояния экрана.
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
