import 'package:flutter/material.dart';
import 'package:skeleton_test/src/global_widgets/molecules/cross_fade.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            //create an switchlisttile
            //when value changed to true it's set ThemeMode
            //to ThemeMode.system
            SwitchListTile.adaptive(
              value: controller.isThemeAutoBySystem,
              onChanged: controller.setThemeModeAuto,
              title: const Text('auto theme mode'),
            ),
            //create an switchlisttile it's will showed
            //when ThemeMode!=ThemeMode.system
            //when value changed to true it's set ThemeMode
            //to ThemeMode.dark
            CrossFade<bool>(
              initialData: false,
              data: controller.isThemeAutoBySystem,
              builder: (data) => data
                  ? const SizedBox()
                  : SwitchListTile.adaptive(
                      title: const Text('darkmode'),
                      value: controller.isDarkMode,
                      onChanged: controller.setThemeModeDark,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
