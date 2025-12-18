import 'package:doctor_appointment_app/business_logic/state_management/user_bloc/user_event.dart';
import 'package:doctor_appointment_app/business_logic/state_management/user_bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/exceptions.dart';
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
        gender: event.gender,
        password: event.password,
      );

      _currentUser = updatedUser;
      emit(UserUpdateSuccess(updatedUser, 'Profile updated successfully'));

      // Transition to UserLoaded after showing success
      await Future.delayed(Duration(milliseconds: 500));
      emit(UserLoaded(updatedUser));
    }
    on UnauthorizedException {
      emit(UserError('Your session expired. Please log in again.'));
    } on ValidationException catch (e) {
      final message = _buildValidationMessage(e.errors);
      emit(UserError(message));
      _restoreUserAfterDelay();
    } on NetworkException catch (e) {
      final message = _getNetworkErrorMessage(e.type);
      emit(UserError(message));
      _restoreUserAfterDelay();
    } on ServerException catch (e) {
      emit(UserError(
        'Server error (${e.statusCode}). Please try again.',
      ));
      _restoreUserAfterDelay();
    } catch (e) {
      emit(UserError('Unexpected error. Please contact support.'));
      _restoreUserAfterDelay();
    }
  }

  Future<void> _restoreUserAfterDelay() async {
    if (_currentUser != null) {
      await Future.delayed(Duration(seconds: 2));
      emit(UserLoaded(_currentUser!));
    }
  }

  String _buildValidationMessage(Map<String, dynamic> errors) {
    final messages = <String>[];

    errors.forEach((field, msgs) {
      if (msgs is List && msgs.isNotEmpty) {
        final fieldName = _humanizeFieldName(field);
        for (var msg in msgs) {
          messages.add('• $fieldName: $msg');
        }
      }
    });

    return messages.isEmpty
        ? 'Validation failed. Please check your input.'
        : 'Please fix these issues:\n${messages.join('\n')}';
  }

  String _humanizeFieldName(String field) {
    // Convert "phone_number" → "Phone Number"
    return field
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getNetworkErrorMessage(NetworkExceptionType type) {
    switch (type) {
      case NetworkExceptionType.timeout:
        return 'Request timed out. Check your connection.';
      case NetworkExceptionType.noConnection:
        return 'No internet connection. Please try again.';
      case NetworkExceptionType.serverError:
        return 'Server issues. Please try again later.';
    }
  }
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