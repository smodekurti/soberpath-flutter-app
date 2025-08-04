import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeText(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, AppConstants.fontSizeXXLarge),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            SafeText(
                              AppConstants.appTagline,
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, AppConstants.fontSizeMedium),
                                color: Colors.white.withValues(alpha: .9),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
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
                                AutoSizeText(
                                  '\$${provider.moneySaved.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                        context, AppConstants.fontSizeLarge),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 12,
                                  maxFontSize: 18,
                                ),
                                SafeText(
                                  'saved',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                        context, AppConstants.fontSizeSmall),
                                    color: Colors.white.withValues(alpha: .9),
                                  ),
                                  maxLines: 1,
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