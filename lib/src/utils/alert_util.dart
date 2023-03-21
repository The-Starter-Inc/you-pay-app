import 'package:flutter/material.dart';

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
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                )),
        title: Text(
          'Error',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
