import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_verse/utils/app_colors.dart';
import '../../../data/firebase_auth.dart';
import '../../../utils/image_picker.dart';
import '../../../utils/svg_string.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_field.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailTEC = TextEditingController();
  final fullNameTEC = TextEditingController();
  final userNameTEC = TextEditingController();
  final bioTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final confirmPasswordTEC = TextEditingController();

  final emailFocus = FocusNode();
  final fullNameFocus = FocusNode();
  final userNameFocus = FocusNode();
  final bioFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  File? _imageFile;
  bool _isLoading = false;
  bool _isEmailFilled = false;
  bool _isFullNameFilled = false;
  bool _isUserNameFilled = false;
  bool _isBioFilled = false;
  bool _isPasswordFilled = false;
  bool _isConfirmPasswordFilled = false;

  @override
  void initState() {
    super.initState();

    emailTEC.addListener(_updateButtonState);
    fullNameTEC.addListener(_updateButtonState);
    userNameTEC.addListener(_updateButtonState);
    bioTEC.addListener(_updateButtonState);
    passwordTEC.addListener(_updateButtonState);
    confirmPasswordTEC.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailTEC.removeListener(_updateButtonState);
    fullNameTEC.removeListener(_updateButtonState);
    userNameTEC.removeListener(_updateButtonState);
    bioTEC.removeListener(_updateButtonState);
    passwordTEC.removeListener(_updateButtonState);
    confirmPasswordTEC.removeListener(_updateButtonState);

    emailTEC.dispose();
    fullNameTEC.dispose();
    userNameTEC.dispose();
    bioTEC.dispose();
    passwordTEC.dispose();
    confirmPasswordTEC.dispose();
    emailFocus.dispose();
    fullNameFocus.dispose();
    userNameFocus.dispose();
    bioFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isEmailFilled = emailTEC.text.isNotEmpty;
      _isFullNameFilled = fullNameTEC.text.isNotEmpty;
      _isUserNameFilled = userNameTEC.text.isNotEmpty;
      _isBioFilled = bioTEC.text.isNotEmpty;
      _isPasswordFilled = passwordTEC.text.isNotEmpty;
      _isConfirmPasswordFilled = confirmPasswordTEC.text.isNotEmpty;
    });
  }

  Future<void> _handleSignUp() async {
    if (passwordTEC.text.length < 6) {
      _showFlushbar(
        'Password must be at least 6 characters long !',
        Colors.redAccent,
      );
      return;
    }
    if (passwordTEC.text != confirmPasswordTEC.text) {
      _showFlushbar(
        'The Password and Confirmed Password should be same !',
        Colors.redAccent,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Authentication().signUp(
        email: emailTEC.text,
        password: passwordTEC.text,
        confirmPassword: confirmPasswordTEC.text,
        fullName: fullNameTEC.text,
        userName: userNameTEC.text,
        bio: bioTEC.text,
        profile: _imageFile ?? File(''),
      );

      if (mounted) {
        _showFlushbar(
          'Registration is Successful ! Please Login.',
          Colors.green,
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          clearController();
        });
      }
    } catch (e) {
      if (mounted) {
        _showFlushbar(
          'Registration Failed ! Try Again with All Proper Inputs.',
          Colors.redAccent,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source',style: TextStyle(
            fontFamily: "Satoshi",
          ),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.string(
                          SvgStringName.svgCamera,
                        ),
                        onPressed: () async {
                          File? pickedImageFile = (await ImagePickerService().uploadImage('camera'));
                          setState(() {
                            _imageFile = pickedImageFile;
                          });
                          Navigator.of(context).pop();
                        },
                      ),

                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.string(
                          SvgStringName.svgGallery,
                        ),
                        onPressed: () async {
                          File? pickedImageFile = (await ImagePickerService().uploadImage('gallery'));
                          setState(() {
                            _imageFile = pickedImageFile;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Satoshi",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void clearController() {
    emailTEC.clear();
    fullNameTEC.clear();
    userNameTEC.clear();
    bioTEC.clear();
    passwordTEC.clear();
    confirmPasswordTEC.clear();
  }
  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _isEmailFilled &&
        _isUserNameFilled &&
        _isFullNameFilled &&
        _isBioFilled &&
        _isPasswordFilled &&
        _isConfirmPasswordFilled &&
        _imageFile != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ScreenUtil.defaultSize.height * .025.h),
                Text(
                  'Vibe Verse'.toUpperCase(),
                  style: GoogleFonts.nerkoOne(
                    fontSize: 35,
                    color: const Color(0xff363636),
                    fontWeight: FontWeight.w700,),
                ),
                SizedBox(height: 15.h),
                const Text(
                  "Register with your profile information",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Roboto-Bold",
                  ),
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: _pickImage,
                  child: Center(
                    child: CircleAvatar(
                      radius: 55.r,
                      backgroundColor: AppColors.white,
                      child: _imageFile == null
                          ? Icon(
                        Icons.person,
                        color: AppColors.secondary,
                        size: 50.h,
                      )
                          : CircleAvatar(
                        radius: 50.r,
                        backgroundImage: FileImage(_imageFile!),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: emailTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgEmail,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'User Email',
                  focusNode: emailFocus,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: fullNameTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgPerson,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'Full Name',
                  focusNode: fullNameFocus,
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: userNameTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgUserHandle,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'User Name',
                  focusNode: userNameFocus,
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: bioTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgBio,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'Short Bio',
                  focusNode: bioFocus,
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: passwordTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgPassword,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'Password',
                  focusNode: passwordFocus,
                  isPassword: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: confirmPasswordTEC,
                  svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgPassword,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintText: 'Confirm Password',
                  focusNode: confirmPasswordFocus,
                  isPassword: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 25.h),
                CustomButton(
                  text: 'Create Account',
                  onPressed: () {
                    if (isFormValid) {
                      _handleSignUp();
                    }
                  },
                  isEnabled: isFormValid,
                  isLoading: _isLoading,
                  loadingColor: AppColors.secondary,
                  color: AppColors.textBoxButton,
                ),
                SizedBox(height: 26.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: " Already have an Account? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.black),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.secondary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

