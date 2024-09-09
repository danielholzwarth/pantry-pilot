import 'package:app/widgets/storage_back_button.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50, left: 25),
            child: Row(
              children: [StorageBackButton()],
            ),
          ),
          SizedBox(height: 25),
          Text("History"),
        ],
      ),
    );
  }
}
