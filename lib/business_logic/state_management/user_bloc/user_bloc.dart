import 'package:doctor_appointment_app/business_logic/state_management/user_bloc/user_event.dart';
import 'package:doctor_appointment_app/business_logic/state_management/user_bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../repositaries_interfaces/user_repo_interface.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryInterface repository;
  User? _currentUser;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    // on<UpdateUserProfilePartial>(_onUpdateUserProfilePartial);  // Add this
    on<UpdateUserFromAuth>(_onUpdateUserFromAuth);
    on<ClearUserProfile>(_onClearUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());

    try {
      final user = await repository.getUserProfile();
      _currentUser = user;
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event,
      Emitter<UserState> emit,
      ) async {
    // Show current user while updating
    if (_currentUser != null) {
      emit(UserUpdating(_currentUser!));
    } else {
      emit(UserLoading());
    }

    try {
      final updatedUser = await repository.updateUserProfile(
        name: event.name,
        email: event.email,
        phone: event.phone,
        gender: event.gender,  // Add this
        password: event.password,
      );

      _currentUser = updatedUser;
      emit(UserUpdateSuccess(updatedUser, 'Profile updated successfully'));

      // Transition to UserLoaded after showing success
      await Future.delayed(Duration(milliseconds: 500));
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError(e.toString()));

      // Restore previous user state if available
      if (_currentUser != null) {
        await Future.delayed(Duration(seconds: 2));
        emit(UserLoaded(_currentUser!));
      }
    }
  }
  //
  // Future<void> _onUpdateUserProfilePartial(
  //     UpdateUserProfilePartial event,
  //     Emitter<UserState> emit,
  //     ) async {
  //   if (_currentUser != null) {
  //     emit(UserUpdating(_currentUser!));
  //   } else {
  //     emit(UserLoading());
  //   }
  //
  //   try {
  //     final updatedUser = await repository.updateUserProfilePartial(
  //       updateData: event.updateData,
  //     );
  //
  //     _currentUser = updatedUser;
  //     emit(UserUpdateSuccess(updatedUser, 'Profile updated successfully'));
  //
  //     await Future.delayed(Duration(milliseconds: 500));
  //     emit(UserLoaded(updatedUser));
  //   } catch (e) {
  //     emit(UserError(e.toString()));
  //
  //     if (_currentUser != null) {
  //       await Future.delayed(Duration(seconds: 2));
  //       emit(UserLoaded(_currentUser!));
  //     }
  //   }
  // }

  void _onUpdateUserFromAuth(
      UpdateUserFromAuth event,
      Emitter<UserState> emit,
      ) {
    _currentUser = event.user;
    emit(UserLoaded(event.user));
  }

  void _onClearUserProfile(
      ClearUserProfile event,
      Emitter<UserState> emit,
      ) {
    _currentUser = null;
    emit(UserInitial());
  }
}