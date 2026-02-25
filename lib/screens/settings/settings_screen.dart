import 'package:task_manager/repositories/theme/theme_provider.dart';
import 'package:task_manager/repositories/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Settings')),
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.white),
            title: Text('Dark Theme', style: TextStyle(color: Colors.white)),
            trailing: Switch(
              value: themeProvider.currentTheme.name == 'dark' ? true : false,
              onChanged: (value) {
                themeProvider.currentTheme.name == 'dark'
                    ? themeProvider.setTheme(nativeTheme)
                    : themeProvider.setTheme(darkTheme);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.white),
            title: Text('Notifications', style: TextStyle(color: Colors.white)),
            trailing: Switch(value: true, onChanged: (value) => {}),
          ),
        ],
      ),
    );
  }
}
