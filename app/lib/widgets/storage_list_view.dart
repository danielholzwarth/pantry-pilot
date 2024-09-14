import 'package:app/bloc/storage_bloc/storage_bloc.dart';
import 'package:app/helper/helper.dart';
import 'package:app/helper/text_highlighter.dart';
import 'package:app/models/storage.dart';
import 'package:app/widgets/dialogs/storage_confirm_delete_dialog.dart';
import 'package:app/widgets/storage_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageListView extends StatefulWidget {
  final Storage storage;
  final StorageBloc homeStorageBloc;
  final List<Storage> storages;
  final bool isSearch;
  final String keyword;

  const StorageListView({
    super.key,
    required this.storage,
    required this.homeStorageBloc,
    required this.storages,
    this.isSearch = false,
    this.keyword = "",
  });

  @override
  State<StorageListView> createState() => _StorageListViewState();
}

class _StorageListViewState extends State<StorageListView> {
  TextEditingController nameController = TextEditingController();
  StorageBloc storageBloc = StorageBloc();

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
                return BlocConsumer(
                  bloc: storageBloc,
                  listener: (context, state) {
                    if (state is StoragePatched) {
                      widget.homeStorageBloc.add(GetStorages());
                      Navigator.pop(context);
                    }

                    if (state is StorageError) {
                      displayMessageToUser(state.error, context);
                    }
                  },
                  builder: (context, state) {
                    if (state is StoragePatching) {
                      return const Center(child: CircularProgressIndicator());
                    }

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
                                return BlocConsumer(
                                  bloc: storageBloc,
                                  listener: (context, state) {
                                    if (state is StorageDeleted) {
                                      widget.homeStorageBloc.add(GetStorages());
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is StorageDeleting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    return StorageConfirmDeleteDialog(
                                      deleteName: widget.storage.name,
                                      message:
                                          "This step is irreversible. All items connected to the storage will be deleted and can not be restored!",
                                      onPressed: () => storageBloc.add(DeleteStorage(storageID: widget.storage.id)),
                                    );
                                  },
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
                              onPressed: () {
                                if (nameController.text.isEmpty) {
                                  displayMessageToUser("Storage name must not be empty!", context);
                                  return;
                                }
                                storageBloc.add(PatchStorage(storageID: widget.storage.id, name: nameController.text));
                              },
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
                );
              },
            ),
            child: widget.isSearch
                ? TextHiglighter.highlightText(context, widget.storage.name, widget.keyword, 20)
                : Text(
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
                  homeStorageBloc: widget.homeStorageBloc,
                  storages: widget.storages,
                  isSearch: widget.isSearch,
                  keyword: widget.keyword,
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
