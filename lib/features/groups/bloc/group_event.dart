part of 'group_bloc.dart';

abstract class GroupEvent {}

class LoadGroups extends GroupEvent {}

class AddGroup extends GroupEvent {
  final String groupName;

  AddGroup(this.groupName);
}

class RenameGroup extends GroupEvent {
  final String groupID;
  final String newName;

  RenameGroup(this.groupID, this.newName);
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  DeleteGroup(this.groupId);
}
