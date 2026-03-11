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

class AddTask extends FamilyEvent {
  String uid;
  String groupId;
  String task;

  AddTask(this.uid, this.groupId, this.task);
}

class RemoveTask extends FamilyEvent {
  String uid;
  String groupId;
  String task;

  RemoveTask(this.uid, this.groupId, this.task);
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

class IncreaseManyCoins extends FamilyEvent {
  final String uid;
  final String groupId;
  final int award;

  IncreaseManyCoins(this.uid, this.groupId, this.award);
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
