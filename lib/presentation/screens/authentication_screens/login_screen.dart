import 'package:doctor_appointment_app/business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import 'package:doctor_appointment_app/core/app_colors/app_colors.dart';
import 'package:doctor_appointment_app/presentation/screens/authentication_screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_bloc.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_event.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_state.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../core/dependency_injection/injection_container.dart';
import '../../../core/helper_widgets/custom_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/screen_wrapper/main_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // if (state is AuthLoading) {
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) =>
          //         const Center(child: CircularProgressIndicator()),
          //   );
          // }
          // else if (state is AuthSuccess) {
          //   Navigator.pop(context);
          //   SnackBarHelper.show(
          //     context,
          //     'Login successful!',
          //     type: SnackBarType.success,
          //   );
          // }
           if (state is AuthError) {
            // Navigator.pop(context);
            SnackBarHelper.show(
              context,
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 1 / 8,
            horizontal: width * 0.08,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.boldPrimaryColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "We're excited to have you back, can't wait to "
                  "see what you've been up to since you last"
                  " logged in.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                ),
                const SizedBox(height: 25),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                value: _rememberMe,
                                side: BorderSide(
                                  color: AppColors.greyText1,
                                  width: 2,
                                ),
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return AppColors.boldPrimaryColor;
                                      }
                                      return Colors.white;
                                    }),
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.greyText1,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                SnackBarHelper.show(
                                  context,
                                  'New password has been sent to your mail!',
                                  type: SnackBarType.success,
                                );
                              } else {
                                SnackBarHelper.show(
                                  context,
                                  'Please fix the errors in red.',
                                  type: SnackBarType.error,
                                );
                              }
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.faintPrimaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
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
                              LoginEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          } else {
                            SnackBarHelper.show(
                              context,
                              'Please fix the errors in red.',
                              type: SnackBarType.error,
                            );
                          }
                        },
                        child: Text(
                          'Login',
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
                            "  Or sign in with  ",
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
                        text: "By logging, you agree to our ",
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
                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) {
                      //       return SignUp();
                      //       },
                      //   ),
                      // );
                      context.read<AuthBloc>().add(ShowSignupScreen());
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Don\'t have an account yet? ',
                        children: [
                          TextSpan(
                            text: "Sign Up",
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
                      ),
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
