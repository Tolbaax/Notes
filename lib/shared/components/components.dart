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


Widget buildTaskItem(Map model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text(
            '${model['time']}'
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${model['title']}',
            style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            '${model['date']}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ],
  ),
);