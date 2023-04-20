import 'package:flutter/material.dart';

import '../theme/text_size.dart';

class AlertUtil {
  AlertUtil._();

  static void showErrorAlert(ctx, message) async {
    await showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
        content: Text(message,
            style: TextSize.size14),
        title: Text(
          'Error',
          style: TextSize.size18,
        ),
      ),
    );
  }
}
