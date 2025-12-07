import '../../data/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<User> getUserProfile();
  Future<User> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required int gender,
    String? password,
  });
  // Future<User> updateUserProfilePartial({
  //   required Map<String, dynamic> updateData,
  // });
}