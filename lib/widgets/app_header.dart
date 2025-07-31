import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final stats = provider.sobrietyStats;
        
        return Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.purpleGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingLarge,
                AppConstants.paddingLarge,
                AppConstants.paddingLarge,
                AppConstants.paddingXLarge,
              ),
              child: Column(
                children: [
                  // Header with app name and days counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeXXLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppConstants.appTagline,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: Colors.white.withValues(alpha: .9),
                            ),
                          ),
                        ],
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .3),
                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                              ),
                              child: const Icon(
                                Icons.savings_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${provider.moneySaved.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeLarge,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'saved',
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                    color: Colors.white.withValues(alpha: .9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}