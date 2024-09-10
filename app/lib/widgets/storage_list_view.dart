import 'package:app/models/storage.dart';
import 'package:app/widgets/dialogs/storage_confirm_delete_dialog.dart';
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
  TextEditingController nameController = TextEditingController();

  void onDeleteItem(BuildContext context, int index) {
    setState(() {
      widget.storage.items.remove(widget.storage.items[index]);
    });
  }

  void onEditItem(BuildContext context) {}

  @override
  void initState() {
    nameController.text = widget.storage.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          iconColor: Theme.of(context).colorScheme.inversePrimary,
          initiallyExpanded: true,
          title: GestureDetector(
            onLongPress: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Edit Storage", textAlign: TextAlign.center),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Change Name"),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return StorageConfirmDeleteDialog(
                              deleteName: widget.storage.name,
                              message: "This step is irreversible. All items connected to the storage will be deleted and can not be restored!",
                              onPressed: () {},
                            );
                          },
                        ),
                        child: Text(
                          "Delete Storage",
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
            child: Text(
              widget.storage.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
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
                  onDelete: (p0) => onDeleteItem(context, index),
                  onEdit: (p0) => onEditItem(context),
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
