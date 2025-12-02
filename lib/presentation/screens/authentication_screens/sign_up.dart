import 'package:doctor_appointment_app/business_logic/state_management/auth_bloc/authentication_bloc.dart';
import 'package:doctor_appointment_app/business_logic/state_management/auth_bloc/authentication_state.dart';
import 'package:doctor_appointment_app/core/utils/validators.dart';
import 'package:doctor_appointment_app/presentation/screens/authentication_screens/login_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_event.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../../core/app_colors/app_colors.dart';
import '../../../core/dependency_injection/injection_container.dart';
import '../../../core/helper_widgets/custom_snackbar.dart';
import '../../widgets/screen_wrapper/main_nav_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  int? _selectedGender; // 1 = male, 2 = female, null = not selected

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      //makes the keyboard act as another layer on top of the page, so that it doesn't screw the height of page or cause an overflow error.
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // if (state is AuthLoading) {
          //   // Show loading dialog
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) =>
          //         const Center(child: CircularProgressIndicator()),
          //   );
          // } else if (state is AuthSuccess) {
          //   // Hide loading and navigate
          //   Navigator.pop(context); // Close loading dialog
          //   SnackBarHelper.show(
          //     context,
          //     'Account created successfully!',
          //     type: SnackBarType.success,
          //   );
          // }
          if (state is AuthError) {
            // Hide loading and show error
            Navigator.pop(context); // Close loading dialog
            SnackBarHelper.show(
              context,
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 1 / 9,
            horizontal: width * 0.08,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.boldPrimaryColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Sign up now and start exploring all that our"
                  "app has to offer. We're excited to welcome"
                  " you to our community!",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                ),
                const SizedBox(height: 25),
                //form takes a key, and the key is declared BEFORE the build as GlobalKey<FormState>().
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(194, 194, 194, 1),
                            fontWeight: FontWeight.w500,
                          ),
                          // By default, Flutter only shows the border color when the field is enabled but not focused.
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(194, 194, 194, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color:
                                  Colors.blue, // highlight color when focused
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(194, 194, 194, 1),
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(194, 194, 194, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.red,
                            ),
                          ),
                          // suffix icon for seeing or hiding the password text value, and toggling in a setState.
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 15),
                      PhoneInputField(controller: _phoneController),
                      const SizedBox(height: 15),
                      // Gender Selection
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedGender == null
                                ? Color.fromRGBO(194, 194, 194, 1)
                                : Colors.blue,
                            width: _selectedGender == null ? 1 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(194, 194, 194, 1),
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                // Male Option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedGender = 0;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedGender == 0
                                            ? AppColors.boldPrimaryColor
                                                  .withOpacity(0.1)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: _selectedGender == 0
                                              ? AppColors.boldPrimaryColor
                                              : Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.male,
                                            color: _selectedGender == 0
                                                ? AppColors.boldPrimaryColor
                                                : Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Male',
                                            style: TextStyle(
                                              color: _selectedGender == 0
                                                  ? AppColors.boldPrimaryColor
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Female Option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedGender = 1;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedGender == 1
                                            ? AppColors.boldPrimaryColor
                                                  .withOpacity(0.1)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: _selectedGender == 1
                                              ? AppColors.boldPrimaryColor
                                              : Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.female,
                                            color: _selectedGender == 1
                                                ? AppColors.boldPrimaryColor
                                                : Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Female',
                                            style: TextStyle(
                                              color: _selectedGender == 1
                                                  ? AppColors.boldPrimaryColor
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: AppColors.boldPrimaryColor,
                          foregroundColor: AppColors.backgroundWhite,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              SignUpEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                gender: _selectedGender!,
                                name: _emailController.text
                                    .trim()
                                    .split('@')
                                    .first,
                                passwordConfirmation: _passwordController.text,
                              ),
                            );
                            print("successful data");
                          } else {
                            SnackBarHelper.show(
                              context,
                              'Please fix the errors in red.',
                              type: SnackBarType.error,
                            );
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                          Text(
                            "  Or sign up with  ",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.greyText1,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.5 * 0.3,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/login_and_signup_screens/google_icon.png",
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    Container(
                      width: width * 0.5 * 0.3,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/login_and_signup_screens/fb_icon.png",
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    Container(
                      width: width * 0.5 * 0.3,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/login_and_signup_screens/apple_icon.png",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 37),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25,
                  ),
                  child: Center(
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: "By registering, you agree to our ",
                        style: TextStyle(
                          color: AppColors.greyText1,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: "and ",
                            style: TextStyle(
                              color: AppColors.greyText1,
                              fontSize: 11,
                            ),
                            children: [
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: AppColors.boldPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        height: 1.8,
                      ),
                      // strutStyle: StrutStyle(
                      //   forceStrutHeight: true,
                      //   height: 1.8, // Ensures consistent height
                      //   leading: 0.5, // Extra space for descenders
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
