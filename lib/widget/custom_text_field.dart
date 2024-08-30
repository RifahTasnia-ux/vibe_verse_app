import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibe_verse/utils/svg_string.dart';

import '../utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData? icon; // Optional IconData
  final Widget? svgIcon; // Optional Widget for SVG
  final String hintText;
  final FocusNode focusNode;
  final bool isPassword;
  final bool? obscureText;
  final TextInputType inputType;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.icon, // IconData is now optional
    this.svgIcon, // Widget for SVG is also optional
    required this.hintText,
    required this.focusNode,
    this.isPassword = false,
    this.obscureText,
    this.inputType = TextInputType.text,
    this.onSuffixTap,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: TextField(
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.black),
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.inputType,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.svgIcon ?? (widget.icon != null
                ? Icon(
              widget.icon,
              color: widget.focusNode.hasFocus
                  ? AppColors.primary
                  : AppColors.grey,
              size: 24.sp,
            )
                : null),
            suffixIcon: widget.isPassword
                ? IconButton(
              // icon: Icon(
              //   _obscureText
              //       ? Icons.visibility_off
              //       : Icons.visibility,
              //   color: AppColors.grey,
              //   size: 24.sp,
              // ),
              icon: SvgPicture.string(
                  _obscureText
                      ? SvgStringName.svgPasswordSecure : SvgStringName.svgPasswordSecureOff),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
                if (widget.onSuffixTap != null) {
                  widget.onSuffixTap!();
                }
              },
            )
                : null,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                BorderSide(color: AppColors.textBoxBorderBefore, width: 2.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                BorderSide(color: AppColors.textBoxBorderBefore, width: 2.w)),
          ),
        ),
      ),
    );
  }
}
