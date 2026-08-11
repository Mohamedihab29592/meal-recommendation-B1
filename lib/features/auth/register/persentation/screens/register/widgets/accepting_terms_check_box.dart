import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptingTermsCheckBox extends StatefulWidget {
  const AcceptingTermsCheckBox({
    super.key,
    required this.acceptingTermsNotifier,
  });
  final ValueNotifier acceptingTermsNotifier;
  @override
  State<AcceptingTermsCheckBox> createState() => _AcceptingTermsCheckBoxState();
}

class _AcceptingTermsCheckBoxState extends State<AcceptingTermsCheckBox> {
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2.sp,
          child: Checkbox(
            value: checkBox,
            fillColor: const WidgetStatePropertyAll(Colors.transparent),
            side: const BorderSide(color: Colors.white),
            focusColor: Colors.white,
            onChanged: (value) {
              setState(() {
                checkBox = value!;
                widget.acceptingTermsNotifier.value = checkBox;
              });
            },
          ),
        ),
        Flexible(
          child: Text(
            "by creating a account you agree terms ........",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}
