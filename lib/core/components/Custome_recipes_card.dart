import 'package:flutter/material.dart';

import '../utiles/assets.dart';

class CustomeRecipesCard extends StatelessWidget {
   CustomeRecipesCard({super.key,required this.ontap,this.time,this.firsttext,this.ingrediantes,this.middleText,this.image});
  String? firsttext,middleText,ingrediantes,time,image;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 25,
      shadowColor: Colors.black,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(radius: 40,backgroundImage: NetworkImage("$image"),),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$firsttext",style: TextStyle(fontWeight: FontWeight.w400),),
              Text("$middleText",style: TextStyle(fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Text("$ingrediantes"),SizedBox(width: 10,),
                  Text("$time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                ],),

            ],),
          Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topRight,
              width: 50,
              height: 100,
              child: InkWell(onTap: ontap,child: Image.asset("${Assets.icFavorite}")))
        ],),);
  }
}
