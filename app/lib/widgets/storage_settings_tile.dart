import 'package:flutter/material.dart';

class StorageSettingsTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;

  const StorageSettingsTile({
    super.key,
    required this.title,
    required this.trailing,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 25),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}
