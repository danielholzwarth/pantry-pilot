import 'package:app/models/storage.dart';
import 'package:app/widgets/storage_tile.dart';
import 'package:flutter/material.dart';

class StorageListView extends StatefulWidget {
  final Storage storage;

  const StorageListView({
    super.key,
    required this.storage,
  });

  @override
  State<StorageListView> createState() => _StorageListViewState();
}

class _StorageListViewState extends State<StorageListView> {
  void onDelete(BuildContext context, int index) {
    setState(() {
      widget.storage.items.remove(widget.storage.items[index]);
    });
  }

  void onEdit(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          iconColor: Theme.of(context).colorScheme.inversePrimary,
          initiallyExpanded: true,
          title: Text(
            widget.storage.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.storage.items.length,
              itemBuilder: (context, index) {
                return StorageTile(
                  item: widget.storage.items[index],
                  onDelete: (p0) => onDelete(context, index),
                  onEdit: (p0) => onEdit(context),
                );
              },
            ),
            if (widget.storage.items.isEmpty)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Storage is currently empty!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
