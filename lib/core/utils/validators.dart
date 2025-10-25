class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove spaces, dashes, parentheses, etc.
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Basic check: digits only
    if (!RegExp(r'^[0-9+]+$').hasMatch(cleanedValue)) {
      return 'Phone number can only contain digits and + sign';
    }

    // Optional: accept international formats starting with +
    if (cleanedValue.startsWith('+')) {
      // e.g., +1234567890 → at least 10 digits total
      if (cleanedValue.length < 11 || cleanedValue.length > 15) {
        return 'Enter a valid international phone number';
      }
    } else {
      // Local phone number (no +): must be 10 digits
      if (cleanedValue.length != 10) {
        return 'Phone number must be 10 digits';
      }
    }

    return null;
  }
}
