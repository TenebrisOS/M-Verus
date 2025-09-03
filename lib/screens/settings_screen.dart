import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final controller = TextEditingController(text: themeProvider.vrscAddress);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'VRSC Address',
              ),
              onChanged: (val) => themeProvider.setVRSCAddress(val),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDark,
              onChanged: (val) => themeProvider.toggleDark(val),
            ),
            const SizedBox(height: 12),
            Text(
              'Accent Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8,
              children: Colors.primaries.map((color) {
                return ChoiceChip(
                  label: Text(color.toString().split('.').last),
                  selected: themeProvider.seedColor == color,
                  selectedColor: color,
                  backgroundColor: color.shade100,
                  labelStyle: TextStyle(
                    color: themeProvider.seedColor == color
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (_) => themeProvider.setSeedColor(color),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
