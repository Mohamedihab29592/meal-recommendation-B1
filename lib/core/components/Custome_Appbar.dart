import 'package:flutter/material.dart';

class CustomeAppbar extends StatelessWidget {
   CustomeAppbar({super.key,this.rightImage,this.leftImage,required this.ontapleft,required this.ontapright});
  String? leftImage;
  String? rightImage;
  final VoidCallback ontapleft;
  final VoidCallback ontapright;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(onTap: ontapleft,child: Image.asset("$leftImage")),
        InkWell(onTap: ontapright,child: Container(height: 50,width: 80,child: Image.asset("$rightImage",),alignment: Alignment.topRight,)),
      ],);
  }
}
