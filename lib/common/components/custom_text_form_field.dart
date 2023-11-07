import 'package:flutter/material.dart';
import 'package:woodada/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final double? height;
  final int? maxLines; // maxLines 파라미터 추가

  const CustomTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autoFocus = false,
    this.hintText,
    this.errorText,
    this.height,
    this.maxLines, // maxLines 파라미터 추가
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: GREY_COLOR,
        width: 1.0,
      ),
    );

    return SizedBox(
      height: height ?? 50,
      child: TextFormField(
        cursorColor: PRIMARY_COLOR,
        obscureText: obscureText,
        autofocus: autoFocus,
        onChanged: onChanged,
        maxLines: maxLines, // maxLines 적용
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          hintText: hintText,
          errorText: errorText,
          hintStyle: const TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14,
          ),
          fillColor: Colors.white,
          filled: true,
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}
