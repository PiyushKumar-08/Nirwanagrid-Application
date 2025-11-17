import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/settings/theme/theme_provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: theme.dividerColor,
            height: 1.0,
            margin: const EdgeInsets.symmetric(horizontal: 80),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ThemeOption(
                  label: 'Light',
                  isSelected: themeProvider.themeMode == ThemeMode.light && themeProvider.themeMode != ThemeMode.system,
                  onTap: () => themeProvider.setTheme(ThemeMode.light),
                  isLight: true,
                ),
                ThemeOption(
                  label: 'Dark',
                  isSelected: themeProvider.themeMode == ThemeMode.dark && themeProvider.themeMode != ThemeMode.system,
                  onTap: () => themeProvider.setTheme(ThemeMode.dark),
                  isLight: false,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(50), // Pill shape
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.brightness_6_outlined),
                      SizedBox(width: 16),
                      Text('System default'),
                    ],
                  ),
                  Switch(
                    value: themeProvider.themeMode == ThemeMode.system,
                    onChanged: (isOn) {
                      themeProvider.setTheme(isOn
                          ? ThemeMode.system
                          : (MediaQuery.of(context).platformBrightness == Brightness.dark
                              ? ThemeMode.dark
                              : ThemeMode.light));
                    },
                    activeColor: theme.primaryColor,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // You might want to save the theme preference to device storage here
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text('Apply'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLight;

  const ThemeOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previewColor = isLight ? Colors.white : const Color(0xFF212121);
    final itemColor = isLight ? Colors.grey.shade300 : Colors.grey.shade700;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 140,
            height: 260,
            decoration: BoxDecoration(
              color: previewColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                // Simplified visual representation of the theme
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      CircleAvatar(radius: 15, backgroundColor: itemColor),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           CircleAvatar(radius: 8, backgroundColor: itemColor),
                           CircleAvatar(radius: 8, backgroundColor: itemColor),
                        ],
                      ),
                       const SizedBox(height: 20),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List.generate(6, (index) => 
                          Container(
                            height: 35, 
                            width: 35, 
                            decoration: BoxDecoration(
                              color: itemColor,
                              borderRadius: BorderRadius.circular(8)
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.primaryColor,
                      child:
                          const Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(label, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

