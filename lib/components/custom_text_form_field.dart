import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.labelText,
    this.suffix,
    this.inputFormatters,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final bool readOnly;
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      initialValue: initialValue,
      readOnly: readOnly,
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      inputFormatters: inputFormatters,
      cursorColor: Colors.blue[700],
      decoration: InputDecoration(
        suffix: suffix,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
