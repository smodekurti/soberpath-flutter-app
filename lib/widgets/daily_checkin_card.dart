import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart'; // Import responsive helpers

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
            context, AppConstants.paddingLarge)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlexibleRow(
              // Use FlexibleRow here
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.lightGreen,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                SafeText(
                  'Daily Check-in Complete',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeXLarge),
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Today's check-in summary
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.backgroundGray,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodIndicator('Mood', todaysCheckIn.mood),
                      _buildMoodIndicator(
                          'Cravings', todaysCheckIn.cravingLevel),
                    ],
                  ),
                  if (todaysCheckIn.reflection.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.paddingMedium),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Reflection:',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textDark,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          SafeText(
                            todaysCheckIn.reflection,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: AppConstants.textGray,
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
            const SizedBox(height: AppConstants.paddingMedium),
            SafeText(
              'Great job checking in today! See you tomorrow.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeMedium),
                color: AppConstants.successGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIndicator(String label, int value) {
    Color color;
    IconData icon;

    if (label == 'Mood') {
      if (value <= AppConstants.moodPoor) {
        color = AppConstants.dangerRed;
        icon = Icons.sentiment_very_dissatisfied;
      } else if (value <= AppConstants.moodNeutral) {
        color = AppConstants.warningYellow;
        icon = Icons.sentiment_neutral;
      } else {
        color = AppConstants.successGreen;
        icon = Icons.sentiment_very_satisfied;
      }
    } else {
      if (value <= AppConstants.cravingNone) {
        color = AppConstants.successGreen;
        icon = Icons.mood;
      } else if (value <= AppConstants.cravingWarning) {
        color = AppConstants.warningYellow;
        icon = Icons.warning_amber;
      } else {
        color = AppConstants.dangerRed;
        icon = Icons.crisis_alert;
      }
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppConstants.textGray,
          ),
        ),
        Text(
          '$value/10',
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
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
            context, AppConstants.paddingLarge)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.lightRed,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppConstants.dangerRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                SafeText(
                  'Daily Check-in',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeXLarge),
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Mood Slider
            SafeText(
              'How are you feeling today? (1-10)',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
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
                SafeText(
                  'Poor (1)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    color: AppConstants.textGray,
                  ),
                ),
                SafeText(
                  'Current: ${provider.currentMood}',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryPurple,
                  ),
                ),
                SafeText(
                  'Excellent (10)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    color: AppConstants.textGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Craving Level Slider
            SafeText(
              'Craving Level (1-10)',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
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
                SafeText(
                  'None (1)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    color: AppConstants.textGray,
                  ),
                ),
                SafeText(
                  'Current: ${provider.currentCravingLevel}',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryPurple,
                  ),
                ),
                SafeText(
                  'Intense (10)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    color: AppConstants.textGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Reflection Text Field
            SafeText(
              'Daily Reflection',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
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
            const SizedBox(height: AppConstants.paddingLarge),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    provider.isLoading ? null : () => _saveCheckIn(provider),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCheckIn(AppStateProvider provider) async {
    final success = await provider.saveDailyCheckIn();

    if (success && mounted) {
      _reflectionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Check-in saved! Great job taking care of yourself today.'),
          backgroundColor: AppConstants.successGreen,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save check-in. Please try again.'),
          backgroundColor: AppConstants.dangerRed,
        ),
      );
    }
  }
}
