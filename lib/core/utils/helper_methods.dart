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

  static bool parseStatus(dynamic statusValue) {
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
    // If data is a Map with user information
    if (data is Map) {
      final dataMap = Map<String, dynamic>.from(data);
      return User(
        id: HelperMethods.parseInt(dataMap['id']),
        name: _extractName(dataMap),
        email: _extractEmail(dataMap),
        phone: dataMap['phone']?.toString() ?? '',
        gender: HelperMethods.parseGender(dataMap['gender']),
      );
    }

    // If data is empty or invalid, try to extract from root
    return User(
      id: HelperMethods.parseInt(json['id']),
      name: _extractName(json),
      email: _extractEmail(json),
      phone: json['phone']?.toString() ?? '',
      gender: HelperMethods.parseGender(json['gender']),
    );
  }

  static String _extractName(Map<String, dynamic> data) {
    // Priority: name -> username -> email -> fallback
    return data['name']?.toString() ??
        data['username']?.toString() ??
        extractNameFromEmail(data['email']?.toString()) ??
        'User';
  }

  static String _extractEmail(Map<String, dynamic> data) {
    // Priority: email -> username -> fallback
    return data['email']?.toString() ?? data['username']?.toString() ?? '';
  }
}