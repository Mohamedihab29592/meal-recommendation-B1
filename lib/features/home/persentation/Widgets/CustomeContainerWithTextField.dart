import 'package:flutter/material.dart';


class Customecontainerwithtextfield extends StatelessWidget {
   Customecontainerwithtextfield({super.key,this.hinttext,this.controller});
   String? hinttext;
   TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(left: 10),width: 80,height: 40,
    child:TextFormField(
    controller: controller,
    decoration: InputDecoration(
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(width: 1)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(width: 1)),
    hintText:hinttext,
    hintStyle: TextStyle(fontSize: 15,color: Colors.white)
    ),
    ));
  }
}
