import '../../../data/models/user_model.dart';

abstract class UserEvent {}

class LoadUserProfile extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final String name;
  final String email;
  final String phone;
  final int gender;
  final String? password;

  UpdateUserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.password, required this.gender,
  });
}

class UpdateUserFromAuth extends UserEvent {
  final User user;

  UpdateUserFromAuth(this.user);
}

class UpdateUserProfilePartial extends UserEvent {
  final Map<String, dynamic> updateData;

  UpdateUserProfilePartial({required this.updateData});
}

class ClearUserProfile extends UserEvent {}