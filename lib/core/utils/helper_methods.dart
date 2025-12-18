import 'package:flutter/cupertino.dart';

import '../../data/models/user_model.dart';

class HelperMethods {
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  //Issue: when data is Map, Dart treats it as Map<dynamic, dynamic> rather than Map<String, dynamic>.
  //Solution: convert it using Map<String, dynamic>.from(data) before passing it to the helper methods that expect Map<String, dynamic>.
  static String? parseGender(dynamic gender) {
    if (gender == null) return null;
    if (gender is String) return gender;
    if (gender is int) {
      return gender == 1 ? 'male' : 'female';
    }
    return gender.toString();
  }

  static String extractNameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'User';
    return email.split('@').first;
  }

  static bool parseTrueStatus(dynamic statusValue) {
    return statusValue == true || statusValue == 'true';
  }

  static String extractToken(Map<String, dynamic> json, dynamic data) {
    // Try data.token first (most common)
    if (data is Map && data['token'] != null) {
      return data['token'].toString();
    }
    // Try root-level token
    if (json['token'] != null) {
      return json['token'].toString();
    }
    return '';
  }

  static User buildUserFromData(dynamic data, Map<String, dynamic> json) {
    debugPrint('🔍 === buildUserFromData DEBUG ===');
    debugPrint('🔍 data type: ${data.runtimeType}');
    debugPrint('🔍 data value: $data');
    debugPrint('🔍 json type: ${json.runtimeType}');
    debugPrint('🔍 json value: $json');

    // Handle List response
    if (data is List) {
      debugPrint('✅ Detected List with ${data.length} items');
      if (data.isNotEmpty) {
        final firstItem = data[0];
        debugPrint('✅ First item type: ${firstItem.runtimeType}');
        debugPrint('✅ First item value: $firstItem');

        if (firstItem is Map<String, dynamic>) {
          debugPrint('✅ Creating User from first item');
          return User(
            id: HelperMethods.parseInt(firstItem['id']),
            name: firstItem['name']?.toString() ?? 'User',
            email: firstItem['email']?.toString() ?? '',
            phone: firstItem['phone']?.toString() ?? '',
            gender: HelperMethods.parseGender(firstItem['gender']),
          );
        } else {
          debugPrint('❌ First item is not a Map! Type: ${firstItem.runtimeType}');
        }
      } else {
        debugPrint('❌ List is empty!');
      }
    }

    // Handle Map response
    if (data is Map) {
      debugPrint('✅ Detected Map, creating User');
      final dataMap = Map<String, dynamic>.from(data);
      final name = dataMap['name']?.toString() ??
          dataMap['username']?.toString() ??  // ADD THIS LINE
          'User';

      debugPrint('✅ Found name/username: $name');

      return User(
        id: HelperMethods.parseInt(dataMap['id']),
        name: name,
        email: dataMap['email']?.toString() ?? '',
        phone: dataMap['phone']?.toString() ?? '',
        gender: HelperMethods.parseGender(dataMap['gender']),
      );
    }

    debugPrint('❌ Could not parse data, using fallback');
    return const User(
      id: null,
      name: 'User',
      email: '',
      phone: '',
      gender: null,
    );
  }
  static String _extractName(Map<String, dynamic> data) {
    // Check both "name" and "username" fields
    return data['name']?.toString() ??
        data['username']?.toString() ??  // ADD THIS
        extractNameFromEmail(data['email']?.toString()) ??
        'User';
  }

  static String _extractEmail(Map<String, dynamic> data) {
    // Priority: email -> username -> fallback
    return data['email']?.toString() ?? data['username']?.toString() ?? '';
  }
}