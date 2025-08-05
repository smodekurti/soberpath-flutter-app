import 'package:flutter/material.dart';
import '../config/theme_extensions.dart';
import 'home_screen.dart';
import 'journal_screen.dart';
import 'progress_screen.dart';
import 'help_connect_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex; // Add this parameter for notification navigation

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0, // Add this parameter
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex; // Change to late

  // Add method to handle navigation from notifications
  void navigateToCheckIn() {
    setState(() {
      _currentIndex = 0; // Navigate to Home screen where daily check-in is
    });
  }

  late final List<Widget> _screens;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
      label: 'Journal',
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
      label: 'Progress',
    ),
    NavigationItem(
      icon: Icons.help_outline,
      activeIcon: Icons.help,
      label: 'Help & Connect',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Initialize with provided index

    // Initialize screens
    _screens = [
      const HomeScreen(),
      const JournalScreen(),
      const ProgressScreen(),
      const HelpConnectScreen(),
      const SettingsScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80, // Fixed height to prevent overflow
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.small,
              vertical: context.spacing.small,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: context.animations.fast,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing.small,
                        vertical: context.spacing.small,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                            context.borders.medium),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: context.animations.fast,
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              key: ValueKey(isSelected),
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.onSurfaceVariant,
                              size: 22, // Slightly smaller icon
                            ),
                          ),
                          const SizedBox(height: 2), // Reduced spacing
                          Flexible(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: context.typography.labelSmall,
                                fontWeight: isSelected
                                    ? context.typography.semiBold
                                    : context.typography.medium,
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
