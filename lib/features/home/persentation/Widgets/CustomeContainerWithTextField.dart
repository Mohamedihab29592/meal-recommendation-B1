import 'package:flutter/material.dart';

class CustomContainerWithTextfield extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;

  const CustomContainerWithTextfield({
    super.key,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        cursorColor: Colors.blueAccent,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
