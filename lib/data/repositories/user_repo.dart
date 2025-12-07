import 'package:dio/dio.dart';

import '../../business_logic/repositaries_interfaces/user_repo_interface.dart';
import '../../core/exceptions.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepositoryInterface {
  final Dio dio;
  final String baseUrl;
  String? _authToken;

  UserRepositoryImpl({required this.baseUrl, String? authToken})
      : _authToken = authToken,
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            validateStatus: (status) => true,
          ),
        );

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, dynamic> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // @override
  // Future<User> getUserProfile() async {
  //   try {
  //     print('Fetching user profile from $baseUrl/user/profile');
  //
  //     final response = await dio.get(
  //       '/user/profile',
  //       options: Options(headers: _getHeaders()),
  //     );
  //
  //     print('User profile response: ${response.statusCode}');
  //
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //
  //       if (data is Map<String, dynamic>) {
  //         // Handle wrapped response
  //         if (data['data'] != null) {
  //           return User.fromJson(data['data']);
  //         }
  //         // Handle direct user object
  //         return User.fromJson(data);
  //       }
  //
  //       throw ServerException(message: 'Unexpected response format');
  //     } else if (response.statusCode == 401) {
  //       throw ServerException(
  //         message: 'Unauthorized - Please login again',
  //         statusCode: 401,
  //       );
  //     } else {
  //       throw ServerException(
  //         message: 'Failed to load profile: ${response.statusCode}',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       throw ServerException(
  //         message: 'Server error: ${e.response?.statusCode}',
  //         statusCode: e.response?.statusCode,
  //       );
  //     } else {
  //       throw ConnectionException(message: 'Network error: ${e.message}');
  //     }
  //   }
  // }
  @override
  Future<User> getUserProfile() async {
    try {
      print('Fetching user profile from $baseUrl/user/profile');

      final response = await dio.get(
        '/user/profile',
        options: Options(headers: _getHeaders()),
      );

      print('User profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final userData = data['data'];

          // FIX: Handle List response
          if (userData is List && userData.isNotEmpty) {
            print('✅ User data is List, extracting first item');
            return User.fromJson(userData[0] as Map<String, dynamic>);
          }
          // Handle Map response
          else if (userData is Map<String, dynamic>) {
            print('✅ User data is Map');
            return User.fromJson(userData);
          }
          // Handle direct user object (no 'data' wrapper)
          else if (data['id'] != null) {
            print('✅ User data in root');
            return User.fromJson(data);
          }
        }

        throw ServerException(message: 'Unexpected response format');
      } else if (response.statusCode == 401) {
        throw ServerException(
          message: 'Unauthorized - Please login again',
          statusCode: 401,
        );
      } else {
        throw ServerException(
          message: 'Failed to load profile: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    }
  }

  // @override
  // Future<User> updateUserProfile({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   String? password,
  // }) async {
  //   try {
  //     print('Updating user profile at $baseUrl/user/update');
  //
  //     final requestData = {
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //       if (password != null && password.isNotEmpty) 'password': password,
  //     };
  //
  //     final response = await dio.put(
  //       '/user/update',
  //       data: requestData,
  //       options: Options(headers: _getHeaders()),
  //     );
  //
  //     print('Update response: ${response.statusCode}');
  //
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //
  //       if (data is Map<String, dynamic>) {
  //         // Handle wrapped response
  //         if (data['data'] != null) {
  //           return User.fromJson(data['data']);
  //         }
  //         // Handle direct user object
  //         return User.fromJson(data);
  //       }
  //
  //       throw ServerException(message: 'Unexpected response format');
  //     } else if (response.statusCode == 401) {
  //       throw ServerException(
  //         message: 'Unauthorized - Please login again',
  //         statusCode: 401,
  //       );
  //     } else if (response.statusCode == 422) {
  //       final errors = response.data['errors'] ?? response.data['data'] ?? {};
  //       String errorMessage = 'Validation failed: ';
  //
  //       if (errors is Map) {
  //         errors.forEach((field, messages) {
  //           if (messages is List) {
  //             errorMessage += '${messages.join(', ')}. ';
  //           }
  //         });
  //       }
  //
  //       throw ServerException(
  //         message: errorMessage,
  //         statusCode: 422,
  //       );
  //     } else {
  //       throw ServerException(
  //         message: 'Failed to update profile: ${response.statusCode}',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       throw ServerException(
  //         message: 'Server error: ${e.response?.statusCode}',
  //         statusCode: e.response?.statusCode,
  //       );
  //     } else {
  //       throw ConnectionException(message: 'Network error: ${e.message}');
  //     }
  //   }
  // }
  // @override
  // Future<User> updateUserProfile({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required int gender,
  //   String? password,
  // }) async {
  //   try {
  //     print('Updating user profile at $baseUrl/user/update');
  //
  //     final requestData = {
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //       if (password != null && password.isNotEmpty) 'password': password,
  //     };
  //
  //     final response = await dio.post(
  //       '/user/update',
  //       data: requestData,
  //       options: Options(headers: _getHeaders()),
  //     );
  //
  //     print('Update response: ${response.statusCode}');
  //
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //
  //       if (data is Map<String, dynamic>) {
  //         final userData = data['data'];
  //
  //         // FIX: Handle List response
  //         if (userData is List && userData.isNotEmpty) {
  //           print('✅ Updated user data is List, extracting first item');
  //           return User.fromJson(userData[0] as Map<String, dynamic>);
  //         }
  //         // Handle Map response
  //         else if (userData is Map<String, dynamic>) {
  //           print('✅ Updated user data is Map');
  //           return User.fromJson(userData);
  //         }
  //         // Handle direct user object
  //         else if (data['id'] != null) {
  //           print('✅ Updated user data in root');
  //           return User.fromJson(data);
  //         }
  //       }
  //
  //       throw ServerException(message: 'Unexpected response format');
  //     } else if (response.statusCode == 401) {
  //       throw ServerException(
  //         message: 'Unauthorized - Please login again',
  //         statusCode: 401,
  //       );
  //     } else if (response.statusCode == 422) {
  //       final errors = response.data['errors'] ?? response.data['data'] ?? {};
  //       String errorMessage = 'Validation failed: ';
  //
  //       if (errors is Map) {
  //         errors.forEach((field, messages) {
  //           if (messages is List) {
  //             errorMessage += '${messages.join(', ')}. ';
  //           }
  //         });
  //       }
  //
  //       throw ServerException(
  //         message: errorMessage,
  //         statusCode: 422,
  //       );
  //     } else {
  //       throw ServerException(
  //         message: 'Failed to update profile: ${response.statusCode}',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       throw ServerException(
  //         message: 'Server error: ${e.response?.statusCode}',
  //         statusCode: e.response?.statusCode,
  //       );
  //     } else {
  //       throw ConnectionException(message: 'Network error: ${e.message}');
  //     }
  //   }
  // }
  @override
  Future<User> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required int gender,
    String? password,
  }) async {
    try {
      print('Updating user profile at $baseUrl/user/update');

      // Clean phone number (remove spaces, dashes, plus signs)
      final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\+]'), '');

      final requestData = {
        'name': name,
        'email': email.toLowerCase(),
        'phone': cleanPhone,
        'gender': gender,
        if (password != null && password.isNotEmpty) 'password': password,
        if (password != null && password.isNotEmpty) 'password_confirmation': password,
      };

      print('📤 Request data: $requestData');

      final response = await dio.post(
        '/user/update',
        data: requestData,
        options: Options(headers: _getHeaders()),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final userData = data['data'];

          // Handle List response
          if (userData is List && userData.isNotEmpty) {
            print('✅ Updated user data is List, extracting first item');
            return User.fromJson(userData[0] as Map<String, dynamic>);
          }
          // Handle Map response
          else if (userData is Map<String, dynamic>) {
            print('✅ Updated user data is Map');
            return User.fromJson(userData);
          }
          // Handle direct user object
          else if (data['id'] != null) {
            print('✅ Updated user data in root');
            return User.fromJson(data);
          }
        }

        throw ServerException(message: 'Unexpected response format');
      } else if (response.statusCode == 401) {
        throw ServerException(
          message: 'Unauthorized - Please login again',
          statusCode: 401,
        );
      } else if (response.statusCode == 422) {
        print('❌ 422 Validation error - Full response:');
        print(response.data);

        // Try multiple possible error formats
        dynamic errors;

        // Format 1: { "errors": { "field": ["message"] } }
        if (response.data['errors'] != null) {
          errors = response.data['errors'];
        }
        // Format 2: { "data": { "field": ["message"] } }
        else if (response.data['data'] != null) {
          errors = response.data['data'];
        }
        // Format 3: { "message": "error message" }
        else if (response.data['message'] != null) {
          throw ServerException(
            message: response.data['message'].toString(),
            statusCode: 422,
          );
        }

        String errorMessage = 'Validation failed:\n';

        if (errors is Map) {
          print('❌ Errors map: $errors');
          errors.forEach((field, messages) {
            print('❌ Field "$field" has errors: $messages');
            if (messages is List) {
              for (var msg in messages) {
                errorMessage += '• $msg\n';
              }
            } else if (messages is String) {
              errorMessage += '• $messages\n';
            }
          });
        } else if (errors is String) {
          errorMessage = errors;
        } else {
          errorMessage = 'Validation failed. Please check your input.\n\nFull response: ${response.data}';
        }

        print('❌ Final error message: $errorMessage');

        throw ServerException(
          message: errorMessage.trim(),
          statusCode: 422,
        );
      } else {
        throw ServerException(
          message: 'Failed to update profile: ${response.statusCode}\n${response.data}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('❌ DioException in updateUserProfile: ${e.message}');
      print('❌ DioException response: ${e.response?.data}');

      if (e.response != null) {
        throw ServerException(
          message: 'Server error: ${e.response?.statusCode} - ${e.response?.data}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected error in updateUserProfile: $e');
      rethrow;
    }
  }
}