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
  final String memberName;

  IncreaseLvl(this.memberName);
}

class DecreaseLvl extends FamilyEvent {
  final String memberName;

  DecreaseLvl(this.memberName);
}

class IncreaseCoins extends FamilyEvent {
  final String memberName;

  IncreaseCoins(this.memberName);
}

class DecreaseCoins extends FamilyEvent {
  final String memberName;

  DecreaseCoins(this.memberName);
}

class SetEditingMember extends FamilyEvent {
  final String? memberName;

  SetEditingMember(this.memberName);
}
