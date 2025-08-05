import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.spacing.large),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.borders.large),
            border: Border(
              left: BorderSide(
                color: context.colors.primary,
                width: 4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(context.spacing.small),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.borders.small),
                    ),
                    child: Icon(
                      Icons.format_quote,
                      color: context.colors.primary,
                      size: 20,
                    ),
                  ),
                  
                  SizedBox(width: context.spacing.medium),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.todaysQuote,
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, context.typography.titleMedium),
                            fontStyle: FontStyle.italic,
                            color: context.colors.primary,
                            height: 1.4,
                          ),
                          maxLines: 6,
                        ),
                        
                        SizedBox(height: context.spacing.small),
                        
                        Text(
                          'Daily Inspiration',
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, context.typography.bodyMedium),
                            color: context.colors.primary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}