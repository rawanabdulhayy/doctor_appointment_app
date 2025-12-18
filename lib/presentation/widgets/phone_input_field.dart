import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../core/utils/validators.dart'; // Optional if you have a phone validator
import '../../core/app_colors/app_colors.dart'; // Your color constants

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: 'GB',
      showCountryFlag: true,
      dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1,
            color: errorText != null ? Colors.red : Color.fromRGBO(194, 194, 194, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1.5,
            color: errorText != null ? Colors.red : Colors.blue,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 1.5, color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
      ),
      //validation not working?
      // IntlPhoneField is not a FormField - It doesn't automatically report validation errors to the parent Form
      // Form validation doesn't reach it - When you call formKey.currentState!.validate(), it only validates fields that are FormField widgets
      // Your validator returns errors but they're not displayed - The validator runs, but the error isn't shown in the UI

      // "When needing to validate, call the parent's function with your validation string result."
      // validator: validator ?? (phone) => Validators.validatePhoneNumber(phone?.number),
      validator: (PhoneNumber? phone) {
        // If parent provided a validator, use it with the phone number
        if (validator != null) {
          //THE ACTUAL EXPLICIT CALL, like onTap: () => onTimeSelected(time).
          return validator!(phone?.number);
        }
        // Otherwise use default validation
        if (phone == null || phone.number.isEmpty) {
          return 'Please enter a phone number';
        }
        return null;
      },

      //the widget's onChanged receives a phone parameter - contains phone number data (from a phone number input widget)
      //then uses ?.call() to safely invoke the parent's (the widget used/called in the main page) onChanged function only if it's not null
      //then extracts phone.completeNumber (passed parameter + countryCode) and passes only the formatted/complete phone number string to the parent
      onChanged: (phone) {
        onChanged?.call(phone.completeNumber);
      },
    );
  }
}

// // Parent widget
// PhoneInputField(
// onChanged: (formattedNumber) {
// print("Formatted number: $formattedNumber");
// // formattedNumber might be "+1 (555) 123-4567"
// },
// )
//
// // Inside PhoneInputField widget
// onChanged: (phone) {
// onChanged?.call(phone.completeNumber);
// // phone.completeNumber contains the formatted version
// }

// are each of both parent's and child's parameters senders AND receivers? otherwise how does the child KNOW about the value from the parent's to work with?
// and the type conversion/adaptation in the parameters, how does that work? the parent called the child's validator to do some work, work is done and passes phone.number as a string to the parent's callback and calls it to work, then the parent's call the helper validator with the passed phone number from child?
// and about the .call when the child uses it to call the parent's callback after processing and performing the work, is it the only way in which the parent's callback can be called? is it specific to when there is a value to be passed?
// and is (onTap: () => onTimeSelected(time)) and (return validator!(phone?.number);) explicit child calls analogous to onChanged?.call(phone.completeNumber);?
