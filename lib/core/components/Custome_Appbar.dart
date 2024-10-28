import 'package:flutter/material.dart';

class CustomeAppbar extends StatelessWidget {
   CustomeAppbar({super.key,this.rightImage,this.leftImage});
  String? leftImage;
  String? rightImage;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(onTap: (){},child: Image.asset("$leftImage")),
        InkWell(onTap: (){},child: Image.asset("$rightImage")),
      ],);
  }
}
