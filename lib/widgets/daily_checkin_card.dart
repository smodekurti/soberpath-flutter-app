import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../services/theme_provider.dart';
import '../config/theme_extensions.dart';
import '../config/dynamic_theme_colors.dart';
import '../utils/responsive_helpers.dart' hide SafeText;

class DailyCheckInCard extends StatefulWidget {
  const DailyCheckInCard({super.key});

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard> {
  final TextEditingController _reflectionController = TextEditingController();

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        // Check if user has already checked in today
        if (provider.hasCheckedInToday) {
          return _buildCompletedCheckIn(provider);
        }

        return _buildCheckInForm(provider);
      },
    );
  }

  Widget _buildCompletedCheckIn(AppStateProvider provider) {
    final todaysCheckIn = provider.todaysCheckIn!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
            context, context.spacing.large)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.spacing.small),
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.borders.small),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: context.colors.secondary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Daily Check-in Complete',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.headlineSmall),
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),

            // Today's check-in summary
            Container(
              padding: EdgeInsets.all(context.spacing.medium),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(context.borders.medium),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodIndicator('Mood', todaysCheckIn.mood),
                      _buildMoodIndicator('Cravings', todaysCheckIn.cravingLevel),
                    ],
                  ),
                  if (todaysCheckIn.reflection.isNotEmpty) ...[
                    SizedBox(height: context.spacing.medium),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.spacing.medium),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(context.borders.small),
                        border: Border.all(
                          color: context.colors.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Reflection:',
                            style: TextStyle(
                              fontSize: context.typography.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: context.colors.onSurface,
                            ),
                          ),
                          SizedBox(height: context.spacing.small),
                          Text(
                            todaysCheckIn.reflection,
                            style: TextStyle(
                              fontSize: context.typography.bodyMedium,
                              color: context.colors.onSurface,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.spacing.medium),
            Text(
              'See you tomorrow! 💪',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, context.typography.bodyMedium),
                color: context.colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIndicator(String label, int value) {
    Color color;
    
    if (label == 'Mood') {
      if (value <= 3) { // Poor mood
        color = context.colors.error;
      } else if (value <= 6) { // Neutral mood
        color = Colors.orange;
      } else { // Good mood
        color = context.colors.secondary;
      }
    } else { // Cravings
      if (value <= 3) { // Low cravings
        color = context.colors.secondary;
      } else if (value <= 7) { // Medium cravings
        color = Colors.orange;
      } else { // High cravings
        color = context.colors.error;
      }
    }

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.typography.labelSmall,
            fontWeight: FontWeight.w500,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Text(
          '$value/10',
          style: TextStyle(
            fontSize: context.typography.bodyMedium,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInForm(AppStateProvider provider) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
            context, context.spacing.large)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.spacing.small),
                  decoration: BoxDecoration(
                    color: context.colors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.borders.small),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: context.colors.error,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Daily Check-in',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.headlineSmall),
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),

            // Mood Section
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, context.typography.titleMedium),
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: context.spacing.medium),
            Slider(
              value: provider.currentMood.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: provider.currentMood.toString(),
              onChanged: (value) {
                provider.updateCurrentMood(value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Poor (1)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Current: ${provider.currentMood}',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ),
                Text(
                  'Great (10)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),

            // Craving Level Section
            Text(
              'Craving Level',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, context.typography.titleMedium),
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: context.spacing.medium),
            Slider(
              value: provider.currentCravingLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: provider.currentCravingLevel.toString(),
              onChanged: (value) {
                provider.updateCurrentCravingLevel(value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'None (1)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Current: ${provider.currentCravingLevel}',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ),
                Text(
                  'Intense (10)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.labelSmall),
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),

            // Reflection Text Field
            Text(
              'Daily Reflection',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, context.typography.titleMedium),
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: context.spacing.medium),
            TextField(
              controller: _reflectionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'How was your day? What are you grateful for?',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                provider.updateCurrentReflection(value);
              },
            ),
            SizedBox(height: context.spacing.large),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : () => _saveCheckIn(provider),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Save Check-in',
                        style: TextStyle(
                          inherit: true,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCheckIn(AppStateProvider provider) async {
    // Get theme colors before async operation to avoid Provider access in event handler
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final dynamicColors = DynamicThemeColors(isDarkMode: themeProvider.isDarkMode);
    final secondaryColor = dynamicColors.secondary;
    final errorColor = dynamicColors.error;
    
    final success = await provider.saveDailyCheckIn();

    if (success && mounted) {
      _reflectionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Check-in saved! Great job taking care of yourself today.'),
          backgroundColor: secondaryColor,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save check-in. Please try again.'),
          backgroundColor: errorColor,
        ),
      );
    }
  }
}
