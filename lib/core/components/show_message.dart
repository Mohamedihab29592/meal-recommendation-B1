import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class ShowMessage extends StatefulWidget {
  static void show(BuildContext context, message) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => ShowMessage(
          message: message,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();
  final String message;
  const ShowMessage({super.key, required this.message});

  @override
  ShowMessageState createState() => ShowMessageState();
}

class ShowMessageState extends State<ShowMessage> {
  final List<Color> _kDefaultRainbowColors = const [
    AppColors.primary,
  ];
  @override
  void initState() {
    super.initState();
    hideMessageAftertwoSeconds();
  }

  void hideMessageAftertwoSeconds() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    ShowMessage.hide(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
