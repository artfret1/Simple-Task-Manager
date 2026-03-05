part of 'group_bloc.dart';

abstract class GroupState {}

class GroupsInitial extends GroupState {}

class GroupsLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<Group> groups;

  GroupsLoaded({required this.groups});
}

class GroupsError extends GroupState {
  final String message;

  GroupsError(this.message);
}
