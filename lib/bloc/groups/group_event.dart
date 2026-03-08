part of 'group_bloc.dart';

abstract class GroupEvent {}

class LoadGroups extends GroupEvent {}

class AddGroup extends GroupEvent {
  final String groupName;

  AddGroup(this.groupName);
}

class UpdateGroup extends GroupEvent {
  final String groupID;
  final String oldName;
  final String newName;

  UpdateGroup(this.groupID, this.oldName, this.newName);
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  DeleteGroup(this.groupId);
}
