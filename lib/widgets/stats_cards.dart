import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';

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
              child: _buildStatCard(
                context: context,
                icon: Icons.savings_outlined,
                iconColor: AppConstants.successGreen,
                backgroundColor: AppConstants.lightGreen,
                title: 'Money Saved',
                value: '\$${provider.moneySaved.toStringAsFixed(0)}',
                subtitle: 'Estimated at \$${provider.userProfile?.dailyCost.toStringAsFixed(0) ?? '15'}/day',
              ),
            ),
            
            const SizedBox(width: AppConstants.paddingMedium),
            
            // Milestones Card
            Expanded(
              child: _buildStatCard(
                context: context,
                icon: Icons.emoji_events_outlined,
                iconColor: AppConstants.blueAccent,
                backgroundColor: AppConstants.lightBlue,
                title: 'Milestones',
                value: '${provider.achievedMilestonesCount}',
                subtitle: 'Achievements unlocked',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
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
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: AppConstants.textGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeXXLarge,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingSmall),
            
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}