import 'package:flutter/material.dart';

Widget defaultFormField({
  required String? Function(String?) validate,
  required TextEditingController controller,
  void Function()? suffixPressed,
  required TextInputType type,
  required IconData prefix,
  required String label,
  bool readOnly = false,
  Function()? onTab,
  bool isPassword = false,
  IconData? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate ,
      obscureText: isPassword,
      onTap: onTab,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,color: Colors.blue,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        ),
        border: const OutlineInputBorder(),
      ),
    );
