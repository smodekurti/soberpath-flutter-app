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
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                            child: const Icon(
                              Icons.savings_outlined,
                              color: AppConstants.successGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          const Expanded(
                            child: Text(
                              'Money Saved',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: AppConstants.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${provider.moneySaved.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXXLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.successGreen,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingSmall),
                      
                      Text(
                        'Est. \$${provider.userProfile?.dailyCost.toStringAsFixed(0) ?? "15"}/day',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: AppConstants.blueAccent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          const Expanded(
                            child: Text(
                              'Milestones',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: AppConstants.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${provider.achievedMilestonesCount}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXXLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.blueAccent,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingSmall),
                      
                      const Text(
                        'Achievements unlocked',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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