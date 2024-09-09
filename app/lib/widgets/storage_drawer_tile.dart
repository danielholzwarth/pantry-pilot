import 'package:flutter/material.dart';

class StorageDrawerTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;

  const StorageDrawerTile({
    super.key,
    required this.title,
    required this.iconData,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 25),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(title),
        onTap: onTap ?? () => Navigator.pop(context),
      ),
    );
  }
}
