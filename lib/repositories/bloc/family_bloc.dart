import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc() : super(FamilyInitial()) {
    on<LoadFamily>(_onLoadFamily);
    on<AddMember>(_onAddMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
    on<SetEditingMember>(_onSetEditingMember);
    on<IncreaseLvl>(_onIncreaseLvl);
    on<DecreaseLvl>(_onDecreaseLvl);
    on<IncreaseCoins>(_onIncreaseCoins);
    on<DecreaseCoins>(_onDecreaseCoins);
  }

  Future<void> _onLoadFamily(
    LoadFamily event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      emit(
        FamilyLoaded(members: [], familyName: 'Family', editingMember: null),
      );
    } catch (e) {
      emit(FamilyError('Failed to load family'));
    }
  }

  Future<void> _onAddMember(AddMember event, Emitter<FamilyState> emit) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = [...currentState.members, event.member];
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: currentState.editingMember,
        ),
      );
    }
  }

  Future<void> _onUpdateMember(
    UpdateMember event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members.map((member) {
        if (member.name == event.oldName) {
          return event.updatedMember;
        }
        return member;
      }).toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: null,
        ),
      );
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

  Future<void> _onIncreaseLvl(
    IncreaseLvl event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members.map((member) {
        if (member.name == event.memberName) {
          return Member(
            name: member.name,
            lvl: member.lvl + 1,
            coins: member.coins,
          );
        }
        return member;
      }).toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: currentState.editingMember,
        ),
      );
    }
  }

  Future<void> _onDecreaseLvl(
    DecreaseLvl event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members.map((member) {
        if (member.name == event.memberName) {
          return Member(
            name: member.name,
            lvl: (member.lvl - 1) < 1 ? 1 : (member.lvl - 1),
            coins: member.coins,
          );
        }
        return member;
      }).toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: currentState.editingMember,
        ),
      );
    }
  }

  Future<void> _onIncreaseCoins(
    IncreaseCoins event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members.map((member) {
        if (member.name == event.memberName) {
          return Member(
            name: member.name,
            lvl: member.lvl,
            coins: member.coins + 1,
          );
        }
        return member;
      }).toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: currentState.editingMember,
        ),
      );
    }
  }

  Future<void> _onDecreaseCoins(
    DecreaseCoins event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final updatedMembers = currentState.members.map((member) {
        if (member.name == event.memberName) {
          return Member(
            name: member.name,
            lvl: member.lvl,
            coins: (member.coins - 1) < 0 ? 0 : (member.coins - 1),
          );
        }
        return member;
      }).toList();
      emit(
        FamilyLoaded(
          members: updatedMembers,
          familyName: currentState.familyName,
          editingMember: currentState.editingMember,
        ),
      );
    }
  }

  Future<void> _onSetEditingMember(
    SetEditingMember event,
    Emitter<FamilyState> emit,
  ) async {
    if (state is FamilyLoaded) {
      final currentState = state as FamilyLoaded;
      final newEditing = currentState.editingMember == event.memberName
          ? null
          : event.memberName;
      emit(
        FamilyLoaded(
          members: currentState.members,
          familyName: currentState.familyName,
          editingMember: newEditing,
        ),
      );
    }
  }
}
