import 'package:flutter/material.dart';

class Customemultilinetextfield extends StatelessWidget {
   Customemultilinetextfield({super.key,this.hintText,this.controller});
  TextEditingController? controller;
  String? hintText;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      maxLines: 7,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(width: 1)),
          hintText:hintText,
          hintStyle: TextStyle(color: Colors.white,),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(width: 1))
      ),
    );
  }
}
