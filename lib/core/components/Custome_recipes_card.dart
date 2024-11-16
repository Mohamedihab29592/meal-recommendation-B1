import 'package:flutter/material.dart';

import '../utiles/assets.dart';

class CustomeRecipesCard extends StatelessWidget {
  CustomeRecipesCard({
    super.key,
    required this.ontapFav,
    this.time,
    this.firsttext,
    this.ingrediantes,
    this.middleText,
    this.image,
    required this.ontapDelete,
  });

  final String? firsttext, middleText, ingrediantes, time, image;
  final VoidCallback ontapFav;
  final VoidCallback ontapDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 10, // Reduced elevation
      shadowColor: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: image != null && image!.isNotEmpty
                  ? NetworkImage(image!)
                  : const AssetImage(Assets.icSplash) as ImageProvider,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(firsttext ?? "Type of meal", style: TextStyle(fontWeight: FontWeight.w400)),
              Text(middleText ?? "Meal Name", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text(ingrediantes ?? "0 ingredients"),
                  SizedBox(width: 10),
                  Text(time ?? "0 min", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topRight,
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: ontapFav,
                  child: Image.asset(
                    Assets.icFavorite,
                    width: 25,
                  ),
                ),
                InkWell(
                  onTap: ontapDelete,
                  child: Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
