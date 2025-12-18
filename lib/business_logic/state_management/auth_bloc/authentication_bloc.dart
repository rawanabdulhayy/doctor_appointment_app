import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dependency_injection/token_provider.dart';
import '../../../core/exceptions.dart';
import '../../../data/models/auth_response_model.dart';
import '../../usecases/auth_usecases/login_usecase.dart';
import '../../usecases/auth_usecases/signup_usecase.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final AuthTokenProvider tokenProvider;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.tokenProvider,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<ShowLoginScreen>(_onShowLoginScreen);
    on<ShowSignupScreen>(_onShowSignupScreen);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      //but the use case doesn't even receive an email or a password in its constructor, so how come? (answered in the usecase file)
      final authResponse = await loginUseCase(event.email, event.password);
      tokenProvider.setToken(authResponse.token);
      emit(AuthSuccess(authResponse: authResponse));
      // Catch the ServerException from repository
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } on ConnectionException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      debugPrint('BLoC: Unexpected error during login: $e');
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authResponse = await signUpUseCase(
        event.email,
        event.password,
        event.phone,
        event.gender,
        event.name,
        event.passwordConfirmation,
      );
      tokenProvider.setToken(authResponse.token);
      emit(AuthSuccess(authResponse: authResponse));
      //successful response in bloc
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } on ConnectionException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      debugPrint('BLoC: Unexpected error during signup: $e');
      emit(AuthError(message: 'Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onShowLoginScreen (ShowLoginScreen event, Emitter<AuthState> emit) async{
    emit(AuthShowLogin());
  }

  Future<void> _onShowSignupScreen (ShowSignupScreen event, Emitter<AuthState> emit) async{
    emit(AuthShowSignup());
  }
}

// Current AuthBloc stores:
// What's Currently Stored
// 1. In the BLoC State (AuthSuccess)
// emit(AuthSuccess(authResponse: authResponse));
// When login/signup succeeds, the state contains:
//
// authResponse.token - JWT token
// authResponse.user - User object (id, name, email, phone, gender)
// authResponse.status, authResponse.code, authResponse.message
//
// 2. In the TokenProvider
// tokenProvider.setToken(authResponse.token);