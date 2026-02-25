part of 'family_bloc.dart';

abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final List<Member> members;
  final String familyName;
  final String? editingMember;

  FamilyLoaded({
    required this.members,
    required this.familyName,
    this.editingMember,
  });
}

class FamilyError extends FamilyState {
  final String message;

  FamilyError(this.message);
}
