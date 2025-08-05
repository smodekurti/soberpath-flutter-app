import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soberpath_app/widgets/safe_text.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;

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
                  padding: EdgeInsets.all(context.spacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                  context.borders.small),
                            ),
                            child: Icon(
                              Icons.savings_outlined,
                              color: context.colors.secondary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: context.spacing.medium),
                          Expanded(
                            child: SafeText(
                              'Money Saved',
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, context.typography.bodyMedium),
                                color: context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.spacing.medium),
                      AutoSizeText(
                        '\$${provider.moneySaved.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, context.typography.headlineMedium),
                          fontWeight: FontWeight.bold,
                          color: context.colors.secondary,
                        ),
                        maxLines: 1,
                        minFontSize: 16,
                        maxFontSize: 32,
                      ),
                      SizedBox(height: context.spacing.small),
                      SafeText(
                        'Est. \$${(provider.userProfile!.dailyCost * (provider.userProfile?.usageFrequency.multiplier ?? 1.0)).toStringAsFixed(0)}/day avg',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, context.typography.labelSmall),
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: context.spacing.medium),

            // Milestones Card
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(context.spacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                  context.borders.small),
                            ),
                            child: Icon(
                              Icons.emoji_events_outlined,
                              color: context.colors.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: context.spacing.medium),
                          Expanded(
                            child: SafeText(
                              'Milestones',
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, context.typography.bodyMedium),
                                color: context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.spacing.medium),
                      AutoSizeText(
                        '${provider.achievedMilestonesCount}',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, context.typography.headlineMedium),
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                        maxLines: 1,
                        minFontSize: 16,
                        maxFontSize: 32,
                      ),
                      SizedBox(height: context.spacing.small),
                      SafeText(
                        'Achievements unlocked',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, context.typography.labelSmall),
                          color: context.colors.onSurfaceVariant,
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
