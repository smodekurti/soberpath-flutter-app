import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Money Saved Card
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConstants.lightGreen,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusSmall),
                            ),
                            child: const Icon(
                              Icons.savings_outlined,
                              color: AppConstants.successGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: SafeText(
                              'Money Saved',
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, AppConstants.fontSizeMedium),
                                color: AppConstants.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      AutoSizeText(
                        '\$${provider.moneySaved.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, AppConstants.fontSizeXXLarge),
                          fontWeight: FontWeight.bold,
                          color: AppConstants.successGreen,
                        ),
                        maxLines: 1,
                        minFontSize: 16,
                        maxFontSize: 32,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      SafeText(
                        'Est. \$${(provider.userProfile!.dailyCost * (provider.userProfile?.usageFrequency.multiplier ?? 1.0)).toStringAsFixed(0)}/day avg',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, AppConstants.fontSizeSmall),
                          color: AppConstants.textGray,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppConstants.paddingMedium),

            // Milestones Card
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConstants.lightBlue,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusSmall),
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: AppConstants.blueAccent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: SafeText(
                              'Milestones',
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, AppConstants.fontSizeMedium),
                                color: AppConstants.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      AutoSizeText(
                        '${provider.achievedMilestonesCount}',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, AppConstants.fontSizeXXLarge),
                          fontWeight: FontWeight.bold,
                          color: AppConstants.blueAccent,
                        ),
                        maxLines: 1,
                        minFontSize: 16,
                        maxFontSize: 32,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      SafeText(
                        'Achievements unlocked',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, AppConstants.fontSizeSmall),
                          color: AppConstants.textGray,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
