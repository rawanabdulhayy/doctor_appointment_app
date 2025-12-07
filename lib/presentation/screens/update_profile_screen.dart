import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../business_logic/state_management/user_bloc/user_bloc.dart';
import '../../business_logic/state_management/user_bloc/user_event.dart';
import '../../business_logic/state_management/user_bloc/user_state.dart';
import '../../core/app_colors/app_colors.dart';
import '../../core/dependency_injection/injection_container.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserBloc>()..add(LoadUserProfile()),
      child: const PersonalInformationView(),
    );
  }
}

class PersonalInformationView extends StatefulWidget {
  const PersonalInformationView({super.key});

  @override
  State<PersonalInformationView> createState() =>
      _PersonalInformationViewState();
}

class _PersonalInformationViewState extends State<PersonalInformationView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String _completePhoneNumber = '';
  bool _hasLoadedData = false;
  int? _selectedGender; // 0 = male, 1 = female

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(dynamic user) {
    if (!_hasLoadedData && user != null) {
      print(
        '📝 Populating fields with: name=${user.name}, email=${user.email}, phone=${user.phone}, gender=${user.gender}',
      );
      print(
        '📝 Gender type: ${user.gender.runtimeType}, value: "${user.gender}"',
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = user.phone ?? '';

          // Set gender based on user data - handle both string and int
          if (user.gender != null) {
            final genderStr = user.gender.toString().toLowerCase();
            print('📝 Gender string (lowercase): "$genderStr"');

            if (genderStr == 'male' || genderStr == '0') {
              _selectedGender = 0;
              print('✅ Set gender to Male (0)');
            } else if (genderStr == 'female' || genderStr == '1') {
              _selectedGender = 1;
              print('✅ Set gender to Female (1)');
            } else {
              print('⚠️ Unknown gender value: $genderStr');
            }
          } else {
            print('⚠️ Gender is null');
          }

          print('📝 Final _selectedGender: $_selectedGender');
          _hasLoadedData = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          'Personal information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          print('🔍 Current state: ${state.runtimeType}');

          // Populate fields when user data is available
          if (state is UserLoaded) {
            print('✅ UserLoaded - user: ${state.user.name}');
            _populateFields(state.user);
          } else if (state is UserUpdating) {
            _populateFields(state.currentUser);
          } else if (state is UserUpdateSuccess) {
            _populateFields(state.user);
          }

          if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.boldPrimaryColor,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8D7FF),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/user_profile_screen/avatar.png",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[400],
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: AppColors.boldPrimaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Name',
                    ),
                    SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

                    // Gender Selection
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                                          : Colors.white,
                                      border: Border.all(
                                        color: _selectedGender == 0
                                            ? AppColors.boldPrimaryColor
                                            : Colors.grey[300]!,
                                        width: 1.5,
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
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Male',
                                          style: TextStyle(
                                            color: _selectedGender == 0
                                                ? AppColors.boldPrimaryColor
                                                : Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
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
                                          : Colors.white,
                                      border: Border.all(
                                        color: _selectedGender == 1
                                            ? AppColors.boldPrimaryColor
                                            : Colors.grey[300]!,
                                        width: 1.5,
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
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Female',
                                          style: TextStyle(
                                            color: _selectedGender == 1
                                                ? AppColors.boldPrimaryColor
                                                : Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
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
                    SizedBox(height: 16),

                    // Phone Field with IntlPhoneField
                    IntlPhoneField(
                      controller: _phoneController,
                      initialCountryCode: 'EG',
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
                        hintText: 'Phone number',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: AppColors.boldPrimaryColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(width: 1.5, color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(width: 1.5, color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      onChanged: (phone) {
                        _completePhoneNumber = phone.completeNumber;
                      },
                    ),
                    SizedBox(height: 24),

                    // Info Text
                    Text(
                      'When you set up your personal information settings, you should take care to provide accurate information.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (state is UserUpdating)
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // Validate gender selection
                                  if (_selectedGender == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please select your gender',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  String phoneToSend = '';

                                  // Check if we have phone input
                                  if (_phoneController.text.isNotEmpty) {
                                    // Get the number without country code
                                    String nationalNumber =
                                        _phoneController.text;

                                    // Remove any non-digit characters except +
                                    nationalNumber = nationalNumber.replaceAll(
                                      RegExp(r'[^\d+]'),
                                      '',
                                    );

                                    // If it starts with country code for Egypt (20), remove it
                                    if (nationalNumber.startsWith('20') &&
                                        nationalNumber.length > 10) {
                                      phoneToSend = nationalNumber.substring(2);
                                    } else {
                                      phoneToSend = nationalNumber;
                                    }

                                    // Remove leading 0 if present
                                    if (phoneToSend.startsWith('0') &&
                                        phoneToSend.length > 1) {
                                      phoneToSend = phoneToSend.substring(1);
                                    }
                                  }

                                  // Validate phone length
                                  if (phoneToSend.length > 11) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Phone number must be 11 digits or less',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  print('📤 Sending data:');
                                  print('  Name: ${_nameController.text}');
                                  print('  Email: ${_emailController.text}');
                                  print('  Phone: $phoneToSend');
                                  print('  Gender: $_selectedGender');

                                  context.read<UserBloc>().add(
                                    UpdateUserProfile(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phone: phoneToSend,
                                      gender: _selectedGender!,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.boldPrimaryColor,
                          disabledBackgroundColor: AppColors.boldPrimaryColor
                              .withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          state is UserUpdating ? 'Updating...' : 'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
