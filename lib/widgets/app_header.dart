import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soberpath_app/widgets/safe_text.dart';
//import "package:auto_size_text/auto_size_text.dart";
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../config/app_config.dart';
import '../utils/responsive_helpers.dart' hide SafeText;


class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        
        return Container(
          decoration: BoxDecoration(
            gradient: context.colors.primaryGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.spacing.large,
                context.spacing.large,
                context.spacing.large,
                context.spacing.large,
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
                              AppConfig.info.name,
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, context.typography.headlineLarge),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            SafeText(
                              AppConfig.info.tagline,
                              style: TextStyle(
                                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                    context, context.typography.bodyMedium),
                                color: Colors.white.withValues(alpha: .9),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.medium,
                          vertical: context.spacing.small,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(context.borders.medium),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .3),
                                borderRadius: BorderRadius.circular(context.borders.small),
                              ),
                              child: const Icon(
                                Icons.savings_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: context.spacing.small),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  '\$${provider.moneySaved.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                        context, context.typography.bodyLarge),
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
                                        context, context.typography.labelSmall),
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