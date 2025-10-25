import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../core/utils/validators.dart'; // Optional if you have a phone validator
import '../../core/app_colors/app_colors.dart'; // Your color constants

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: 'GB',
      showCountryFlag: true,
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black54,
      ),
      dropdownTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Your number',
        labelStyle: const TextStyle(
          color: Color.fromRGBO(194, 194, 194, 1),
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1,
            color: Color.fromRGBO(194, 194, 194, 1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.blue,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 1.5, color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
      validator: (phone) => Validators.validatePhoneNumber(phone?.number),
      onChanged: (phone) {
        onChanged?.call(phone.completeNumber);
      },
    );
  }
}
