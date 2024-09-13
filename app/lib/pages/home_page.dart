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
          storages = state.storages;
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
                    StorageListView(storage: storage, homeStorageBloc: storageBloc, storages: storages),
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
                      setState(
                        () {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        },
                      );
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
                  content: isSelected[0] == true ? buildAddItem(storageBloc, storages) : buildAddStorage(storageBloc),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildAddStorage(StorageBloc storageBloc) {
    StorageBloc storageBloc2 = StorageBloc();
    TextEditingController nameController = TextEditingController();

    return BlocConsumer(
      bloc: storageBloc2,
      listener: (context, state) {
        if (state is StoragePosted) {
          storageBloc.add(GetStorages());
          nameController.clear();
          Navigator.pop(context);
        }

        if (state is StorageError) {
          displayMessageToUser(state.error, context);
        }
      },
      builder: (context, state) {
        if (state is StoragePosting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            buildActions(
              context,
              () {
                storageBloc2.add(PostStorage(name: nameController.text));
              },
            )
          ],
        );
      },
    );
  }

  Widget buildAddItem(StorageBloc storageBloc, List<Storage> storages) {
    ItemBloc itemBloc = ItemBloc();
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController targetQuantityController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    TextEditingController storageController = TextEditingController();

    List<DropdownMenuEntry> entries = [];

    for (int i = 0; i < storages.length; i++) {
      entries.add(DropdownMenuEntry(value: i, label: storages[i].name));
    }

    return BlocConsumer(
      bloc: itemBloc,
      listener: (context, state) {
        if (state is ItemPosted) {
          storageBloc.add(GetStorages());
          nameController.clear();
          quantityController.clear();
          targetQuantityController.clear();
          detailsController.clear();
          storageController.clear();
          Navigator.pop(context);
        }

        if (state is ItemError) {
          displayMessageToUser(state.error, context);
        }
      },
      builder: (context, state) {
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
              buildActions(context, () {
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

                itemBloc.add(PostItem(
                  storageID: storageID,
                  name: nameController.text,
                  quantity: quantity,
                  targetQuantity: int.tryParse(targetQuantityController.text) ?? 0,
                  details: detailsController.text,
                  barCode: "itemBarcode",
                ));
              })
            ],
          ),
        );
      },
    );
  }
}

Widget buildActions(BuildContext context, Function()? onPressed) {
  return Row(
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
          "Add",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      )
    ],
  );
}
