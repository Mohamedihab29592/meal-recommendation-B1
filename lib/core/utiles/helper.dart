 import 'package:flutter/material.dart';

import '../components/loading_dialog.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Disable closing the dialog by tapping outside
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}