import 'package:app/theme/theme_provider.dart';
import 'package:app/widgets/storage_back_button.dart';
import 'package:app/widgets/storage_settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, left: 25),
            child: Row(
              children: [StorageBackButton()],
            ),
          ),
          const SizedBox(height: 25),
          StorageSettingsTile(
            title: "Darkmode",
            trailing: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
