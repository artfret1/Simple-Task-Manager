part of 'family_bloc.dart';

abstract class FamilyEvent {}

class LoadFamily extends FamilyEvent {
  final String groupId;

  LoadFamily(this.groupId);
}

class AddMemberByUid extends FamilyEvent {
  final String uid;

  AddMemberByUid(this.uid);
}

class AddGroup extends FamilyEvent {
  final String groupName;

  AddGroup(this.groupName);
}

class DeleteMember extends FamilyEvent {
  final String memberName;

  DeleteMember(this.memberName);
}

class SetEditingMember extends FamilyEvent {
  final String uid;

  SetEditingMember(this.uid);
}
