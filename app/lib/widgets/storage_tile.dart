import 'package:app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StorageTile extends StatefulWidget {
  final Item item;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;

  const StorageTile({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<StorageTile> createState() => _StorageTileState();
}

class _StorageTileState extends State<StorageTile> {
  TextEditingController quantityController = TextEditingController();
  late int currentQuantity;

  @override
  void initState() {
    currentQuantity = widget.item.quantity;
    quantityController.text = currentQuantity.toString();
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
            return buildDialog(context);
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

  AlertDialog buildDialog(BuildContext context) {
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
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Save",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          onPressed: () {
            setState(() {
              widget.item.quantity = int.parse(quantityController.text);
            });
            Navigator.of(context).pop();
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
          onPressed: widget.onDelete,
          icon: Icons.delete,
          backgroundColor: Colors.red.shade300,
        ),
        SlidableAction(
          onPressed: widget.onEdit,
          icon: Icons.edit,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
