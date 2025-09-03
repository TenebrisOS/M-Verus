import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/global_stats_screen.dart';
import 'screens/farm_screen.dart';
import 'screens/settings_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (context, _) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'M-Verus',
      theme: themeProvider.theme,
      darkTheme: themeProvider.theme,
      themeMode: themeProvider.themeMode,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final indicatorColor = themeProvider.seedColor;
    final selectedIconColor = themeProvider.isDark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: indicatorColor,
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: selectedIconColor);
            }
            return IconThemeData(color: Colors.grey);
          }),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.public),
              icon: Icon(Icons.public_outlined),
              label: 'Global Stats',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.grass),
              icon: Icon(Icons.grass_outlined),
              label: 'My Farm',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const GlobalStatsScreen(),
        const FarmScreen(),
        const SettingsScreen(),
      ][currentPageIndex],
    );
  }
}
