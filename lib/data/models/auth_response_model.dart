//------approach 1:

// import 'package:doctor_appointment_app/core/utils/helper_methods.dart';
// import 'package:doctor_appointment_app/data/models/user_model.dart';
//
// class AuthResponse {
//   final String token;
//   final User user;
//   final bool status;
//   final int code;
//   final String message;
//
//   AuthResponse({
//     this.token = '',
//     required this.user,
//     this.status = false,
//     this.code = 0,
//     this.message = '',
//   });
//   factory AuthResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       print('AuthResponse raw JSON: $json');
//
//       // Safe parsing helpers
//       final dynamic statusValue = json['status'];
//       final bool status = statusValue == true || statusValue == 'true';
//       final int code = HelperMethods.parseInt(json['code']);
//
//       // Case 1: Handling Login response structure
//       if (json['data'] != null && json['data']['username'] != null) {
//         final data = json['data'] ?? {};
//         return AuthResponse(
//           token: data['token']?.toString() ?? '',
//           status: status,
//           code: code,
//           message: json['message']?.toString() ?? '',
//           user: User(
//             id: HelperMethods.parseInt(data['id']),
//             name: data['username']?.toString() ?? '',
//             email:
//                 data['username']?.toString() ??
//                 '',
//             phone: data['phone']?.toString() ?? '',
//             gender: HelperMethods.parseGender(
//               data['gender'],
//             ),
//           ),
//         );
//       }
//       // Case 2: Handling Signup response structure
//       else if (json['data'] != null) {
//         final data = json['data'];
//         return AuthResponse(
//           token: data['token']?.toString() ?? '',
//           status: status,
//           code: code,
//           message: json['message']?.toString() ?? '',
//           user: User(
//             id: HelperMethods.parseInt(data['id']),
//             name: data['email']?HelperMethods.extractNameFromEmail(data['email']) : '',
//             email: data['email']?.toString() ?? '',
//             phone: data['phone']?.toString() ?? '',
//             gender: HelperMethods.parseGender(data['gender']),
//           ),
//         );
//       }
//       // Fallback
//       return AuthResponse(
//         token:
//             json['token']?.toString() ??
//             json['data']?['token']?.toString() ??
//             '',
//         user: User.fromJson(json),
//         status: status,
//         code: code,
//         message: json['message']?.toString() ?? 'Unexpected response format',
//       );
//     } catch (e) {
//       print('AuthResponse parsing error: $e');
//       return AuthResponse(
//         token: '',
//         status: false,
//         code: 500,
//         message: 'Failed to parse response: $e',
//         user: User(id: null, name: 'User', email: '', phone: '', gender: null),
//       );
//     }
//   }
// }
//
// class ConnectionException implements Exception {
//   final String message;
//   ConnectionException({required this.message});
// }
//
// class ServerException implements Exception {
//   final String message;
//   ServerException({required this.message});
// }

//------approach 2:

import 'package:doctor_appointment_app/core/utils/helper_methods.dart';
import 'package:doctor_appointment_app/data/models/user_model.dart';

class AuthResponse {
  final String token;
  final User user;
  final bool status;
  final int code;
  final String message;

  AuthResponse({
    this.token = '',
    required this.user,
    this.status = false,
    this.code = 0,
    this.message = '',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Dio typically returns response.data as Map<String, dynamic> for JSON

    try {
      print('AuthResponse raw JSON: $json');

      // Extract fields safely
      final bool status = HelperMethods.parseTrueStatus(json['status']);
      final int code = HelperMethods.parseInt(json['code']);
      final String message = json['message']?.toString() ?? '';
      final dynamic data = json['data'];

      // Extract token from various possible locations
      final String token = HelperMethods.extractToken(json, data);

      // Build user from available data
      final User user = HelperMethods.buildUserFromData(data, json);

      return AuthResponse(
        token: token,
        user: user,
        status: status,
        code: code,
        message: message,
      );
    } catch (e) {
      print('AuthResponse parsing error: $e');
      return AuthResponse(
        token: '',
        status: false,
        code: 500,
        message: 'Failed to parse response: $e',
        user: User(id: null, name: 'User', email: '', phone: '', gender: null),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'status': status,
      'code': code,
      'message': message,
    };
  }
}
