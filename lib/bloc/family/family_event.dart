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

class UpdateMember extends FamilyEvent {
  final Member updatedMember;

  UpdateMember(this.updatedMember);
}

class DeleteMember extends FamilyEvent {
  final String memberName;

  DeleteMember(this.memberName);
}

class IncreaseLvl extends FamilyEvent {
  final String uid;

  IncreaseLvl(this.uid);
}

class DecreaseLvl extends FamilyEvent {
  final String uid;

  DecreaseLvl(this.uid);
}

class IncreaseCoins extends FamilyEvent {
  final String uid;

  IncreaseCoins(this.uid);
}

class DecreaseCoins extends FamilyEvent {
  final String uid;

  DecreaseCoins(this.uid);
}

class SetEditingMember extends FamilyEvent {
  final String uid;

  SetEditingMember(this.uid);
}
