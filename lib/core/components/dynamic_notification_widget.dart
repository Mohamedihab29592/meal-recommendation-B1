import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class DynamicNotificationWidget {
  static void showNotification({
    required BuildContext context,
    required String title,
    required String message,
    required Color color,
    required ContentType contentType,
    bool inMaterialBanner = false,
  }) {
    if (inMaterialBanner) {
      final materialBanner = MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: SingleChildScrollView(
          child: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
            inMaterialBanner: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('CLOSE'),
          ),
        ],
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}