import 'package:app/bloc/storage_bloc/storage_bloc.dart';
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
  final TextEditingController newPostController = TextEditingController();
  final StorageBloc storageBloc = StorageBloc();
  bool isQRChecked = false;

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
      listener: (context, state) {},
      builder: (context, state) {
        if (state is StoragesLoaded && state.storages.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                for (Storage storage in state.storages)
                  Column(
                    children: [
                      StorageListView(storage: storage),
                    ],
                  )
              ],
            ),
          );
        }

        if (state is StoragesLoaded && state.storages.isEmpty) {
          return const Center(
            child: Text("No existing Storage"),
          );
        }

        return const Text("error");
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    List<DropdownMenuEntry> storages = [
      const DropdownMenuEntry(value: 1, label: "Kühlschrank"),
      const DropdownMenuEntry(value: 2, label: "Vorratskammer"),
      const DropdownMenuEntry(value: 3, label: "Gartenhaus"),
    ];

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
            TextEditingController itemNameController = TextEditingController();
            TextEditingController itemQuantityController = TextEditingController();
            TextEditingController itemTargetQuantityController = TextEditingController();
            TextEditingController itemStorageController = TextEditingController();
            TextEditingController storageNameController = TextEditingController();

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
                  actions: buildActions(context),
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> buildActions(BuildContext context) {
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
          Navigator.of(context).pop();
        },
      ),
    ];
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
      List<DropdownMenuEntry<dynamic>> storages, TextEditingController storageController, BuildContext context) {
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
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Details"),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isQRChecked = !isQRChecked;
                    });
                  },
                  icon: Icon(Icons.qr_code_scanner)),
              isQRChecked ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red),
            ],
          ),
          DropdownMenu(
            dropdownMenuEntries: storages,
            menuHeight: 200,
            width: 250,
            controller: storageController,
          ),
        ],
      ),
    );
  }
}
