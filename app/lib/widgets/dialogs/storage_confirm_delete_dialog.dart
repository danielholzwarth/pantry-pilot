import 'package:flutter/material.dart';

class StorageConfirmDeleteDialog extends StatelessWidget {
  const StorageConfirmDeleteDialog({
    super.key,
    required this.deleteName,
    required this.message,
    required this.onPressed,
  });

  final String deleteName;
  final String message;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Delete $deleteName?",
        textAlign: TextAlign.center,
      ),
      content: Text(message),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red.shade300,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
