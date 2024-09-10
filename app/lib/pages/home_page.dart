import 'package:app/bloc/item_bloc/item_bloc.dart';
import 'package:app/bloc/storage_bloc/storage_bloc.dart';
import 'package:app/helper/helper.dart';
import 'package:app/models/storage.dart';
import 'package:app/widgets/storage_drawer.dart';
import 'package:app/widgets/storage_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageBloc storageBloc = StorageBloc();
  final ItemBloc itemBloc = ItemBloc();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemTargetQuantityController = TextEditingController();
  TextEditingController itemDetailsController = TextEditingController();
  TextEditingController itemStorageController = TextEditingController();
  TextEditingController storageNameController = TextEditingController();

  String itemBarcode = "not implemented yet...";
  bool isQRChecked = false;
  List<Storage> storages = [];

  @override
  void initState() {
    storageBloc.add(GetStorages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: buildAppBar(context),
      drawer: const StorageDrawer(),
      body: buildContent(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 0,
      title: const Text("S T O R A G E"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return BlocConsumer(
      bloc: storageBloc,
      listener: (context, state) {
        if (state is StoragesLoaded) {
          clearController();
          storages = state.storages;
        }

        if (state is StoragePosted) {
          clearController();
          storages.add(state.storage);
        }

        if (state is StorageError) {
          displayMessageToUser(state.error, context);
        }
      },
      builder: (context, state) {
        if (state is StoragesLoaded && state.storages.isEmpty) {
          return const Center(
            child: Text("No existing Storage"),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              for (Storage storage in storages)
                Column(
                  children: [
                    StorageListView(storage: storage),
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    List<bool> isSelected = [true, false];

    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Icon(
        Icons.add,
        size: 30,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          child: Text(
                            "Add Item",
                            style: TextStyle(
                              color: isSelected[0] ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          child: Text(
                            "Add Storage",
                            style: TextStyle(
                              color: isSelected[0] ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: isSelected[0] == true
                      ? buildAddItem(
                          itemNameController, itemQuantityController, itemTargetQuantityController, storages, itemStorageController, context)
                      : buildAddStorage(storageNameController),
                  actions: buildActions(context, isSelected[0]),
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> buildActions(BuildContext context, bool isAddItem) {
    return [
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
        child: Text(
          "Add",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        onPressed: () {
          if (isAddItem) {
            int? quantity = int.tryParse(itemQuantityController.text);
            if (quantity == null) {
              displayMessageToUser("Please enter valid Quantity > 0", context);
              return;
            }

            itemBloc.add(PostItem(
              storageID: storages.firstWhere((element) => element.name == itemStorageController.text).id,
              name: itemNameController.text,
              quantity: quantity,
              targetQuantity: int.tryParse(itemTargetQuantityController.text),
              details: itemDetailsController.text,
              barCode: itemBarcode, //GET REAL BARCODE
            ));
          } else {
            storageBloc.add(PostStorage(name: storageNameController.text));
          }
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  void clearController() {
    itemNameController.clear();
    itemQuantityController.clear();
    itemTargetQuantityController.clear();
    itemDetailsController.clear();
    itemStorageController.clear();
    storageNameController.clear();
  }

  Column buildAddStorage(TextEditingController nameController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
      ],
    );
  }

  Widget buildAddItem(TextEditingController nameController, TextEditingController actualController, TextEditingController targetController,
      List<Storage> storages, TextEditingController storageController, BuildContext context) {
    List<DropdownMenuEntry> entries = [];

    for (int i = 0; i < storages.length; i++) {
      entries.add(DropdownMenuEntry(value: i, label: storages[i].name));
    }

    return SizedBox(
      height: 300,
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
                  controller: actualController,
                  decoration: const InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: targetController,
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
                  controller: itemDetailsController,
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
        ],
      ),
    );
  }
}
