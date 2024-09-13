import 'package:app/bloc/item_bloc/item_bloc.dart';
import 'package:app/bloc/storage_bloc/storage_bloc.dart';
import 'package:app/helper/helper.dart';
import 'package:app/models/item.dart';
import 'package:app/models/storage.dart';
import 'package:app/widgets/dialogs/storage_confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StorageTile extends StatefulWidget {
  final Item item;
  final StorageBloc homeStorageBloc;
  final List<Storage> storages;

  const StorageTile({
    super.key,
    required this.item,
    required this.homeStorageBloc,
    required this.storages,
  });

  @override
  State<StorageTile> createState() => _StorageTileState();
}

class _StorageTileState extends State<StorageTile> {
  TextEditingController quantityController = TextEditingController();
  late int currentQuantity;
  ItemBloc itemBloc = ItemBloc();

  @override
  void initState() {
    quantityController.text = widget.item.quantity.toString();
    super.initState();
  }

  void updateQuantity(bool increment) {
    int? newQuantity = int.tryParse(quantityController.text);
    if (newQuantity != null) {
      newQuantity = increment ? newQuantity + 1 : newQuantity - 1;

      setState(() {
        quantityController.text = newQuantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: buildActionPane(context),
      child: ListTile(
        onTap: () => showDialog(
          context: context,
          builder: (context) {
            return BlocConsumer(
              bloc: itemBloc,
              listener: (context, state) {
                if (state is ItemPatched) {
                  widget.homeStorageBloc.add(GetStorages());
                  Navigator.pop(context);
                }

                if (state is ItemError) {
                  displayMessageToUser(state.error, context);
                }
              },
              builder: (context, state) {
                if (state is ItemPatching) {
                  return const Center(child: CircularProgressIndicator());
                }
                return buildQuantityDialog(context);
              },
            );
          },
        ),
        title: Text(
          widget.item.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Text(
          "${widget.item.quantity.toString()}/${widget.item.targetQuantity.toString()}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  AlertDialog buildQuantityDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.item.name,
        textAlign: TextAlign.center,
      ),
      alignment: Alignment.center,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () => updateQuantity(false), icon: const Icon(Icons.remove)),
          SizedBox(
            width: 50,
            child: TextField(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              textAlign: TextAlign.center,
              controller: quantityController,
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(onPressed: () => updateQuantity(true), icon: const Icon(Icons.add)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          onPressed: () {
            currentQuantity = widget.item.quantity;
            quantityController.text = currentQuantity.toString();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Save",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          onPressed: () {
            int? quantity = int.tryParse(quantityController.text);
            if (quantity == null) {
              displayMessageToUser("Please enter valid Quantity > 0!", context);
              return;
            }

            itemBloc.add(PatchItem(
                itemID: widget.item.id,
                oldStorageID: widget.item.storageID,
                storageID: widget.item.storageID,
                name: widget.item.name,
                quantity: quantity,
                details: widget.item.details,
                barCode: widget.item.barCode,
                targetQuantity: widget.item.targetQuantity));
          },
        ),
      ],
    );
  }

  ActionPane buildActionPane(BuildContext context) {
    return ActionPane(
      extentRatio: 0.4,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (value) => buildDeleteDialog(context),
          icon: Icons.delete,
          backgroundColor: Colors.red.shade300,
        ),
        SlidableAction(
          onPressed: (value) => buildEditDialog(context),
          icon: Icons.edit,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  Future<dynamic> buildDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer(
          bloc: itemBloc,
          listener: (context, state) {
            if (state is ItemDeleted) {
              widget.homeStorageBloc.add(GetStorages());
              Navigator.pop(context);
            }

            if (state is ItemError) {
              displayMessageToUser(state.error, context);
            }
          },
          builder: (context, state) {
            if (state is ItemDeleting) {
              return const Center(child: CircularProgressIndicator());
            }

            return StorageConfirmDeleteDialog(
              deleteName: widget.item.name,
              message: "This step is irreversible. The item will be deleted and can not be restored!",
              onPressed: () => itemBloc.add(DeleteItem(itemID: widget.item.id)),
            );
          },
        );
      },
    );
  }

  Future<dynamic> buildEditDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer(
          bloc: itemBloc,
          listener: (context, state) {
            if (state is ItemPatched) {
              currentQuantity = int.parse(quantityController.text);
              widget.homeStorageBloc.add(GetStorages());
              Navigator.pop(context);
            }

            if (state is ItemError) {
              displayMessageToUser(state.error, context);
            }
          },
          builder: (context, state) {
            if (state is ItemPatching) {
              return const Center(child: CircularProgressIndicator());
            }

            return AlertDialog(
              title: Text(
                "Edit ${widget.item.name}?",
                textAlign: TextAlign.center,
              ),
              content: buildContent(widget.storages),
            );
          },
        );
      },
    );
  }

  Widget buildContent(List<Storage> storages) {
    TextEditingController nameController = TextEditingController(text: widget.item.name);
    TextEditingController quantityController = TextEditingController(text: widget.item.quantity.toString());
    TextEditingController targetQuantityController = TextEditingController(text: widget.item.targetQuantity.toString());
    TextEditingController detailsController = TextEditingController(text: widget.item.details.toString());
    TextEditingController storageController =
        TextEditingController(text: widget.storages.firstWhere((element) => element.id == widget.item.storageID).name);

    List<DropdownMenuEntry> entries = [];
    bool isQRChecked = false;

    for (int i = 0; i < storages.length; i++) {
      entries.add(DropdownMenuEntry(value: i, label: storages[i].name));
    }

    return SizedBox(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: targetQuantityController,
                  decoration: const InputDecoration(labelText: "Target"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: "Details"),
                ),
              ),
              StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isQRChecked = !isQRChecked;
                          });
                        },
                        icon: const Icon(Icons.qr_code_scanner)),
                    isQRChecked ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
                  ],
                );
              }),
            ],
          ),
          DropdownMenu(
            dropdownMenuEntries: entries,
            menuHeight: 200,
            width: 250,
            controller: storageController,
          ),
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
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    displayMessageToUser("Name must not be empty!", context);
                    return;
                  }

                  int? quantity = int.tryParse(quantityController.text);
                  if (quantity == null) {
                    displayMessageToUser("Please enter valid Quantity > 0!", context);
                    return;
                  }

                  int storageID = storages
                      .firstWhere((element) => element.name == storageController.text,
                          orElse: () => Storage(id: -1, name: "", items: [], updatedAt: DateTime.now()))
                      .id;
                  if (storageID <= 0) {
                    displayMessageToUser("Please enter valid Storage!", context);
                    return;
                  }

                  itemBloc.add(PatchItem(
                    itemID: widget.item.id,
                    oldStorageID: widget.item.storageID,
                    storageID: storageID,
                    name: nameController.text,
                    quantity: quantity,
                    targetQuantity: int.tryParse(targetQuantityController.text) ?? 0,
                    details: detailsController.text,
                    barCode: "itemBarcode",
                  ));
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
