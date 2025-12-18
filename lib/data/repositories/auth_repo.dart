import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../business_logic/repositaries_interfaces/auth_repo_interface.dart';
import '../../core/exceptions.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepositoryInterface {
  final Dio dio;

  AuthRepositoryImpl({required String baseUrl})
      : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // validateStatus: (status) {
      //   return status! < 500; // Accepting all status codes below 500, to be able to show the user the kinda error he is coming across.
      // },
      validateStatus: (status) => status == null ? false : status < 500,
    ),
  );

  @override
  Future<AuthResponse> login(String email, String password) async {
    debugPrint('Login attempt for: $email');

    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    debugPrint('Login response status: ${response.statusCode}');
    debugPrint('Login response data: ${response.data}');

    // Handling successful response
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    }
    // Handling validation errors (422)
    else if (response.statusCode == 422) {
      final errors = response.data['data'] ?? {};
      String errorMessage = 'Login failed: ';

      errors.forEach((field, messages) {
        if (messages is List) {
          errorMessage += '${messages.join(', ')}. ';
        }
      });
      throw ServerException(message: errorMessage.trim());
    }
    // Handling unauthorized errors (401) - invalid credentials
    else if (response.statusCode == 401) {
      final message = response.data['message'] ?? 'Invalid email or password';
      throw ServerException(message: message);
    }
    // Handling other errors
    else {
      throw ServerException(message: 'Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Future<AuthResponse> signUp(String email, String password, String phone, int gender, String name, String passwordConfirmation) async {
    debugPrint('Signup attempt for: $email, phone: $phone');

    final response = await dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'phone': phone,
        'gender': gender,
        'name': name,
        'password_confirmation': passwordConfirmation,
      },
    );

    debugPrint('Signup response status: ${response.statusCode}');
    debugPrint('Signup response data: ${response.data}');

    // Handling successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(response.data);
    }
    // Handling validation errors (422)
    else if (response.statusCode == 422) {
      final errors = response.data['data'] ?? {};
      String errorMessage = 'Signup failed: ';

      errors.forEach((field, messages) {
        if (messages is List) {
          errorMessage += '${messages.join(', ')}. ';
        }
      });

      throw ServerException(message: errorMessage.trim());
    }
    // Handling other errors
    else {
      throw ServerException(message: 'Signup failed with status: ${response.statusCode}');
    }
  }
}