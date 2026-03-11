part of 'family_bloc.dart';

abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final List<Member> members;
  final String familyName;
  final String? editingMemberUid;

  final int? tempLvl;
  final int? tempCoins;

  FamilyLoaded({
    required this.members,
    required this.familyName,
    this.editingMemberUid,
    this.tempLvl,
    this.tempCoins,
  });

  FamilyLoaded copyWith({
    List<Member>? members,
    String? familyName,
    String? editingMemberUid,
    int? tempLvl,
    int? tempCoins,
  }) {
    return FamilyLoaded(
      members: members ?? this.members,
      familyName: familyName ?? this.familyName,
      editingMemberUid: editingMemberUid ?? this.editingMemberUid,
      tempLvl: tempLvl ?? this.tempLvl,
      tempCoins: tempCoins ?? this.tempCoins,
    );
  }
}

class FamilyError extends FamilyState {
  final String message;

  FamilyError(this.message);
}
