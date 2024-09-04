import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_verse/presentation/screens/auth/registration_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibe_verse/presentation/screens/home_bottom_nav_bar.dart';
import '../../../data/firebase_auth.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/svg_string.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _isEmailFilled = false;
  bool _isPasswordFilled = false;

  bool _isChecked = false;

  @override
  void initState() {
    super.initState();

    emailTEC.addListener(_updateButtonState);
    passwordTEC.addListener(_updateButtonState);

    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailTEC.removeListener(_updateButtonState);
    passwordTEC.removeListener(_updateButtonState);
    emailTEC.dispose();
    passwordTEC.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isEmailFilled = emailTEC.text.isNotEmpty;
      _isPasswordFilled = passwordTEC.text.isNotEmpty;
    });
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Authentication()
          .login(email: emailTEC.text, password: passwordTEC.text);
      if (mounted) {
        _showFlushbar(
          'Log in is Successful !',
          Colors.green,
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const PersistentBottomNavBar()),
                (route) => false,
          ); });
        emailTEC.clear();
        passwordTEC.clear();
      }
    } catch (e) {
      if (mounted) {
        _showFlushbar(
          'Log in Failed ! Try Again with All Proper Inputs.',
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil.defaultSize.height * .15.h),
              Text(
                'Vibe Verse'.toUpperCase(),
                style: GoogleFonts.nerkoOne(
                  fontSize: 35,
                  color: const Color(0xff363636),
                  fontWeight: FontWeight.w700,),
              ),
              SizedBox(height: 40.h),
              const Text(
                "Login to your Account",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Roboto-Bold",
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                controller: emailTEC,
                svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgEmail,
                      height: 20,
                      width: 20,
                    )),
                hintText: 'Email',
                focusNode: emailFocus,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: passwordTEC,
                svgIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.string(
                      SvgStringName.svgPassword,
                      height: 20,
                      width: 20,
                    )),
                hintText: 'Password',
                focusNode: passwordFocus,
                isPassword: true,
                inputType: TextInputType.visiblePassword,
              ),
              CheckboxListTile(
                title: Text(
                  "Save password",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                value: _isChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isChecked = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity
                    .leading,
                contentPadding: EdgeInsets.zero,
                activeColor: _isChecked ? const Color(0xff779aef) : Colors.grey[700],
                checkColor: Colors.white,
              ),
              SizedBox(height: 15.h),
              CustomButton(
                text: 'Log In',
                onPressed: _handleLogin,
                isEnabled: _isEmailFilled && _isPasswordFilled,
                isLoading: _isLoading,
                color: AppColors.textBoxButton,
                loadingColor: AppColors.secondary,
              ),
              SizedBox(height: 50.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: " Don't have an Account? ",
                    style:
                    textTheme.bodySmall?.copyWith(color: AppColors.black),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: textTheme.bodySmall
                            ?.copyWith(color: AppColors.secondary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
