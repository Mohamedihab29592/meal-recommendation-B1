import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utiles/assets.dart';

class CustomRecipesCard extends StatelessWidget {
  CustomRecipesCard(
      {super.key,
      required this.ontap,
      this.time,
      this.firsttext,
      this.ingrediantes,
      this.middleText,
      this.image,
      this.rating,
        this.isFavorite
      });
  String? firsttext, middleText, ingrediantes, time, image;
  double? rating;
  bool? isFavorite;

  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 25,
      shadowColor: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("$image"),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$firsttext",
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              Text(
                "$middleText",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text("$ingrediantes"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$time",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: RatingBar.builder(
                  initialRating: rating!,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemSize: 25.w,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                  },
                ),
              )
            ],
          ),
          Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topRight,
              width: 50,
              height: 100,
              child: InkWell(
                  onTap: ontap, child: Image.asset(isFavorite! ? Assets.icFilledHeart : Assets.icFavorite))),
        ],
      ),
    );
  }
}
