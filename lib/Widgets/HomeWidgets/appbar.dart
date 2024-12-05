import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/home_screen_provider.dart';

Container appBarWithSearch(ThemeData themeData, BuildContext context) {
  final currentTheme = AdaptiveTheme.of(context).mode;
  return Container(
    height: 150,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          themeData.colorScheme.primary,
          themeData.colorScheme.onPrimaryFixedVariant,
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "To Do List",
                style: themeData.textTheme.titleLarge!.apply(
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (AdaptiveTheme.of(context).mode.isDark) {
                    AdaptiveTheme.of(context)
                        .setThemeMode(AdaptiveThemeMode.light);
                  } else {
                    AdaptiveTheme.of(context)
                        .setThemeMode(AdaptiveThemeMode.dark);
                  }
                },
                icon: Icon(
                  currentTheme.isDark ? Icons.sunny : Icons.dark_mode,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Consumer<HomeScreenProvider>(
            builder: (context, provider, child) => SearchBar(
              elevation: const WidgetStatePropertyAll(0),
              controller: provider.controller,
              leading: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: "Search tasks...",
              hintStyle: const WidgetStatePropertyAll(
                TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                provider.searchKeyWordNotifier.value = provider.controller.text;
              },
            ),
          )
        ],
      ),
    ),
  );
}
