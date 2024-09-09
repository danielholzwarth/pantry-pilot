import 'package:app/widgets/storage_drawer_tile.dart';
import 'package:flutter/material.dart';

class StorageDrawer extends StatelessWidget {
  const StorageDrawer({super.key});

  void logoutUser(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login_or_register_page");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),
              const StorageDrawerTile(title: "S T O R A G E", iconData: Icons.storage),
              StorageDrawerTile(
                title: "H I S T O R Y",
                iconData: Icons.history,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history_page');
                },
              ),
              StorageDrawerTile(
                title: "S T A T I S T I C S",
                iconData: Icons.auto_graph,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/statistics_page');
                },
              ),
              StorageDrawerTile(
                title: "S E T T I N G S",
                iconData: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings_page');
                },
              ),
            ],
          ),
          StorageDrawerTile(
            title: "L O G O U T",
            iconData: Icons.logout,
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            onTap: () {
              Navigator.pop(context);
              logoutUser(context);
            },
          ),
        ],
      ),
    );
  }
}
