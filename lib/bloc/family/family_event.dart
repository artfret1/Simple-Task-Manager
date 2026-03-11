part of 'family_bloc.dart';

abstract class FamilyEvent {}

class LoadFamily extends FamilyEvent {
  final String groupId;

  LoadFamily(this.groupId);
}

class UpdateMember extends FamilyEvent {
  String uid;
  int lvl;
  int coins;
  String groupId;

  UpdateMember(this.uid, this.lvl, this.coins, this.groupId);
}

class AddMemberByUid extends FamilyEvent {
  final String uid;

  AddMemberByUid(this.uid);
}

class IncreaseLvl extends FamilyEvent {
  final String uid;
  final String groupId;

  IncreaseLvl(this.uid, this.groupId);
}

class DecreaseLvl extends FamilyEvent {
  final String uid;
  final String groupId;

  DecreaseLvl(this.uid, this.groupId);
}

class IncreaseCoins extends FamilyEvent {
  final String uid;
  final String groupId;

  IncreaseCoins(this.uid, this.groupId);
}

class DecreaseCoins extends FamilyEvent {
  final String uid;
  final String groupId;

  DecreaseCoins(this.uid, this.groupId);
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
