import '../../../data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserUpdating extends UserState {
  final User currentUser; // Keep showing current user while updating

  UserUpdating(this.currentUser);
}

class UserUpdateSuccess extends UserState {
  final User user;
  final String message;

  UserUpdateSuccess(this.user, this.message);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}